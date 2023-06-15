from crhelper import CfnResource
import boto3
import os
import logging

logger = logging.getLogger(__name__)
helper = CfnResource(json_logging=False, log_level="DEBUG", boto_level="CRITICAL")

sns_client = boto3.client("sns")

try:
    FCM_API_KEY = os.environ["FCM_API_KEY"]
except Exception as e:
    helper.init_failure(e)


@helper.create
def create(event, context):
    logger.info("Got Create")
    properties = event["ResourceProperties"]
    application_name = properties.get("ApplicationName")
    platform = properties.get("Platform")
    try:
        response = sns_client.create_platform_application(
            Name=application_name,
            Platform=platform,
            Attributes={"PlatformCredential": FCM_API_KEY},
        )
        return response["PlatformApplicationArn"]
    except Exception as e:
        logger.error("Failed to create SNS platform application: %s", e)
        raise


@helper.update
def update(event, context):
    logger.info("Got Update")
    # If the FCM API key or application name changes, you'd need to handle updates here.
    pass


@helper.delete
def delete(event, context):
    logger.info("Got Delete")
    arn = event["PhysicalResourceId"]
    try:
        sns_client.delete_platform_application(PlatformApplicationArn=arn)
    except Exception as e:
        logger.error("Failed to delete SNS platform application: %s", e)
        raise


def lambda_handler(event, context):
    helper(event, context)
