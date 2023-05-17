import boto3

def create_cloudwatch_alarm(i-0648ccaf5d37ac21a):
    client = boto3.client('cloudwatch')

    # Create an alarm
    response = client.put_metric_alarm(
        AlarmName='HighCPUAlarm',
        ComparisonOperator='GreaterThanThreshold',
        EvaluationPeriods=5,
        MetricName='CPUUtilization',
        Namespace='AWS/EC2',
        Period=60,
        Statistic='Average',
        Threshold=80.0,
        AlarmDescription='Alarm when CPU exceeds 80%',
        AlarmActions=['arn:aws:sns:us-west-2:123456789012:MyTopic'],  
        Dimensions=[
            {
                'Name': 'i-0648ccaf5d37ac21a',
                'Value': 'terraform-batch2'
            },
        ],
    )

    print("CloudWatch alarm created successfully.")

instance_id = 'i-0123456789abcdef0'

create_cloudwatch_alarm(instance_id)
