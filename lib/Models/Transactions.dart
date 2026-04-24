class Transactions {
  final String id;
  final String utilisateurId;
  final String annotationId;
  final String typeTransaction;
  final String libelleTransaction;
  final String montantTransaction;
  final String soldeAvant;
  final String soldeApres;
  final String referenceTache;
  final String dateTransaction;

  Transactions({
    required this.id,
    required this.utilisateurId,
    required this.annotationId,
    required this.typeTransaction,
    required this.libelleTransaction,
    required this.montantTransaction,
    required this.soldeAvant,
    required this.soldeApres,
    required this.referenceTache,
    required this.dateTransaction,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      id: json['id']?.toString() ?? '',
      utilisateurId: json['utilisateur_id']?.toString() ?? '',
      annotationId: json['annotation_id']?.toString() ?? '',
      typeTransaction: json['type']?.toString() ?? '',
      libelleTransaction: json['libelle']?.toString() ?? 'Transaction',
      montantTransaction: json['montant']?.toString() ?? '0',
      soldeAvant: json['solde_avant']?.toString() ?? '0',
      soldeApres: json['solde_apres']?.toString() ?? '0',
      referenceTache: json['reference_tache']?.toString() ?? '',
      dateTransaction: json['created_at']?.toString() ?? '',
    );
  }
}
