import os
import boto3
import yaml
import markdown
from pathlib import Path

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("Flashcards")

def parse_markdown(file_path):
    """Extract YAML front matter and question/answer content"""
    text = Path(file_path).read_text(encoding="utf-8")

    # Split YAML front matter
    _, front_matter, body = text.split("---", 2)
    metadata = yaml.safe_load(front_matter.strip())

    # Extract question and answer sections
    question = ""
    answer = ""
    current = None

    for line in body.splitlines():
        if line.lower().startswith("## question"):
            current = "question"
            continue
        if line.lower().startswith("## answer"):
            current = "answer"
            continue

        if current == "question":
            question += line + "\n"
        elif current == "answer":
            answer += line + "\n"

    return metadata, question.strip(), answer.strip()

def write_to_dynamo(metadata, question, answer):
    item_id = metadata["id"]
    locale = metadata["locale"].lower()

    pk = item_id

    # QUESTION item
    table.put_item(Item={
        "id": pk,
        "card_type": f"QUESTION#{locale.upper()}",
        "career": metadata.get("career"),
        "subject": metadata.get("subject"),
        "locale": locale,
        "content": question
    })

    # ANSWER item
    table.put_item(Item={
        "id": pk,
        "card_type": f"ANSWER#{locale.upper()}",
        "career": metadata.get("career"),
        "subject": metadata.get("subject"),
        "locale": locale,
        "content": answer
    })

def import_folder(path):
    for md_file in Path(path).glob("*.md"):
        metadata, question, answer = parse_markdown(md_file)
        write_to_dynamo(metadata, question, answer)
        print(f"Imported: {md_file.name}")

if __name__ == "__main__":
    import_folder("./questions")   # folder with MD files
    