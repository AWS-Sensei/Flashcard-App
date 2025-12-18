enum AuthChallengeType {
  newPassword,
}

class AuthChallenge {
  final AuthChallengeType type;
  final String session;

  AuthChallenge({
    required this.type,
    required this.session,
  });
}
