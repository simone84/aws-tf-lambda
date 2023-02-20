import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    client = boto3.client('s3')
    response = client.list_buckets()
    print (response)
    
    return {
        'body': json.dumps('Done')
    }