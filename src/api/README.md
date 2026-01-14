# API Lambda

AWS Lambda handler for the flashcard API. It reads from DynamoDB using the
table name in `TABLE_NAME` and returns JSON responses.

## Endpoints

Base path depends on your API Gateway configuration.

### GET /items/random

Returns a random question. Optional filters:

- `subject`
- `career`

Response fields:

- `id`
- `locale`
- `career`
- `subject`
- `question`
- `multiple_choice` (optional)

### GET /items/{id}/answer

Returns the answer for a question id.

Response fields:

- `id`
- `locale`
- `career`
- `subject`
- `answer`

## Environment

- `TABLE_NAME` (required)
