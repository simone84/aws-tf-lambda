import json
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    client = boto3.client('ec2')
    response = client.describe_instances()
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            print(instance['InstanceId'])
    
    return {
        'body': json.dumps('Done')
    }