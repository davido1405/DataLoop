import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Session.dart';
import 'ApiConfig.dart';

class Authrepository {
  String get baseUrl => ApiConfig.baseUrl;

  Session? _sessionFromAuthResponse(Map<String, dynamic> data) {
    final userJson = data['user'];
    if (userJson is! Map) {
      return null;
    }

    final user = Map<String, dynamic>.from(userJson);
    user['access_token'] ??= data['access_token'];
    return Session.fromJson(user);
  }

  Future<Session?> seConnecter(String numero, String password) async {
    try {
      final url = Uri.parse("$baseUrl/api/v1/auth/login");
      final response = await post(
        url,
        headers: ApiConfig.jsonHeaders,
        body: jsonEncode({
          "telephone": ApiConfig.normaliserTelephone(numero),
          "password": password,
        }),
      );
      if (response.statusCode == 200) {
        final donnee = jsonDecode(response.body) as Map<String, dynamic>;
        return _sessionFromAuthResponse(donnee);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Session?> sinscrir(
    String name,
    String telephone,
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse("$baseUrl/api/v1/auth/register");
      final response = await post(
        url,
        headers: ApiConfig.jsonHeaders,
        body: jsonEncode({
          "name": name,
          "telephone": ApiConfig.normaliserTelephone(telephone),
          "email": email.isEmpty ? null : email,
          "password": password,
        }),
      );
      if (response.statusCode == 201) {
        final donnee = jsonDecode(response.body) as Map<String, dynamic>;
        return _sessionFromAuthResponse(donnee);
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
      final response = await get(
        url,
        headers: {
          ...ApiConfig.jsonHeaders,
          if (token != null) "Authorization": "Bearer $token",
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

  Future<bool> envoyerOtp(String telephone) async {
    try {
      final url = Uri.parse("$baseUrl/api/v1/auth/otp/send");
      final response = await post(
        url,
        headers: ApiConfig.jsonHeaders,
        body: jsonEncode({
          "telephone": ApiConfig.normaliserTelephone(telephone),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<Session?> verifierOtp(String telephone, String code) async {
    try {
      final url = Uri.parse("$baseUrl/api/v1/auth/otp/verify");
      final response = await post(
        url,
        headers: ApiConfig.jsonHeaders,
        body: jsonEncode({
          "telephone": ApiConfig.normaliserTelephone(telephone),
          "code": code,
        }),
      );

      if (response.statusCode == 200) {
        final donnee = jsonDecode(response.body) as Map<String, dynamic>;
        return _sessionFromAuthResponse(donnee);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> seDeconnecter() async {
    try {
      final url = Uri.parse("$baseUrl/api/v1/auth/logout");
      await post(url, headers: await ApiConfig.authHeaders());
    } catch (e) {
      print(e);
    } finally {
      await ApiConfig.saveToken(null);
    }
  }

  Future<void> secureJWT(Session session) async {
    try {
      await ApiConfig.saveToken(session.jwt);
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

    prefs.setString("numeroUtilisateur", ApiConfig.normaliserTelephone(numero));
  }

  Future<String?> getSecuredJWT() async {
    return ApiConfig.getToken();
  }
}
