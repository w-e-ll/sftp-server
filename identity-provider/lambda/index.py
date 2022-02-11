import os
import json
import boto3
import base64
from botocore.exceptions import ClientError


def lambda_handler(event, context):
    resp_data = {}
    auth = get_secret

    if 'username' not in event or 'serverId' not in event:
        print("Incoming username or serverId missing  - Unexpected")
        return resp_data

    input_username = event['username']
    print("Username: {}, ServerId: {}".format(input_username, event['serverId']))

    if 'password' in event:
        input_password = event['password']
    else:
        print("No password, checking for SSH public key")
        input_password = ''

    print("input_password1", input_password)

    # Lookup of part of account in creds store
    path_part = os.environ.get("path_part")
    resp = auth(path_part)

    if resp is not None:
        resp_dict = resp
    else:
        print("Authentication Error")
        return {}

    current_user_dict = {}
    if input_username in resp_dict:
        current_user_dict = resp_dict[input_username]

    if input_password != '':
        if 'Password' in current_user_dict:
            resp_password = current_user_dict['Password']
        else:
            print("Unable to authenticate user - No field match in Secrets Manager for password")
            return {}

        if resp_password != input_password:
            print("Unable to authenticate user - Incoming password does not match stored")
            return {}
    else:
        # SSH Public Key Auth Flow - The incoming password was empty so we are trying ssh auth and
        # need to return the public key data if we have it
        if 'PublicKey' in current_user_dict:
            resp_data['PublicKeys'] = [current_user_dict['PublicKey']]
        else:
            print("Unable to authenticate user - No public keys found")
            return {}

    # If we've got this far then we've either authenticated the user by password or
    # we're using SSH public key auth and we've begun constructing the data response.
    # Check for each key value pair. These are required so set to empty string if missing
    if 'Role' in current_user_dict:
        resp_data['Role'] = current_user_dict['Role']
    else:
        print("No field match for role - Set empty string in response")
        resp_data['Role'] = ''

    # These are optional so ignore if not present
    if 'Policy' in current_user_dict:
        resp_data['Policy'] = current_user_dict['Policy']

    if 'HomeDirectoryDetails' in current_user_dict:
        print("HomeDirectoryDetails found - Applying setting for virtual folders")
        resp_data['HomeDirectoryDetails'] = current_user_dict['HomeDirectoryDetails']
        resp_data['HomeDirectoryType'] = "LOGICAL"
    elif 'HomeDirectory' in current_user_dict:
        print("HomeDirectory found - Cannot be used with HomeDirectoryDetails")
        resp_data['HomeDirectory'] = current_user_dict['HomeDirectory']
    else:
        print("HomeDirectory not found - Defaulting to /")

    print("Completed Response Data: " + json.dumps(resp_data))
    return resp_data


def get_secret(path_part):
    region = os.environ.get("region")
    secret_id = os.environ.get("secret_id")
    service_name = os.environ.get("service_name")
    print("Secrets Manager Region: " + region)

    client = boto3.session.Session().client(service_name=service_name, region_name=region)

    try:
        resp = client.get_secret_value(SecretId=secret_id + "/" + path_part)
        # Decrypts secret using the associated KMS CMK.
        # Depending on whether the secret is a string or binary, one of these fields will be populated.
        print(resp['SecretString'])
        if 'SecretString' in resp:
            print("Found Secret String")
            return json.loads(resp['SecretString'])
        else:
            print("Found Binary Secret")
            return json.loads(base64.b64decode(resp['SecretBinary']))
    except ClientError as err:
        print('Error Talking to SecretsManager: ' + err.response['Error']['Code'] + ', Message: ' + str(err))
        return None
