const amplifyconfig = r'''
{
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify-cli/2.0",
        "Version": "0.1.0",
        "CognitoUserPool": {
          "Default": {
            "PoolId": "${COGNITO_USER_POOL_ID}",
            "AppClientId": "${COGNITO_APP_CLIENT_ID}",
            "Region": "${COGNITO_REGION}"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH"
          }
        }
      }
    }
  },
  "api": {
    "plugins": {
      "awsAPIPlugin": {
        "flashcardsApi": {
          "endpointType": "REST",
          "endpoint": "${FLASHCARDS_API_ENDPOINT}",
          "region": "${FLASHCARDS_API_REGION}",
          "authorizationType": "AMAZON_COGNITO_USER_POOLS"
        }
      }
    }
  }
}
''';
