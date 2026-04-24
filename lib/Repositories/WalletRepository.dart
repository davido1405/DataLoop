import 'dart:convert';

import 'package:data_loop/Models/Transactions.dart';
import 'package:data_loop/Models/Wallet.dart';
import 'package:http/http.dart';

import 'ApiConfig.dart';

class Walletrepository {
  String get baseUrl => ApiConfig.baseUrl;

  Future<Wallet?> recupererWallet() async {
    final url = Uri.parse("$baseUrl/api/v1/wallet/balance");
    final response = await get(url, headers: await ApiConfig.authHeaders());

    if (response.statusCode == 200) {
      final donnees = jsonDecode(response.body) as Map<String, dynamic>;
      return Wallet.fromJson(donnees);
    }
    return null;
  }

  Future<List<Transactions>?> recupererTransactions() async {
    final url = Uri.parse("$baseUrl/api/v1/wallet/transactions")
        .replace(queryParameters: {'per_page': '20'});
    final response = await get(url, headers: await ApiConfig.authHeaders());

    if (response.statusCode == 200) {
      final donnees = jsonDecode(response.body) as Map<String, dynamic>;
      final data = donnees['data'];
      if (data is! List) {
        return [];
      }

      final transactions = data.whereType<Map>().map((transaction) {
        return Transactions.fromJson(
          Map<String, dynamic>.from(transaction),
        );
      }).toList();
      return transactions;
    }
    return null;
  }

  Future<bool> effectuerRetrait(String montant, String methodePaiement) async {
    final url = Uri.parse("$baseUrl/api/v1/wallet/withdraw");
    final response = await post(
      url,
      headers: await ApiConfig.authHeaders(),
      body: jsonEncode({
        "montant": num.tryParse(montant) ?? 0,
        "methode_paiement": methodePaiement,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print(data['message']);
      return true;
    }
    return false;
  }
}
