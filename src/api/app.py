import os
import json
import random
import boto3
from boto3.dynamodb.conditions import Key, Attr

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def lambda_handler(event, context):
    method = event.get("requestContext", {}).get("http", {}).get("method")
    path_params = event.get("pathParameters") or {}
    qs = event.get("queryStringParameters") or {}

    # --------------------------------------------
    # 1) RANDOM QUESTION
    # --------------------------------------------
    if event["rawPath"] == "/items/random" and method == "GET":
        # Step 1: Scan GSI1 for items of card_type question
        resp = table.scan(
            FilterExpression=Attr("card_type").eq("question"),
            ProjectionExpression="id, card_type, career, subject, locale"
        )
        items = resp.get("Items", [])
        if not items:
            return {"statusCode": 404, "body": "No questions available"}

        # Step 2: Pick a random one
        item = random.choice(items)

        # Step 3: Fetch full question item via pk+sk
        resp2 = table.get_item(Key={"id": item["id"], "card_type": item["card_type"]})
        full = resp2.get("Item", {})

        # Return only the QUESTION
        return {
            "statusCode": 200,
            "body": json.dumps({
                "id": full["id"],
                "locale": full["locale"],
                "career": full.get("career"),
                "subject": full.get("subject"),
                "question": full["content"]
            })
        }

    # --------------------------------------------
    # 2) GET ANSWER for a uuid
    # --------------------------------------------
    if "id" in path_params and method == "GET" and event["rawPath"].endswith("/answer"):
        pk = path_params["id"]
        answer_sk = f"answer#en"  # or detect via query parameter
        resp = table.get_item(Key={"id": pk, "card_type": answer_sk})
        item = resp.get("Item")
        if not item:
            return {"statusCode": 404, "body": "No answer found"}

        return {
            "statusCode": 200,
            "body": json.dumps({
                "id": pk,
                "locale": item["locale"],
                "career": item.get("career"),
                "subject": item.get("subject"),
                "answer": item["content"]
            })
        }

    # Default fallback
    return {"statusCode": 400, "body": json.dumps({"message": "Invalid request"})}
    