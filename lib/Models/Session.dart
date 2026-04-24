class Session {
  final int id;
  final String nomUtilisateur;
  final String telephone;
  final String? email;
  final String role;
  final String? statut;
  final num? score_confiance;
  final num? solde_virtuel;
  String? jwt;

  Session({
    required this.id,
    required this.nomUtilisateur,
    required this.telephone,
    this.email,
    required this.role,
    required this.statut,
    required this.score_confiance,
    required this.solde_virtuel,
    this.jwt,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: _toNum(json['id'])?.toInt() ?? 0,
      nomUtilisateur: json['name']?.toString() ?? 'Utilisateur',
      telephone: json['telephone']?.toString() ?? '',
      email: json['email']?.toString(),
      role: json['role']?.toString() ?? '',
      statut: json['statut']?.toString(),
      score_confiance: _toNum(json['score_confiance']),
      solde_virtuel: _toNum(json['solde_virtuel']),
      jwt: json['access_token']?.toString(),
    );
  }

  static num? _toNum(dynamic value) {
    if (value is num) {
      return value;
    }
    return num.tryParse(value?.toString() ?? '');
  }

  @override
  String toString() {
    return 'Session(nom: $nomUtilisateur, telephone: $telephone, email: $email, jwt: $jwt)';
  }

  void removeJwt() {
    jwt = null;
  }
}
