import 'dart:html';

class TokenStorage {
  static const _idTokenKey = 'idToken';

  static void saveIdToken(String token) {
    window.sessionStorage[_idTokenKey] = token;
  }

  static String? getIdToken() {
    return window.sessionStorage[_idTokenKey];
  }

  static void clear() {
    window.sessionStorage.remove(_idTokenKey);
  }
}
