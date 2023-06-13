import boto3
import json
import urllib.parse

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

    # Extract the image URL and challenge info from the message
    image_url = message_data["imageUrl"]
    challenge_info = message_data["challengeInfo"]

    try:
        # Moderation with Rekognition
        response_rekog = rekognition_client.detect_moderation_labels(
            Image={"S3Object": {"Bucket": bucket, "Name": key}}
        )
        print("Detected labels for " + key)
        print(response_rekog)

        # VQA with SageMaker
        request_body = {
            "inputs": {
                "question": "is there an elephant?",
                "image": "https://www.wwf.org.uk/sites/default/files/styles/social_share_image/public/2018-10/Large_WW1113482.jpg",
            }
        }

        payload = json.dumps(request_body)

        response_sagemaker = sagemaker_runtime_client.invoke_endpoint(
            EndpointName=endpoint_name,
            ContentType="application/json",
            Body=payload,
        )

        print("VQA response for " + key)
        print(response_sagemaker)

    except Exception as e:
        print(e)
        raise e
