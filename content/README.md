# Content import

This folder contains the Markdown flashcards and the `import.py` script that
loads them into DynamoDB.

## Requirements

- Python 3.10+
- AWS credentials configured (`AWS_PROFILE` or default credentials)
- DynamoDB table named `Flashcards` in your active AWS region

Python packages:
- `boto3`
- `pyyaml`
- `markdown`

Example:

```bash
python -m pip install boto3 pyyaml markdown
```

## Markdown format

Each file in `questions/` must contain YAML front matter and two sections:
`## Question` and `## Answer`.

```md
---
id: example-001
locale: en
career: Cloud Engineer
subject: IAM
---

## Question
What does IAM stand for?

## Answer
Identity and Access Management.
```

Notes:
- `id` and `locale` are required.
- `career` and `subject` are optional.

## Import

From the `content/` folder:

```bash
python import.py
```

To target a different folder:

```bash
python import.py ./my-folder
```

This loads all `*.md` files from the provided folder into the `Flashcards`
table (question and answer items per file).
