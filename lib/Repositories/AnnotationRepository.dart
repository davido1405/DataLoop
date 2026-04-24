import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import '../Models/Taches.dart';

class Annotationrepository {
  String? baseUrl = dotenv.env['BASE_URL'];

  Future<Taches?> recupererTaches() async {
    final url = Uri.parse("$baseUrl/api/v1/tasks/next");
    final response = await get(
      url,
      headers: {"content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final donnee=jsonDecode(response.body);
      List<dynamic>Tache=donnee['data'];
      Taches tache=Tache.map((Tache)=>Taches.fromJson(Tache)) as Taches;

      return tache;
    }
  }

  Future<void> envoyerReponse(String id_tache, String reponse) async {
    final url = Uri.parse("$baseUrl/api/v1/tasks/${id_tache}/annotate");
    final response = await post(
      url,
      headers: {"content-Type": "application/json"},
      body: jsonEncode([
        {"reponse_choisie": reponse},
      ]),
    );

    if (response.statusCode == 201) {
      print("Reponse envoyé");
    }
  }

  Future<void> passerTache(String id_tache) async {
    final url = Uri.parse("$baseUrl/api/v1/tasks/${id_tache}/skip");
    final response = await post(
      url,
      headers: {"content-Type": "application/json"},
    );

    if (response.statusCode == 201) {
      print("Reponse envoyé");
    }
  }

  Future<void> historiqueTaches() async {}

  Future<Taches?> detailsTache(String id_tache) async {}
}
