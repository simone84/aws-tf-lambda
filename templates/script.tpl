import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    client = boto3.client('')
    response = client.()
    
    return {
        'body': json.dumps('Done')
    }