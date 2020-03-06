# System imports
import json
import os

# Third-party imports
import boto3

# get boto3 dynamodb client
client = boto3.client('dynamodb')

#get dynamodb resource
dynamodb = boto3.resource('dynamodb')

# define lambda handler
def lambda_handler(event, context):
    # TODO implement
    
    # obtain the message from the event that triggered this lambda
    message = json.loads(event['body'])
    
    # assign table item variables to event body elements
    reservation_email = message["reservation_email"]
    reservation_date = message["reservation_date"]
    
    # check for existing tables
    existsing_tables = client.list_tables()

    # check if our table exists already, if not, it will create it first before adding the above table items
    if 'rockets2mars' not in existsing_tables['TableNames']:
        table = dynamodb.create_table(
            TableName='rockets2mars',
            KeySchema=[
                {
                    'AttributeName' : 'reservation_email',
                    'KeyType' : 'HASH',
                }
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'reservation_email',
                    'AttributeType': 'S'
                }
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 5,
                'WriteCapacityUnits': 5
            }
        )
        
        # table creation does require some time, thus we pause until table is created
        table.meta.client.get_waiter("table_exists").wait(TableName="rockets2mars")
    
    # assign our table to a variable 
    table = dynamodb.Table('rockets2mars')
    
    # add our items to the table
    response = table.put_item(
        Item={
            'reservation_email': reservation_email,
            'reservation_date': reservation_date
        }
    )
    
    # if successful it will print the dynamodb response
    if response:
        print(response)

    return {
        'statusCode': 200,
        'body':json.dumps("Success")
    }