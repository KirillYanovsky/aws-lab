import boto3
import datetime

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    # Get current UTC time
    current_time = datetime.datetime.utcnow().time()

    # Check if it's between 13:00 and 13:30 UTC
    #if current_time >= datetime.time(13, 0) and current_time <= datetime.time(13, 30):
    if current_time >= datetime.time(19, 15) and current_time <= datetime.time(19, 25):
        start_instances()
    else:
        stop_instances()

def start_instances():
    # Modify the filters based on your specific tags
    filters = [{'Name': 'tag:tag', 'Values': ['AWS-lab1']}]

    instances = ec2.describe_instances(Filters=filters)

    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            ec2.start_instances(InstanceIds=[instance_id])
            print(f"Started instance: {instance_id}")

def stop_instances():
    # Modify the filters based on your specific tags
    filters = [{'Name': 'tag:tag', 'Values': ['AWS-lab1']}]

    instances = ec2.describe_instances(Filters=filters)

    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            ec2.stop_instances(InstanceIds=[instance_id])
            print(f"Stopped instance: {instance_id}")
