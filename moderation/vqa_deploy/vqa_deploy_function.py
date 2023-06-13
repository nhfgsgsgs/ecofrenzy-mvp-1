from __future__ import print_function
from crhelper import CfnResource
import os
import boto3
from botocore.exceptions import ClientError
from sagemaker.huggingface import HuggingFaceModel
import logging

logger = logging.getLogger(__name__)
helper = CfnResource(json_logging=False, log_level="DEBUG", boto_level="CRITICAL")


@helper.create
def create(event, context):
    logger.info("Got Create")
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

    helper.Data.update({"endpoint_name": endpoint_name})

    return endpoint_name


@helper.update
def update(event, context):
    logger.info("Got Update: %s - no action.", event)


@helper.delete
def delete(event, context):
    logger.info("Got Delete: %s - Delete all associated endpoints.", event)

    sagemaker_client = boto3.client("sagemaker")
    endpoint_name = helper.Data.get("endpoint_name")

    # Delete the endpoint
    try:
        sagemaker_client.delete_endpoint(EndpointName=endpoint_name)
    except ClientError as e:
        if e.response["Error"]["Code"] != "ValidationException":
            # Raise the exception if it's not a ValidationException (which means the endpoint already doesn't exist)
            raise

    # Delete the endpoint configuration
    try:
        sagemaker_client.delete_endpoint_config(EndpointConfigName=endpoint_name)
    except ClientError as e:
        if e.response["Error"]["Code"] != "ValidationException":
            raise

    # Delete the model
    try:
        sagemaker_client.delete_model(ModelName=endpoint_name)
    except ClientError as e:
        if e.response["Error"]["Code"] != "ValidationException":
            raise


def handler(event, context):
    helper(event, context)
