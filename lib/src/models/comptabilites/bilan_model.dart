class BilanModel {
  final int? id;
  final String titleBilan;
  final String comptes;
  final String intitule;
  final String montant;
  final String typeBilan; // Actif ou Passif
  final DateTime date;

  BilanModel({
    this.id, 
    required this.titleBilan, 
    required this.comptes, 
    required this.intitule, 
    required this.montant, 
    required this.typeBilan, 
    required this.date
  });

  factory BilanModel.fromSQL(List<dynamic> row) {
    return BilanModel(
      id: row[0],
      titleBilan: row[1],
      comptes: row[2],
      intitule: row[3],
      montant: row[4],
      typeBilan: row[5],
      date: row[6]
    );
  }

  factory BilanModel.fromJson(Map<String, dynamic> json) {
    return BilanModel(
      id: json['id'],
      titleBilan: json['titleBilan'],
      comptes: json['comptes'],
      intitule: json['intitule'],
      montant: json['montant'],
      typeBilan: json['typeBilan'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleBilan': titleBilan,
      'comptes': comptes,
      'intitule': intitule,
      'montant': montant,
      'typeBilan': typeBilan,
      'date': date.toIso8601String(),
    };
  }
}