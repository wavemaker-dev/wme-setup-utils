import os
import json
import requests
import time
import sys
import argparse


def parsers(arg):
    # Making sure all mandatory parameters are received
    if None not in (arg.protocol, arg.domain, arg.user_name, arg.password, arg.pem_file, arg.username_instance):
        protocol_a = arg.protocol
        domain_a = arg.domain
        user_name_a = arg.user_name
        password_a = arg.password
        pem_file_a = arg.pem_file
        instance_studio_names_a = arg.instance_studio_names
        instance_stage_names_a = arg.instance_stage_names
        instance_qa_names_a = arg.instance_qa_names
        std_ips_a = arg.studio_ips
        stg_ips_a = arg.stage_ips
        qa_ips_a = arg.qa_ips
        username_instance_a = arg.username_instance

        # Making sure at-least one of three type od instances details are received
        if std_ips_a == "Dummy" and stg_ips_a == "Dummy" and qa_ips_a == "Dummy":
            print("\nExiting..............")
            print(
                "Between options -stdip/--studio-ip -stgip/--stage-ip -qaip/--qa-ip you have to provide atleast one optiona as you have to create instances")
            sys.exit(0)
        else:
            instance_name_studio = list(map(str, instance_studio_names_a.split(',')))
            instance_name_stage = list(map(str, instance_stage_names_a.split(',')))
            instance_name_qa = list(map(str, instance_qa_names_a.split(',')))
            studio_ips_list = list(map(str, std_ips_a.split(',')))
            stage_ips_list = list(map(str, stg_ips_a.split(',')))
            qa_ips_list = list(map(str, qa_ips_a.split(',')))

            # Creating an directory with key being instance name and value being instance ip
            if len(instance_name_studio) == len(studio_ips_list) and len(instance_name_stage) == len(
                    stage_ips_list) and len(instance_name_qa) == len(qa_ips_list):
                studio_detals_dict = (dict(zip(instance_name_studio, studio_ips_list)))
                stage_detals_dict = (dict(zip(instance_name_stage, stage_ips_list)))
                qa_detals_dict = (dict(zip(instance_name_qa, qa_ips_list)))
            else:
                print("\nExiting..............")
                print(
                    "You have to provide same length of input for (-stgip,-istgn)/(-stdip,-istdn)/(-qaip,-iqan) pairs as the instances are created with correspoig name to that of ip")
                sys.exit(0)
        
        #uncomment below line to see arguments after parsing
        # print(protocol_a, domain_a, user_name_a, password_a, pem_file_a, username_instance_a, studio_detals_dict, stage_detals_dict, qa_detals_dict)
        return protocol_a, domain_a, user_name_a, password_a, pem_file_a, username_instance_a, studio_detals_dict, stage_detals_dict, qa_detals_dict

    else:
        print("\nExiting..............")
        print(
            "Options -pr/--protocol -d/--domain -u/--username -p/--password  -pf/--pem-name -iu/--instance-username are mandatory fields")
        sys.exit(0)


def get_cookie(url, username_, password_):
    print("\n----Getting AUTH_COOKIE----")
    try:
        session = requests.Session()
        authentication_details = {'j_username': username_, 'j_password': password_, 'regButton': 'Login'}
        url_cookie = url + "/login/authenticate"
        response = session.post(url=url_cookie, data=authentication_details, allow_redirects=False)

        if response.status_code != 302:
            if response.status_code == 401:
                print("Exiting................")
                print("Encountered 404 plz recheck the username and password provided")
                sys.exit(response.status_code)
            else:
                print("Exiting................")
                print("Encountered status " + str(response.status_code) + " while getting cookie for url " + str(url))
                sys.exit(response.status_code)

        try:
            cookies = session.cookies.get_dict()
            print("\n----Received AUTH_COOKIE----")
            return cookies['auth_cookie']

        except ValueError:
            print("\nExiting..............")
            print("\nExpected cookie is not received")
            sys.exit(0)

    except requests.exceptions.ConnectionError:
        print("\nExiting.........\nConnection refused check the connection")
        exit(-1)


def print_status(url_api, resp, code=200):
    status_code = resp.status_code
    print("The api request fo the API of " + str(url_api) + " has returned status code  " + str(status_code))
    # checking if desired status is received or not
    if status_code != code:
        print(resp.text)
        print("\nExiting...............")
        print("\nExited because " + str(status_code) + " is encountered")
        exit(str(status_code))


def get_token(url, file_p, user_name_instance, instance_nm, host_ip_nm, shrd_id_nm, auth__cookie):
    print("\nGetting Token\n")
    url_api = url + "/container-services/rest/admin/instances/instance-info"
    path_pem = file_p
    details = {"instanceName": instance_nm, "hostName": host_ip_nm, "port": "22", "userName": user_name_instance,
               "password": "", "shardId": shrd_id_nm}
    files = {
        'instanceDetails': (None, json.dumps(details), 'application/json'),
        'file': (os.path.basename(path_pem), open(str(path_pem), "rb"), 'application/octet-stream')
    }
    resp = requests.post(url=url_api, files=files, headers={"Cookie": "auth_cookie=" + auth__cookie})
    print_status(url_api, resp, 200)
    json_object = resp.json()
    print("\nReceived token")
    try:
        return json_object["success"]["body"]["keyFileToken"]
    except ValueError:
        print('Expected token is not received')
        sys.exit(0)


def create_instance(url, user_name_instance, instance_nm, host_ip_nm, shrd_id_nm, auth__cookie, token):
    print("\nCreating Instance\n")
    url_instance = url + "/container-services/rest/admin/instances"
    resp = requests.post(url=url_instance,
                         json={"instanceName": instance_nm, "hostName": host_ip_nm, "port": "22",
                               "userName": user_name_instance,
                               "password": "", "shardId": shrd_id_nm, "keyFileToken": token},
                         headers={"Cookie": "auth_cookie=" + auth__cookie,
                                  "Content-Type": "application/json; boundary=----WebKitFormBoundary7lJGG2lciCsAk9yB"})
    print_status(url_instance, resp, 200)
    print("\nCreated Instance with name " + instance_nm + " with ip " + host_ip_nm + " in the id " + shrd_id_nm)


def create_instances(url, pem_file_a, username_instance_a, auth_cookie_a, std_details_a, stg_ips_a, qa_ips_a):
    try:
        open(str(pem_file_a), "rb")
    except FileNotFoundError:
        print("No file present in the path " + pem_file_a + " plz cross verify")
        sys.exit(-1)
    print("\n----Creation of Instances----")

    # For Studio instances
    if next(iter(std_details_a.values())) != "Dummy":
        for instance__name, host_ip in std_details_a.items():
            key_token = get_token(url, pem_file_a, username_instance_a, instance__name, host_ip,
                                  "shard-147aab1595f3qk135yK2H", auth_cookie_a)
            create_instance(url, username_instance_a, instance__name, host_ip, "shard-147aab1595f3qk135yK2H",
                            auth_cookie_a, key_token)

    # For Stage instances
    if next(iter(stg_ips_a.values())) != "Dummy":
        for instance__name, host_ip in stg_ips_a.items():
            key_token = get_token(url, pem_file_a, username_instance_a, instance__name, host_ip,
                                  "shard-1588b1ecb1eLy6lWYCGNJ", auth_cookie_a)
            create_instance(url, username_instance_a, instance__name, host_ip, "shard-1588b1ecb1eLy6lWYCGNJ",
                            auth_cookie_a, key_token)

    # For QA instances
    if next(iter(qa_ips_a.values())) != "Dummy":
        for instance__name, host_ip in qa_ips_a.items():
            key_token = get_token(url, pem_file_a, username_instance_a, instance__name, host_ip,
                                  "shard-147a5c2f5c84SqfSJj1QT", auth_cookie_a)
            create_instance(url, username_instance_a, instance__name, host_ip, "shard-147a5c2f5c84SqfSJj1QT",
                            auth_cookie_a, key_token)
    print("\n----End of Creation----")


if __name__ == "__main__":
    start_time = time.time()

    # Arguments setting
    parser = argparse.ArgumentParser()
    parser.add_argument("-pr", "--protocol", dest="protocol", help="Protocol")
    parser.add_argument("-d", "--domain", dest="domain", help="Domain")
    parser.add_argument("-u", "--username", dest="user_name", help="Username")
    parser.add_argument("-p", "--password", dest="password", help="Password")
    parser.add_argument("-istdn", "--instance-studio-names", dest="instance_studio_names", default="Dummy",
                        help="studio names seperated by ','")
    parser.add_argument("-istgn", "--instance-stage-names", dest="instance_stage_names", default="Dummy",
                        help="stage names seperated by ','")
    parser.add_argument("-iqan", "--instance-qa-names", dest="instance_qa_names", default="Dummy",
                        help="qa name seperated by ','")
    parser.add_argument("-pf", "--pem-name", dest="pem_file", help="path for pem file name")
    parser.add_argument("-stdip", "--studio-ip", dest="studio_ips", default="Dummy", help="studio ips seperated by ','")
    parser.add_argument("-stgip", "--stage-ip", dest="stage_ips", default="Dummy", help="stage ips seperated by ','")
    parser.add_argument("-qaip", "--qa-ip", dest="qa_ips", default="Dummy", help="QA ips seperated by ','")
    parser.add_argument("-iu", "--instance-username", dest="username_instance", help="username for_instance")

    # Parsing arguments
    args = parser.parse_args()
    protocol, domain, user_name, password, pem_file, username_instance, std_details, stg_ips, qa_ips = parsers(args)

    # Generating URL
    URL = str(protocol) + "://" + str(domain)

    # Get Cookie
    auth_cookie = get_cookie(URL, user_name, password)

    # Creation of Instances
    create_instances(URL, pem_file, username_instance, auth_cookie, std_details, stg_ips, qa_ips)

    print("\n"+os.path.basename(__file__)+" Script has ended")
    end_time = time.time()
    mints, secs = divmod(end_time - start_time, 60)
    print("Total running time %d min:%d sec.\n" % (mints, secs))

