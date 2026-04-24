import 'package:data_loop/Models/Transactions.dart';
import 'package:data_loop/Models/Wallet.dart';
import 'package:data_loop/Repositories/WalletRepository.dart';
import 'package:flutter/material.dart';

class Walletviewmodel extends ChangeNotifier {
  //1-Dépendances
  final Walletrepository _walletrepository;

  Walletviewmodel(this._walletrepository);

  //2-Etat
  Wallet? _portefeuille;
  List<Transactions> _transactions = [];
  bool _chargementEnCours = false;
  String? _errorMessage;

  //3-Getters
  Wallet? get portefeuille => _portefeuille;

  List<Transactions> get transactions => _transactions;

  bool get chargementEnCours => _chargementEnCours;

  String? get errorMessage => _errorMessage;

  //4-Initialisation
  Future<Wallet?> init() async {
    _chargementEnCours = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _portefeuille = await _walletrepository.recupererWallet();
    } catch (e) {
      _errorMessage =
          "Une erreur s'est produite lors de la récupération du solde wallet";
      print(e);
    } finally {
      _chargementEnCours = false;
      notifyListeners();
    }
    return _portefeuille;
  }

  //5-Actions
  Future<List<Transactions>?> recupererTransactions([
    String? idUtilisateur,
  ]) async {
    _chargementEnCours = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<Transactions>? transacs =
          await _walletrepository.recupererTransactions();
      _transactions = transacs ?? [];
      return transacs;
    } catch (e) {
      print(e);
      _errorMessage =
          "Erreur lors de la récupération de la liste des transactions";
      return null;
    } finally {
      _chargementEnCours = false;
      notifyListeners();
    }
  }

  Future<void> retrait(String montant, String mode_paiement) async {
    _chargementEnCours = true;
    _errorMessage = null;
    notifyListeners();

    if (montant.isEmpty) {
      _chargementEnCours = false;
      _errorMessage = "Montant du retrait est manquant";
      notifyListeners();

      return;
    }
    if (mode_paiement.isEmpty) {
      _chargementEnCours = false;
      _errorMessage = "Mode de paiement du retrait est manquant";
      notifyListeners();

      return;
    }

    try {
      final success = await _walletrepository.effectuerRetrait(
        montant,
        mode_paiement,
      );
      if (!success) {
        _errorMessage = "Le retrait n'a pas pu être enregistré";
      }
    } catch (e) {
      print(e);
      _errorMessage = "Une erreur s'est produite lors du retrait";
    } finally {
      _chargementEnCours = false;
      notifyListeners();
    }
  }
}
