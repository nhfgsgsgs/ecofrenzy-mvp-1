import os
import json
import boto3
import sagemaker
from sagemaker.huggingface import HuggingFaceModel


def handler(event, context):
    try:
        role = sagemaker.get_execution_role()
    except ValueError:
        role_name = os.getenv("EXECUTION_ROLE_NAME")
        iam = boto3.client("iam")
        role = iam.get_role(RoleName=role_name)["Role"]["Arn"]

    # Hub Model configuration. https://huggingface.co/models
    hub = {
        "HF_MODEL_ID": "dandelin/vilt-b32-finetuned-vqa",
        "HF_TASK": "visual-question-answering",
    }

    # create Hugging Face Model Class
    huggingface_model = HuggingFaceModel(
        transformers_version="4.26.0",
        pytorch_version="1.13.1",
        py_version="py39",
        env=hub,
        role=role,
    )

    # deploy model to SageMaker Inference
    predictor = huggingface_model.deploy(
        initial_instance_count=1,  # number of instances
        instance_type="ml.m5.xlarge",  # ec2 instance type
    )

    endpoint_name = predictor.endpoint_name

    # Store the endpoint name in Parameter Store
    ssm = boto3.client("ssm")
    ssm.put_parameter(
        Name="hfvqa_model_endpoint",
        Description="SageMaker endpoint for the Hugging Face VQA model",
        Value=endpoint_name,
        Type="String",
        Overwrite=True,
    )

    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "Hugging Face Model Deployed!",
                "endpoint_name": endpoint_name,
            }
        ),
    }
