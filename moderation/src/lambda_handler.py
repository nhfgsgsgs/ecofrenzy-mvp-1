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
    mission = message_data["mission"]
    verif_questions = mission['verification'][0]["question"] #should be as type list of questions
    desired_answers = mission['verification'][0]["desiredAnswer"] #as type list of answers respectively
    
    print(verif_questions, desired_answers)

    # Moderation with Amazon Rekognition
    response_rekognition = rekognition_client.detect_moderation_labels(
        Image={"S3Object": {"Bucket": bucket, "Name": key}}
    )
    #Complete here to check if the image violates the policy
    moderation_labels = response_rekognition.get("ModerationLabels", [])
    violation_labels = ["Explicit Nudity", "Sexual Activity"]  # Modify this list based on your sensitivity policy
    
    violation_detected = any(label["Name"] in violation_labels for label in moderation_labels)

    if violation_detected:
        # Notify the user that the image violates the sensitivity policy
        print("Warning: Image violates sensitivity policy. Reupload is required!")
        return



    # print("Detected labels for " + key)
    # print(response_rekognition)

    # VQA with Amazon SageMaker
    request_body = {
        "question": verif_questions,
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

    # print("VQA result for " + key)
    # print(response_payload)

    #Process the VQA response
    pass_one_question = False
    for question, desired_answer in zip(verif_questions, desired_answers):
        highest_score = 0
        best_answer = None

        for answer in response_payload:
            if answer["score"] > highest_score:
                highest_score = answer["score"]
                best_answer = answer["answer"]

        if highest_score > 0.7 and best_answer == desired_answer:
            pass_one_question = True
            break
    if pass_one_question:
        #Calling API to update mission status
        #Should call Update_Mission here 
        print("Mission status updated: Done")
    else: 
        #Notify user that image isnot verified relation to the challenge.And user should reupload the image
        print("Image is not verified. Reupload is required!")






