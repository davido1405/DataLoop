import 'package:data_loop/Models/Taches.dart';
import 'package:data_loop/Repositories/AnnotationRepository.dart';
import 'package:flutter/cupertino.dart';

class Annotationviewmodel extends ChangeNotifier {
  //1-Dépendances
  final Annotationrepository _annotationrepository;

  Annotationviewmodel(this._annotationrepository);

  //2-Etat
  Taches? _tache;
  List<Taches> _historiqueTaches = [];
  bool _chargementEnCours = false;
  String? _errorMessage;

  //3-Getters
  Taches? get tache => _tache;

  List<Taches> get historiqueTaches => _historiqueTaches;

  bool get chargementEnCours => _chargementEnCours;

  String? get errorMessage => _errorMessage;

  //4-Initialisation
  Future<void> init() async {
    _chargementEnCours = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tache = await _annotationrepository.recupererTaches();
      if (_tache == null) {
        _errorMessage = "Aucune tâche disponible côté serveur";
      }
    } catch (e) {
      print(e);
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _tache = null;
    } finally {
      _chargementEnCours = false;
      notifyListeners();
    }
  }

  //5-Actions
  Future<void> envoyerReponse(
    String id_tache,
    String reponse, {
    int tempsExecutionMs = 0,
  }) async {
    _chargementEnCours = true;
    _errorMessage = null;
    notifyListeners();

    if (id_tache.isEmpty) {
      _chargementEnCours = false;
      _errorMessage = "Identifiant de tache manquant";
      notifyListeners();

      return;
    }

    if (reponse.isEmpty) {
      _chargementEnCours = false;
      _errorMessage = "Reponse manquante";
      notifyListeners();

      return;
    }
    try {
      final success = await _annotationrepository.envoyerReponse(
        id_tache,
        reponse,
        tempsExecutionMs: tempsExecutionMs,
      );
      if (!success) {
        _errorMessage = "La réponse n'a pas pu être enregistrée";
      }
    } catch (e) {
      print(e);
      _errorMessage =
          "Une erreur s'est produite lors de l'envoie de la reponse";
    } finally {
      _chargementEnCours = false;
      notifyListeners();
    }
  }

  Future<void> passerTache(String id_tache) async {
    _chargementEnCours = true;
    _errorMessage = null;
    notifyListeners();

    if (id_tache.isEmpty) {
      _chargementEnCours = false;
      _errorMessage = "Identifiant de la tache est manquant";
      notifyListeners();

      return;
    }
    try {
      final success = await _annotationrepository.passerTache(id_tache);
      if (!success) {
        _errorMessage = "La tâche n'a pas pu être passée";
      }
    } catch (e) {
      print(e);
      _errorMessage = "Une erreur s'est produite";
    } finally {
      _chargementEnCours = false;
      notifyListeners();
    }
  }

  Future<void> recupererHistoriqueTaches() async {
    _chargementEnCours = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _historiqueTaches = await _annotationrepository.historiqueTaches();
    } catch (e) {
      print(e);
      _errorMessage = "Impossible de récupérer l'historique des tâches";
      _historiqueTaches = [];
    } finally {
      _chargementEnCours = false;
      notifyListeners();
    }
  }
}
