import 'package:http/http.dart' as http;
import 'token_storage.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<http.Response> getRandomCard() async {
    final token = TokenStorage.getIdToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    return http.get(
      Uri.parse('$baseUrl/items/random'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
}
