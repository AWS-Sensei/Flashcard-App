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
            "PoolId": "eu-central-1_CgH9GHj26",
            "AppClientId": "3l0d8h7k68qrusll06g8f6e9cl",
            "Region": "eu-central-1"
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
          "endpoint": "https://3xy2a24tad.execute-api.eu-central-1.amazonaws.com",
          "region": "eu-central-1",
          "authorizationType": "AMAZON_COGNITO_USER_POOLS"
        }
      }
    }
  }
}
''';
