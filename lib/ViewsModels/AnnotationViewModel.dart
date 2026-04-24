import 'package:data_loop/Models/Taches.dart';
import 'package:data_loop/Repositories/AnnotationRepository.dart';
import 'package:flutter/cupertino.dart';

class Annotationviewmodel extends ChangeNotifier {
  //1-Dépendances
  Annotationrepository _annotationrepository;

  Annotationviewmodel(this._annotationrepository);

  //2-Etat
  Taches? _tache;
  bool _chargementEnCours = false;
  String? _errorMessage;

  //3-Getters
  Taches? get tache => _tache;

  bool get chargementEnCours => _chargementEnCours;

  String? get errorMessage => _errorMessage;

  //4-Initialisation
  Future<Taches?> init() async {
    _chargementEnCours = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tache = await _annotationrepository.recupererTaches();
    } catch (e) {
      print(e);
      _errorMessage = "Aucune tache récupérées";
      _tache = null;
    } finally {
      _chargementEnCours = false;
      notifyListeners();
    }

    return _tache;
  }

  //5-Actions
  Future<void> envoyerReponse(String id_tache, String reponse) async {
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
      await _annotationrepository.envoyerReponse(id_tache, reponse);
    } catch (e) {
      print(e);
      _errorMessage = "Une erreur s'est produite lors de l'envoie de la reponse";
    }finally{
      _chargementEnCours=false;
      notifyListeners();
    }
  }

  Future<void>passerTache(String id_tache)async{
    _chargementEnCours=true;
    _errorMessage=null;
    notifyListeners();

    if(id_tache.isEmpty){
      _chargementEnCours=false;
      _errorMessage="Identifiant de la tache est manquant";
      notifyListeners();

      return;
    }
    try{
      await _annotationrepository.passerTache(id_tache);
    }catch(e){
      print(e);
      _errorMessage="Une erreur s'est produite";
    }finally{
      _chargementEnCours=false;
      notifyListeners();
    }
  }
}
