class Session {
  late final int id;
  late final String nomUtilisateur;
  late final String telephone;
  late final String? email;
  late final String role;
  late final String? statut;
  late final int? score_confiance;
  late final int? solde_virtuel;
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
      id: json['id'],
      nomUtilisateur: json['name'],
      telephone: json['telephone'],
      email: json['email']??'Aucun email',
      role: json['role'],
      statut: json['statut'],
      score_confiance: json['score_confiance'],
      solde_virtuel: json['solde_virtuel'],
      jwt: json['access_token']
    );
  }

  @override
  String toString() {
    return 'Session(nom: $nomUtilisateur, telephone: $telephone, email: $email, jwt: $jwt)';
  }

  void removeJwt() {
    this.jwt = null;
  }
}
