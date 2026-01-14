# Flashcard App

Serverless flashcard app with a DynamoDB-backed question bank, a Lambda API,
and a static frontend.

## Structure

- `content/` Markdown flashcards and import script
- `src/api/` Lambda handler for question and answer endpoints
- `src/app/` Frontend app
- `infrastructure.yaml` AWS resources (DynamoDB, Lambda, API)
- `buildspec.yaml` build configuration

## Prerequisites

- AWS account and credentials
- Python 3.10+

## AWS resources

Defined in `infrastructure.yaml`:

- DynamoDB table: `Flashcards`
- Cognito User Pool and User Pool Client
- API Gateway HTTP API with Cognito JWT authorizer
- Lambda function: `flashcards-api`
- S3 bucket for the app
- CloudFront distribution with Origin Access Control
- Route 53 A record for the app domain

## Content import

Install deps and import Markdown files:

```bash
python -m pip install boto3 pyyaml markdown
python content/import.py
```

By default it loads `content/questions/*.md`. Use a custom folder:

```bash
python content/import.py ./my-folder
```

## API

The Lambda handler lives in `src/api/app.py` and expects `TABLE_NAME`.

Endpoints:

- `GET /items/random` (optional `subject`, `career`)
- `GET /items/{id}/answer`

See `src/api/README.md` for details.

## App

The frontend lives in `src/app/`.  
See `src/app/README.md` for setup and run instructions.

## Build and deploy (CodeBuild)

`buildspec.yaml` builds the Flutter web app and deploys it to S3, then
invalidates CloudFront. It installs Flutter `3.38.5` and uses Node.js 20.

Required env vars for the build:

- `COGNITO_USER_POOL_ID`
- `COGNITO_CLIENT_ID`
- `COGNITO_REGION`
- `FLASHCARDS_API_ENDPOINT`
- `FLASHCARDS_API_REGION`
- `WEBSITE_BUCKET`
- `CLOUDFRONT_DISTRIBUTION_ID`
