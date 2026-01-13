import os
import boto3
import yaml
import markdown
from pathlib import Path
import argparse

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("Flashcards")

def parse_markdown(file_path):
    """Extract YAML front matter and question/answer content"""
    text = Path(file_path).read_text(encoding="utf-8")

    # Split YAML front matter
    if "---" not in text:
        raise ValueError(f"Missing YAML front matter in {file_path}")

    parts = text.split("---", 2)
    if len(parts) < 3:
        raise ValueError(f"Malformed YAML front matter in {file_path}")

    _, front_matter, body = parts
    metadata = yaml.safe_load(front_matter.strip()) or {}
    if not isinstance(metadata, dict):
        raise ValueError(f"YAML front matter must be a mapping in {file_path}")

    # Extract question and answer sections
    question = ""
    multiple_choice = ""
    answer = ""
    current = None

    for line in body.splitlines():
        line_stripped = line.strip()
        header = line_stripped.lower()
        if header.startswith("## question"):
            current = "question"
            continue
        if header.startswith("## multiple choice"):
            current = "multiple choice"
            continue
        if header.startswith("## answer"):
            current = "answer"
            continue

        if current == "question":
            question += line_stripped + "\n" if line_stripped else "\n"
        elif current == "multiple choice":
            multiple_choice += line_stripped + "\n" if line_stripped else "\n"
        elif current == "answer":
            answer += line_stripped + "\n" if line_stripped else "\n"

    return metadata, question.strip(), multiple_choice.strip(), answer.strip()

def write_to_dynamo(metadata, question, multiple_choice, answer, writer=None):
    required_fields = ("id", "locale")
    missing = [field for field in required_fields if not metadata.get(field)]
    if missing:
        missing_fields = ", ".join(missing)
        raise ValueError(f"Missing required metadata fields: {missing_fields}")

    item_id = metadata["id"]
    locale = metadata["locale"].lower()
    subject = metadata.get("subject")
    career = metadata.get("career")
    subject_career = None
    if subject and career:
        subject_career = f"subject#{subject}#career#{career}"

    pk = item_id

    put_item = writer.put_item if writer is not None else table.put_item

    # QUESTION item
    question_item = {
        "id": pk,
        "card_type": f"question#{locale}",
        "career": career,
        "subject": subject,
        "subject_career": subject_career,
        "locale": locale,
        "content": question,
        "multiple_choice": multiple_choice
    }
    if subject_career is None:
        question_item.pop("subject_career", None)
    put_item(Item=question_item)

    # ANSWER item
    answer_item = {
        "id": pk,
        "card_type": f"answer#{locale}",
        "career": career,
        "subject": subject,
        "subject_career": subject_career,
        "locale": locale,
        "content": answer
    }
    if subject_career is None:
        answer_item.pop("subject_career", None)
    put_item(Item=answer_item)

def import_folder(path):
    with table.batch_writer() as writer:
        for md_file in Path(path).glob("*.md"):
            metadata, question, multiple_choice, answer = parse_markdown(md_file)
            write_to_dynamo(metadata, question, multiple_choice, answer, writer=writer)
            print(f"Imported: {md_file.name}")

def parse_args():
    parser = argparse.ArgumentParser(description="Import flashcards into DynamoDB")
    parser.add_argument(
        "path",
        nargs="?",
        default="./questions",
        help="Folder containing Markdown files (default: ./questions)",
    )
    return parser.parse_args()

if __name__ == "__main__":
    args = parse_args()
    import_folder(args.path)
    
