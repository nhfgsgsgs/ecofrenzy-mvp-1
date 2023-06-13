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

    # Retrieve the S3 bucket and key from the message
    url = message_data["url"]
    bucket = url.split("/")[2].split(".")[0]
    key = "/".join(url.split("/")[3:])

    # Moderation with Amazon Rekognition
    response_rekognition = rekognition_client.detect_moderation_labels(
        Image={"S3Object": {"Bucket": bucket, "Name": key}}
    )
    print("Detected labels for " + key)
    print(response_rekognition)

    # VQA with Amazon SageMaker
    request_body = {
        "question": "Is this image safe for work?",
        "image": url,
    }
    payload = json.dumps(request_body)

    print("Request payload for " + key)
    print(payload)

    print("Invoking SageMaker endpoint: " + endpoint_name)

    response_sagemaker = sagemaker_runtime_client.invoke_endpoint(
        EndpointName=endpoint_name,
        ContentType="application/json",
        Body=payload,
    )

    response_payload = json.load(response_sagemaker["Body"])

    print("VQA result for " + key)
    print(response_payload)
