import 'dart:convert';

import 'package:http/http.dart';

import '../Models/Taches.dart';
import 'ApiConfig.dart';

class Annotationrepository {
  String get baseUrl => ApiConfig.baseUrl;

  Future<Taches?> recupererTaches() async {
    final url = Uri.parse("$baseUrl/api/v1/tasks/next");
    final response = await get(
      url,
      headers: await ApiConfig.authHeaders(),
    );
    if (response.statusCode == 200) {
      final donnee = jsonDecode(response.body) as Map<String, dynamic>;
      final taskJson = donnee['task'];
      final tasksJson = donnee['tasks'];

      if (taskJson is Map) {
        return Taches.fromJson(Map<String, dynamic>.from(taskJson));
      }

      if (tasksJson is List && tasksJson.isNotEmpty && tasksJson.first is Map) {
        return Taches.fromJson(Map<String, dynamic>.from(tasksJson.first));
      }
    }
    return null;
  }

  Future<bool> envoyerReponse(
    String id_tache,
    String reponse, {
    int tempsExecutionMs = 0,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/tasks/${id_tache}/annotate");
    final response = await post(
      url,
      headers: await ApiConfig.authHeaders(),
      body: jsonEncode({
        "reponse_choisie": reponse,
        "temps_execution_ms": tempsExecutionMs,
      }),
    );

    if (response.statusCode == 201) {
      print("Reponse envoyé");
      return true;
    }
    return false;
  }

  Future<bool> passerTache(String id_tache) async {
    final url = Uri.parse("$baseUrl/api/v1/tasks/${id_tache}/skip");
    final response = await post(
      url,
      headers: await ApiConfig.authHeaders(),
    );

    return response.statusCode == 200;
  }

  Future<List<Taches>> historiqueTaches() async {
    final url = Uri.parse("$baseUrl/api/v1/tasks/history");
    final response = await get(url, headers: await ApiConfig.authHeaders());

    if (response.statusCode != 200) {
      return [];
    }

    final donnees = jsonDecode(response.body) as Map<String, dynamic>;
    final historiqueJson = donnees['data'];

    if (historiqueJson is! List) {
      return [];
    }

    return historiqueJson
        .whereType<Map>()
        .map((item) {
          final tacheJson = item['tache'] ?? item['task'] ?? item;
          return Taches.fromJson(Map<String, dynamic>.from(tacheJson));
        })
        .where((tache) => tache.id.isNotEmpty)
        .toList();
  }

  Future<Taches?> detailsTache(String id_tache) async {
    final url = Uri.parse("$baseUrl/api/v1/tasks/$id_tache");
    final response = await get(url, headers: await ApiConfig.authHeaders());

    if (response.statusCode != 200) {
      return null;
    }

    final donnees = jsonDecode(response.body) as Map<String, dynamic>;
    final tacheJson = donnees['task'] ?? donnees['data'] ?? donnees;

    if (tacheJson is Map) {
      return Taches.fromJson(Map<String, dynamic>.from(tacheJson));
    }

    return null;
  }
}
