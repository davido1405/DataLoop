import 'dart:convert';

import 'package:http/http.dart';

import '../Models/Taches.dart';
import 'ApiConfig.dart';

class Annotationrepository {
  String get baseUrl => ApiConfig.baseUrl;

  Future<Taches?> recupererTaches() async {
    final url = Uri.parse("$baseUrl/api/v1/tasks/next?count=1");
    final response = await get(
      url,
      headers: await ApiConfig.authHeaders(),
    );

    if (response.statusCode == 401) {
      throw Exception("Session expirée. Veuillez vous reconnecter.");
    }

    if (response.statusCode == 200) {
      final tache = _taskFromPayload(jsonDecode(response.body));
      if (tache != null) {
        return tache;
      }
    }

    return _recupererTacheDepuisListe();
  }

  Future<Taches?> _recupererTacheDepuisListe() async {
    final headers = await ApiConfig.authHeaders();
    final urls = [
      "$baseUrl/api/v1/tasks?status=nouvelle&per_page=20",
      "$baseUrl/api/v1/tasks?status=en_cours&per_page=20",
    ];

    for (final taskUrl in urls) {
      final response = await get(Uri.parse(taskUrl), headers: headers);

      if (response.statusCode == 401) {
        throw Exception("Session expirée. Veuillez vous reconnecter.");
      }

      if (response.statusCode != 200) {
        continue;
      }

      final tache = _taskFromPayload(jsonDecode(response.body));
      if (tache != null) {
        return tache;
      }
    }

    return null;
  }

  Taches? _taskFromPayload(dynamic payload) {
    final payloadMap = _mapFrom(payload);
    if (payloadMap == null) {
      return null;
    }

    final directTask = _mapFrom(
      payloadMap['task'] ?? payloadMap['tache'],
    );
    if (directTask != null) {
      return Taches.fromJson(directTask);
    }

    final tasks = _taskFromList(payloadMap['tasks']);
    if (tasks != null) {
      return tasks;
    }

    return _taskFromList(payloadMap['data']);
  }

  Taches? _taskFromList(dynamic value) {
    final items = value is Map ? value['data'] : value;

    if (items is! List) {
      return null;
    }

    for (final item in items) {
      final taskMap = _mapFrom(item);
      if (taskMap != null) {
        return Taches.fromJson(taskMap);
      }
    }

    return null;
  }

  Map<String, dynamic>? _mapFrom(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
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
