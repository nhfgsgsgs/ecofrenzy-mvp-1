import os
import boto3
import json
import requests
from firebase_admin import messaging, initialize_app, credentials
import firebase_admin

rekognition_client = boto3.client("rekognition")
sagemaker_runtime_client = boto3.client("sagemaker-runtime")
ssm_client = boto3.client("ssm")
sns_client = boto3.client("sns")

api_endpoint = os.environ["EXPRESS_API_ENDPOINT"]
sns_topic_arn = os.environ["SNS_COMPLETE_CHALLENGE_TOPIC"]

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
    userId = message_data["userId"]

    # Retrieve the S3 bucket and key from the message
    url = message_data["url"]
    bucket = url.split("/")[2].split(".")[0]
    key = "/".join(url.split("/")[3:])

    # Retrieve the verification questions and desired answers from the message
    mission = message_data["mission"]
    vefications = mission["verification"]
    verif_questions = []
    desired_answers = []
    for vefication in vefications:
        verif_questions.append(
            vefication["question"]
        )  # should be as type list of questions
        desired_answers.append(
            vefication["desiredAnswer"]
        )  # as type list of answers respectively

    print(verif_questions, desired_answers)

    # Moderation with Amazon Rekognition
    response_rekognition = rekognition_client.detect_moderation_labels(
        Image={"S3Object": {"Bucket": bucket, "Name": key}}
    )

    print("Invoking Rekognition API")
    print("Moderation result for " + key)
    print(response_rekognition)

    # Complete here to check if the image violates the policy
    moderation_labels = response_rekognition.get("ModerationLabels", [])
    # Modify this list based on your sensitivity policy
    violation_labels = ["Explicit Nudity", "Sexual Activity"]

    violation_detected = any(
        label["Name"] in violation_labels for label in moderation_labels
    )

    if violation_detected:
        # Notify the user that the image violates the sensitivity policy
        print("Warning: Image violates sensitivity policy. Reupload is required!")
        return

    print("Invoking SageMaker endpoint: " + endpoint_name)

    # VQA with Amazon SageMaker
    pass_one_question = False
    for verif_question, desired_answer in zip(verif_questions, desired_answers):
        request_body = {
            "question": verif_question,
            "image": url,
        }
        payload = json.dumps(request_body)
        response_sagemaker = sagemaker_runtime_client.invoke_endpoint(
            EndpointName=endpoint_name,
            ContentType="application/json",
            Body=payload,
        )
        response_payload = json.load(response_sagemaker["Body"])

        print("Request payload for " + key)
        print(payload)

        highest_score = 0
        best_answer = None

        for answer in response_payload:
            if answer["score"] > highest_score:
                highest_score = answer["score"]
                best_answer = answer["answer"]

        if highest_score > 0.7 and best_answer == desired_answer:
            pass_one_question = True
            break

    # Process the VQA response
    if pass_one_question:
        # Calling API to update mission status
        # Should call Update_Mission here
        url = f"{api_endpoint}/api/user/updateToday"

        payload = {
            "userId": userId,
            "missionId": mission["_id"],
        }

        # Define the headers, if any are required. This could include authentication tokens.
        headers = {
            "Content-Type": "application/json",
        }

        response = requests.put(url, headers=headers, json=payload)

        if response.status_code == 200:
            print("Successfully updated mission status via API")
        else:
            print(
                "Failed to update mission status via API. Response code:",
                response.status_code,
            )
    else:
        # Notify user that image isnot verified relation to the challenge.And user should reupload the image
        print("Image is not verified. Reupload is required!")
