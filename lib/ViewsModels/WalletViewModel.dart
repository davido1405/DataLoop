import 'package:data_loop/Repositories/WalletRepository.dart';
import 'package:flutter/material.dart';

class Walletviewmodel extends ChangeNotifier{
  final Walletrepository _walletrepository;
  Walletviewmodel(this._walletrepository);

}