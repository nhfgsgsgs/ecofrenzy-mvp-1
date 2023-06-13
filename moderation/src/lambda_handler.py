import boto3
import json

rekognition_client = boto3.client("rekognition")
sagemaker_runtime_client = boto3.client("sagemaker-runtime")
ssm_client = boto3.client("ssm")

# Retrieve the endpoint name from Parameter Store
try:
    response = ssm_client.get_parameter(Name="hfvqa_model_endpoint")
    endpoint_name = response["Parameter"]["Value"]
except Exception as e:
    print(e)
    raise e


def lambda_handler(event, context):
    # Parse the SNS message
    message = event["Records"][0]["Sns"]["Message"]
    message_data = json.loads(message)

    print("Message data:")
    print(message_data)
