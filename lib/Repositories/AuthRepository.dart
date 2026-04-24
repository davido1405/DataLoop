import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Session.dart';

class Authrepository {
  String? baseUrl = dotenv.env['BASE_URL'];
  Future<Session?> seConnecter(String numero, String password) async {
    try {
      final url = Uri.parse("$baseUrl/api/v1/auth/login");
      final response = await post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"telephone": numero, "password": password}),
      );
      if (response.statusCode == 200) {
        final donnee = jsonDecode(response.body);
        return Session.fromJson(donnee['user']);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Session?> sinscrir(String name, String telephone, String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/api/v1/auth/register");
      final response = await post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "telephone": telephone, "email": email, "password": password}),
      );
      if (response.statusCode == 201) {
        final donnee = jsonDecode(response.body);
        return Session.fromJson(donnee['user']);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Session?> recupererProfil() async {
    try {
      final token = await getSecuredJWT();
      final url = Uri.parse("$baseUrl/api/v1/auth/me");
      final response = await post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Session.fromJson(data['user']);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> secureJWT(Session session) async {
    final cacheSecurite = FlutterSecureStorage();

    print("JWT à sauvegarder: ${session.jwt}"); //
    try {
      await cacheSecurite.write(key: "jwt_token", value: session.jwt);
      // removeJwt() retiré d'ici → géré uniquement dans le ViewModel
    } catch (e) {
      print(e);
    }
  }

  Future<String?> recupererNumeroSauve() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("numeroUtilisateur");
  }

  Future<void> sauvegarderNumero(String numero) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("numeroUtilisateur", numero);
  }


  Future<String?> getSecuredJWT() async {
    final cacheSecurite = FlutterSecureStorage();
    String? token = await cacheSecurite.read(key: 'jwt_token');
    return token;
  }
}
