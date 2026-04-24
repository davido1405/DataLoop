class Taches {
  late final String id;
  late final String type_tache;
  late final String question;
  late List<String>? options_reponse;
  late final Map<String,dynamic>image;

  Taches({required this.id, required this.type_tache, required this.question, this.options_reponse,
    required this.image});

  factory Taches.fromJson(Map<String,dynamic>json){
    return Taches(id: json['id'], type_tache: json['type_tache'], question: json['question'], image: json['image']);
  }

}