import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth_challenge.dart';


class AuthService {
  final String region;
  final String clientId;

  AuthService({
    required this.region,
    required this.clientId,
  });

  String get _endpoint =>
      'https://cognito-idp.$region.amazonaws.com/';

  Future<dynamic> login(String username, String password) async {
    final response = await http.post(Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'AWSCognitoIdentityProviderService.InitiateAuth',
      },
      body: jsonEncode({
        'AuthFlow': 'USER_PASSWORD_AUTH',
        'ClientId': clientId,
        'AuthParameters': {
          'USERNAME': username,
          'PASSWORD': password,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed: ${response.body}');
    }

    final data = jsonDecode(response.body);
    
    // ✅ NORMAL LOGIN
    if (data['AuthenticationResult'] != null) {
      return data['AuthenticationResult']['IdToken'];
    }
  
    // 🔐 NEW PASSWORD REQUIRED
    if (data['ChallengeName'] == 'NEW_PASSWORD_REQUIRED') {
      return AuthChallenge(
        type: AuthChallengeType.newPassword,
        session: data['Session'],
      );
    }
  
    throw Exception('Unexpected auth response: $data');
    }
    
  Future<String> respondToNewPassword({required String username, required String newPassword, required String session}) async {
    final response = await http.post(
      Uri.parse('https://cognito-idp.$region.amazonaws.com/'),
      headers: {
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target':
            'AWSCognitoIdentityProviderService.RespondToAuthChallenge',
      },
      body: jsonEncode({
        'ChallengeName': 'NEW_PASSWORD_REQUIRED',
        'ClientId': clientId,
        'Session': session,
        'ChallengeResponses': {
          'USERNAME': username,
          'NEW_PASSWORD': newPassword,
        },
      }),
    );
  
    final data = jsonDecode(response.body);
  
    final idToken = data['AuthenticationResult']?['IdToken'];
    if (idToken == null) {
      throw Exception('IdToken missing after password change');
    }
  
    return idToken;
  }

}
