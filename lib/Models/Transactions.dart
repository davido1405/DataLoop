class Transactions {
  late final String id;
  late final String utilisateurId;
  late final String annotationId;
  late final String typeTransaction;
  late final String libelleTransaction;
  late final String montantTransaction;
  late final String soldeAvant;
  late final String soldeApres;
  late final String referenceTache;
  late final String dateTransaction;

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

  factory Transactions.fromJson(Map<String,dynamic>json){
    return Transactions(id: json['id'], utilisateurId: json['utilisateur_id'], annotationId: json['annotation_id'], typeTransaction: json['type'], libelleTransaction: json['libelle'], montantTransaction: json['montant'], soldeAvant: json['solde_avant'], soldeApres: json['solde_apres'], referenceTache: json['reference_tache'], dateTransaction: json['created_at']);
  }
}
