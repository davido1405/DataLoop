import 'dart:math';

import 'package:data_loop/Models/Session.dart';
import 'package:data_loop/Repositories/AuthRepository.dart';
import 'package:flutter/material.dart';

class Authviewmodel extends ChangeNotifier {
  //1-Dépendances
  Authrepository _authrepository;

  Authviewmodel(this._authrepository);

  //2-Etat
  Session? _session;
  bool _chargementEnCour = false;
  String? _errorMessage;
  String? _numeroSauvegarder;

  //3-Getters
  Session? get session => _session;

  String? get numeroSauvegarder => _numeroSauvegarder;

  String? get errrorMessage => _errorMessage;

  bool get estConnecte => _session != null;

  //4-initialisation
  Future<void> init() async {
    //Vérifier si y'a déjà un compte sur le telephone
    String? numero = await _authrepository.recupererNumeroSauve();
    String? token = await _authrepository.getSecuredJWT();
    if (numero!.isNotEmpty && token!.isNotEmpty) {
      Session? profil = await _authrepository.recupererProfil();
      if (profil != null) {
        _session = profil;
      } else {
        _session = null;
        print("Aucun profil trouvé");
      }
    }
    notifyListeners();
  }

  //5-Actions

  //Se connecter
  Future<void> seConnecter(String password) async {
    _chargementEnCour = true;
    _errorMessage = null;
    notifyListeners();

    String? numeroSauve = await _authrepository.recupererNumeroSauve();
    if (numeroSauve!.isEmpty) {
      _chargementEnCour = false;
      _errorMessage = "Aucun numero trouvé";
      notifyListeners();
      return ;
    }
    try {
      _session = await _authrepository.seConnecter(numeroSauve, password);
      if (_session?.jwt != null) {
        //A modifier pour passer le numéro de l'utilisateur connecter
        await _authrepository.sauvegarderNumero("numero a passer");
        //A modifier pour passer le token format String
        await _authrepository.secureJWT(_session!);
        _session?.removeJwt();
      }
    } catch (e) {
      _errorMessage="Erreur lors de l'inscription";
      print(e);
    }finally{
      _chargementEnCour=false;
      notifyListeners();
    }
  }

  //S'inscrire
  Future<void> sinscrir(String nom, String email, String numero, String password,) async {
    _chargementEnCour = true;
    _errorMessage = null;

    notifyListeners();

    if (nom.isEmpty || email.isEmpty || numero.isEmpty || password.isEmpty) {
      _chargementEnCour = false;
      _errorMessage = "le champ nom est vide";
      notifyListeners();
      return;
    }
    if (email.isEmpty) {
      _chargementEnCour = false;
      _errorMessage = "le champ email est vide";
      notifyListeners();
      return;
    }
    if (numero.isEmpty) {
      _chargementEnCour = false;
      _errorMessage = "le champ numero est vide";
      notifyListeners();
      return;
    }
    if (password.isEmpty) {
      _chargementEnCour = false;
      _errorMessage = "le champ password est vide";
      notifyListeners();
      return;
    }
    
    try{
      _session=await _authrepository.sinscrir(nom, numero, email, password);
      if(_session!.jwt != null){
        //Enregistrer le numero pour la prochaine connexion
        await _authrepository.sauvegarderNumero(numero);
        //Enregistrer le token(à modifier plus tard)
        await _authrepository.secureJWT(_session!);
        //Supprimer le token de l'objet session
        _session!.removeJwt();
      }
    }catch(e){
      _errorMessage="Une erreur s'est produite lors de l'inscription";
      print(e);
    }finally{
      _chargementEnCour=false;
      notifyListeners();
    }
  }
}
