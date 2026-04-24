import 'dart:convert';

import 'package:data_loop/Models/Transactions.dart';
import 'package:data_loop/Models/Wallet.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class Walletrepository {
  String? baseUrl= dotenv.env['BASE_URL'];
  Future<Wallet?>recupererWallet()async{
    final url=Uri.parse("$baseUrl/api/v1/wallet/balance");
    final response=await get(url,headers: {"content-Type":"application/json"});

    if(response.statusCode==200){

      return jsonDecode(response.body);
    }
    return null;
  }

  Future<List<Transactions>?>recupererTransactions(String id_utilisateur)async{
    final url=Uri.parse("$baseUrl/api/v1/wallet/transactions");
    final response=await get(url,headers: {"content-Type":"application/json"});

    if(response.statusCode==200){
      final donnees=jsonDecode(response.body) as Map<String,dynamic>;
      List<Transactions> transactions=(donnees['data']).map(Transactions.fromJson(donnees)).toList();
      return transactions;
    }
    return null;
  }

  Future<void>effectuerRetrait(String montant,String mode_paiement)async{

    final secure=await FlutterSecureStorage();
    final token = secure.read(key: "jwt_token");
    final url=Uri.parse("$baseUrl/api/v1/wallet/withdraw");
    final response=await post(url,headers: {"content-Type":"application/json",
      "Authorization": "Bearer $token",},body: jsonEncode([
      {
        "montant":montant,
        "mode_paiement":mode_paiement
      }]));

    if(response.statusCode==201){
      final data=jsonDecode(response.body);
      print(data['message']);
    }
  }

}