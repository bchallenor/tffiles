#!/usr/bin/env python3

import argparse
import boto3
import json
import os
import os.path
import time

VMIMPORT_ROLE_NAME = os.environ.get("VMIMPORT_ROLE_NAME", "vmimport")


def init_state(bucket, key):
    s3 = boto3.client("s3")

    res = s3.get_bucket_location(Bucket=bucket)
    region = res["LocationConstraint"]

    res = s3.head_object(Bucket=bucket, Key=key)
    last_modified = res["LastModified"]

    (root_name, _) = os.path.splitext(os.path.basename(key))

    name = f"{root_name}-{last_modified:%Y%m%d}-{last_modified:%H%M%S}"

    return {
        "Tag": "import",
        "Region": region,
        "Bucket": bucket,
        "Key": key,
        "Name": name,
    }


# Yields when it needs to wait.
# If the state is saved at a yield point and later restored, no work is unnecessarily repeated.
def import_ami(s):
    print(f"state: {s}")

    ec2 = boto3.client("ec2", region_name=s["Region"])

    if "ImportTaskId" not in s:
        print("Importing snapshot")
        res = ec2.import_snapshot(
            RoleName=VMIMPORT_ROLE_NAME,
            DiskContainer={
                "Description": s["Name"],
                "Format": "RAW",
                "UserBucket": {"S3Bucket": s["Bucket"], "S3Key": s["Key"]},
            },
        )
        s["ImportTaskId"] = res["ImportTaskId"]

    while "UnencryptedSnapshotId" not in s:
        res = ec2.describe_import_snapshot_tasks(ImportTaskIds=[s["ImportTaskId"]])
        detail = res["ImportSnapshotTasks"][0]["SnapshotTaskDetail"]
        if detail["Status"] == "active":
            yield f"""Waiting for snapshot to be imported ({detail['Progress']}%)..."""
        elif detail["Status"] == "completed":
            s["UnencryptedSnapshotId"] = detail["SnapshotId"]
        else:
            raise Exception(
                f"""Unknown import snapshot task status: {detail['Status']}"""
            )

    if "EncryptedSnapshotId" not in s:
        print("Encrypting snapshot")
        res = ec2.copy_snapshot(
            Description=s["Name"],
            Encrypted=True,
            SourceRegion=s["Region"],
            SourceSnapshotId=s["UnencryptedSnapshotId"],
        )
        s["EncryptedSnapshotId"] = res["SnapshotId"]

    while True:
        res = ec2.describe_snapshots(SnapshotIds=[s["EncryptedSnapshotId"]])
        detail = res["Snapshots"][0]
        if detail["State"] == "pending":
            yield f"""Waiting for snapshot to be encrypted ({detail['Progress']})..."""
        elif detail["State"] == "completed":
            break
        else:
            raise Exception(f"""Unknown snapshot state: {detail['State']}""")

    print("Deleting unencrypted snapshot")
    res = ec2.delete_snapshot(SnapshotId=s["UnencryptedSnapshotId"])

    print("Registering image")
    res = ec2.register_image(
        Name=s["Name"],
        Description=s["Name"],
        Architecture="x86_64",
        VirtualizationType="hvm",
        RootDeviceName="/dev/xvda",
        BlockDeviceMappings=[
            {
                "DeviceName": "/dev/xvda",
                "Ebs": {"SnapshotId": s["EncryptedSnapshotId"], "VolumeType": "gp2"},
            }
        ],
        EnaSupport=True,
    )


def aws_lambda_handler(event, context):
    print(f"event: {event}")

    s = None
    if "Records" in event:
        # invoked from the s3 trigger
        s3_event = event["Records"][0]["s3"]
        bucket = s3_event["bucket"]["name"]
        key = s3_event["object"]["key"]
        s = init_state(bucket, key)
    elif "Tag" in event:
        # invoked recursively
        s = event
    else:
        raise Exception(f"Invalid event: {event}")

    for wait_reason in import_ami(s):
        print(wait_reason)

        if context.get_remaining_time_in_millis() < 10000:
            print(f"Extending time by invoking recursively with current state: {s}")
            lamb = boto3.client("lambda")
            lamb.invoke(
                FunctionName=context.function_name,
                InvocationType="Event",
                Payload=json.dumps(s).encode("utf-8"),
            )
            return

        time.sleep(5)

    print("Done")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Import AMI from S3 bucket")
    parser.add_argument("bucket")
    parser.add_argument("key")

    args = parser.parse_args()

    s = init_state(args.bucket, args.key)

    for wait_reason in import_ami(s):
        print(wait_reason)
        time.sleep(5)

    print("Done")
