import 'package:data_loop/Models/Session.dart';
import 'package:data_loop/Repositories/ApiConfig.dart';
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

  bool get chargementEnCour => _chargementEnCour;

  bool get estConnecte => _session != null;

  //4-initialisation
  Future<void> init() async {
    //Vérifier si y'a déjà un compte sur le telephone
    String? numero = await _authrepository.recupererNumeroSauve();
    String? token = await _authrepository.getSecuredJWT();

    // Le numéro est assigné dès qu'il existe, peu importe le token
    if (numero != null) {
      _numeroSauvegarder = numero;
    }

    if (numero != null && token != null) {
      _session = await _authrepository.recupererProfil();
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
    if (numeroSauve == null) {
      _chargementEnCour = false;
      _errorMessage = "Aucun numero trouvé";
      notifyListeners();
      return;
    }
    if (password.length < 8) {
      _chargementEnCour = false;
      _errorMessage = "Le code PIN doit contenir au moins 8 chiffres";
      notifyListeners();
      return;
    }
    try {
      _session = await _authrepository.seConnecter(numeroSauve, password);
      if (_session?.jwt != null) {
        final numeroNormalise = ApiConfig.normaliserTelephone(numeroSauve);
        await _authrepository.sauvegarderNumero(numeroNormalise);
        _numeroSauvegarder = numeroNormalise;
        await _authrepository.secureJWT(_session!);
        _session?.removeJwt();
      } else {
        _errorMessage = "Identifiants incorrects ou compte introuvable";
      }
    } catch (e) {
      _errorMessage = "Erreur lors de la connexion";
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
    if (password.length < 8) {
      _chargementEnCour = false;
      _errorMessage = "Le code PIN doit contenir au moins 8 chiffres";
      notifyListeners();
      return;
    }

    try {
      final numeroNormalise = ApiConfig.normaliserTelephone(numero);
      _session = await _authrepository.sinscrir(
        nom,
        numeroNormalise,
        email,
        password,
      );

      if (_session?.jwt != null) {
        await _authrepository.sauvegarderNumero(numeroNormalise);
        _numeroSauvegarder = numeroNormalise;
        await _authrepository.secureJWT(_session!);
        _session!.removeJwt();
      } else {
        _errorMessage = "Inscription impossible avec les informations saisies";
      }
    } catch (e) {
      _errorMessage = "Une erreur s'est produite lors de l'inscription";
      print(e);
    } finally {
      _chargementEnCour = false;
      notifyListeners();
    }
  }

  Future<void> envoyerOtp(String numero) async {
    _chargementEnCour = true;
    _errorMessage = null;
    notifyListeners();

    if (numero.isEmpty) {
      _chargementEnCour = false;
      _errorMessage = "le champ numero est vide";
      notifyListeners();
      return;
    }

    try {
      final numeroNormalise = ApiConfig.normaliserTelephone(numero);
      final success = await _authrepository.envoyerOtp(numeroNormalise);
      if (success) {
        await _authrepository.sauvegarderNumero(numeroNormalise);
        _numeroSauvegarder = numeroNormalise;
      } else {
        _errorMessage = "Impossible d'envoyer le code OTP";
      }
    } catch (e) {
      _errorMessage = "Une erreur s'est produite lors de l'envoi OTP";
      print(e);
    } finally {
      _chargementEnCour = false;
      notifyListeners();
    }
  }

  Future<void> verifierOtp(String numero, String code) async {
    _chargementEnCour = true;
    _errorMessage = null;
    notifyListeners();

    if (numero.isEmpty) {
      _chargementEnCour = false;
      _errorMessage = "le champ numero est vide";
      notifyListeners();
      return;
    }

    if (code.length != 6) {
      _chargementEnCour = false;
      _errorMessage = "Le code OTP doit contenir 6 chiffres";
      notifyListeners();
      return;
    }

    try {
      final numeroNormalise = ApiConfig.normaliserTelephone(numero);
      _session = await _authrepository.verifierOtp(numeroNormalise, code);

      if (_session?.jwt != null) {
        await _authrepository.sauvegarderNumero(numeroNormalise);
        _numeroSauvegarder = numeroNormalise;
        await _authrepository.secureJWT(_session!);
        _session!.removeJwt();
      } else {
        _errorMessage = "Code OTP invalide ou compte introuvable";
      }
    } catch (e) {
      _errorMessage = "Une erreur s'est produite lors de la vérification OTP";
      print(e);
    } finally {
      _chargementEnCour = false;
      notifyListeners();
    }
  }

  Future<void> seDeconnecter() async {
    _chargementEnCour = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authrepository.seDeconnecter();
      _session = null;
    } catch (e) {
      _errorMessage = "Une erreur s'est produite lors de la déconnexion";
      print(e);
    } finally {
      _chargementEnCour = false;
      notifyListeners();
    }
  }
}
