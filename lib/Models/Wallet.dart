class Wallet {
  late final String solde;

  Wallet({required this.solde});
  factory Wallet.fromJson(Map<String,dynamic>json){
    return Wallet(solde: json['solde_virtuel']);
  }
}