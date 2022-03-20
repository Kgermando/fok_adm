class ValorisationModel {
  final int? id;
  final String numeroOrdre;
  final String intitule;
  final String quantite;
  final String prixUnitaire;
  final String prixTotal;
  final String source;
  final DateTime date;

  ValorisationModel({
    this.id,
    required this.numeroOrdre,
    required this.intitule,
    required this.quantite,
    required this.prixUnitaire,
    required this.prixTotal,
    required this.source,
    required this.date
  });

  factory ValorisationModel.fromSQL(List<dynamic> row) {
    return ValorisationModel(
      id: row[0],
      numeroOrdre: row[1],
      intitule: row[2],
      quantite: row[3],
      prixUnitaire: row[4],
      prixTotal: row[5],
      source: row[6],
      date: row[7]
    );
  }

  factory ValorisationModel.fromJson(Map<String, dynamic> json) {
    return ValorisationModel(
      id: json['id'],
      numeroOrdre: json['numeroOrdre'],
      intitule: json['intitule'],
      quantite: json['quantite'],
      prixUnitaire: json['prixUnitaire'],
      prixTotal: json['prixTotal'],
      source: json['source'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroOrdre': numeroOrdre,
      'intitule': intitule,
      'quantite': quantite,
      'prixUnitaire': prixUnitaire,
      'prixTotal': prixTotal,
      'source': source,
      'date': date.toIso8601String(),
    };
  }
}
