import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiConfig {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static String get baseUrl {
    final value = dotenv.env['API_BASE_URL'] ??
        dotenv.env['BASE_URL'] ??
        'https://dataloop-production.up.railway.app';

    return value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }

  static Map<String, String> get jsonHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Future<Map<String, String>> authHeaders() async {
    final token = await getToken();

    return {
      ...jsonHeaders,
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<String?> getToken() {
    return _secureStorage.read(key: 'jwt_token');
  }

  static Future<void> saveToken(String? token) async {
    if (token == null || token.isEmpty) {
      await _secureStorage.delete(key: 'jwt_token');
      return;
    }

    await _secureStorage.write(key: 'jwt_token', value: token);
  }

  static String normaliserTelephone(String telephone) {
    final cleaned = telephone.trim().replaceAll(' ', '');
    if (cleaned.isEmpty || cleaned.startsWith('+')) {
      return cleaned;
    }
    if (cleaned.startsWith('225')) {
      return '+$cleaned';
    }
    return '+225$cleaned';
  }
}
