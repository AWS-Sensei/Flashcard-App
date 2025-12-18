import '../services/token_storage.dart';

class AuthState {
  static bool isAuthenticated() {
    return TokenStorage.getIdToken() != null;
  }

  static void logout() {
    TokenStorage.clear();
  }
}
