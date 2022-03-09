class CreanceModel {
  final int? id;
  final String nomComplet;
  final String pieceJustificative;
  final String libelle;
  final String montant;
  final DateTime date;
  final String numeroOperation;

 CreanceModel( 
    {
      this.id,
    required this.nomComplet,
    required this.pieceJustificative,
    required this.libelle,
    required this.montant,
    required this.date,
    required this.numeroOperation,
  });

  factory CreanceModel.fromSQL(List<dynamic> row) {
    return CreanceModel(
        id: row[0],
        nomComplet: row[1],
        pieceJustificative: row[2],
        libelle: row[3],
        montant: row[4],
        date: row[5],
        numeroOperation: row[6]
    );
  }

  factory CreanceModel.fromJson(Map<String, dynamic> json) {
    return CreanceModel(
      id: json['id'],
      nomComplet: json['nomComplet'],
      pieceJustificative: json['pieceJustificative'],
      libelle: json['libelle'],
      montant: json['montant'],
      date: DateTime.parse(json['date']),
      numeroOperation: json['numeroOperation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomComplet': nomComplet,
      'pieceJustificative': pieceJustificative,
      'libelle': libelle,
      'montant': montant,
      'date': date.toIso8601String(),
      'numeroOperation': numeroOperation,
    };
  }
}
