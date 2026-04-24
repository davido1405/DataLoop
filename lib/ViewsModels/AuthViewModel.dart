import 'dart:math';

import 'package:data_loop/Models/Session.dart';
import 'package:data_loop/Repositories/AuthRepository.dart';
import 'package:flutter/material.dart';

class Authviewmodel extends ChangeNotifier {
  //1-Dépendances
  final Authrepository _authrepository;

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

    print("=== INIT ===");
    print("numero en cache: $numero");
    print("token en cache: $token");
    // Le numéro est assigné dès qu'il existe, peu importe le token
    if (numero != null) {
      _numeroSauvegarder = numero;
    }

    if (numero != null && token != null) {
      _session = await _authrepository.recupererProfil();
      print(_session.toString());
    }

    print("estConnecte: $estConnecte");
    print("numeroSauvegarder: $_numeroSauvegarder");

    notifyListeners();
  }

  //5-Actions

  //Se connecter
  Future<void> seConnecter(String password) async {
    _chargementEnCour = true;
    _errorMessage = null;
    notifyListeners();

    String? numeroSauve = await _authrepository.recupererNumeroSauve();
    if (numeroSauve == null) {
      _chargementEnCour = false;
      _errorMessage = "Aucun numero trouvé";
      notifyListeners();
      return;
    }
    try {
      _session = await _authrepository.seConnecter(numeroSauve, password);
      if (_session?.jwt != null) {
        //A modifier pour passer le numéro de l'utilisateur connecter
        await _authrepository.sauvegarderNumero(numeroSauve);
        _numeroSauvegarder = numeroSauve;
        //A modifier pour passer le token format String
        await _authrepository.secureJWT(_session!);
        _session?.removeJwt();
      }
    } catch (e) {
      _errorMessage = "Erreur lors de l'inscription";
      print(e);
    } finally {
      _chargementEnCour = false;
      notifyListeners();
    }
  }

  //S'inscrire
  Future<void> sinscrir(
    String nom,
    String email,
    String numero,
    String password,
  ) async {
    _chargementEnCour = true;
    _errorMessage = null;
    notifyListeners();

    if (nom.isEmpty) {
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

    try {
      _session = await _authrepository.sinscrir(nom, numero, email, password);

      //Enregistrer le numero pour la prochaine connexion
      await _authrepository.sauvegarderNumero(numero);
      _numeroSauvegarder=numero;
      await _authrepository.secureJWT(_session!);
      _session!.removeJwt();
    } catch (e) {
      _errorMessage = "Une erreur s'est produite lors de l'inscription";
      print(e);
    } finally {
      _chargementEnCour = false;
      notifyListeners();
    }
  }
}
