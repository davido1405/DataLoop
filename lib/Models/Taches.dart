class Taches {
  final String id;
  final String type_tache;
  final String question;
  final List<String> options_reponse;
  final Map<String, dynamic> image;
  final String statut;
  final int? nb_annotations_requises;
  final int? annotations_count;

  Taches({
    required this.id,
    required this.type_tache,
    required this.question,
    required this.image,
    this.options_reponse = const [],
    this.statut = '',
    this.nb_annotations_requises,
    this.annotations_count,
  });

  factory Taches.fromJson(Map<String, dynamic> json) {
    final imageJson = json['image'];
    final optionsJson = json['options_reponse'];

    return Taches(
      id: json['id']?.toString() ?? '',
      type_tache: json['type_tache']?.toString() ?? '',
      question: json['question']?.toString() ?? 'Question indisponible',
      image: imageJson is Map<String, dynamic>
          ? imageJson
          : imageJson is Map
              ? Map<String, dynamic>.from(imageJson)
              : <String, dynamic>{},
      options_reponse: optionsJson is List
          ? optionsJson.map((option) => option.toString()).toList()
          : const [],
      statut: json['statut']?.toString() ?? '',
      nb_annotations_requises:
          _toInt(json['nb_annotations_requises']),
      annotations_count: _toInt(json['annotations_count']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '');
  }

  String? get imageUrl {
    final fullUrl = image['url']?.toString();
    if (fullUrl != null && fullUrl.isNotEmpty) {
      return fullUrl;
    }

    final stockageUrl = image['url_stockage']?.toString();
    return stockageUrl != null && stockageUrl.isNotEmpty ? stockageUrl : null;
  }

  String get categorieImage => image['categorie']?.toString() ?? 'Image';
}
