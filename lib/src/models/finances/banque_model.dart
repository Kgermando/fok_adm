class CaisseModel {
  final int? id;
  final String nomComplet;
  final String pieceJustificative;
  final String libelle;
  final String montant;
  final List<dynamic> coupureBillet;
  final String ligneBudgtaire; // somme d'affectation pour le budget
  final String deperatment;
  final String typeOperation;
  final DateTime date;

  CaisseModel( 
    {
      this.id,
    required this.nomComplet,
    required this.pieceJustificative,
    required this.libelle,
    required this.montant,
    required this.coupureBillet,
    required this.ligneBudgtaire,
    required this.deperatment,
    required this.typeOperation,
    required this.date,
  });

  factory CaisseModel.fromSQL(List<dynamic> row) {
    return CaisseModel(
        id: row[0],
        nomComplet: row[1],
        pieceJustificative: row[2],
        libelle: row[3],
        montant: row[4],
        coupureBillet: row[5],
        ligneBudgtaire: row[6],
        deperatment: row[7],
        typeOperation: row[8],
        date: row[9]
    );
  }

  factory CaisseModel.fromJson(Map<String, dynamic> json) {
    return CaisseModel(
      id: json['id'],
      nomComplet: json['nomComplet'],
      pieceJustificative: json['pieceJustificative'],
      libelle: json['libelle'],
      montant: json['montant'],
      coupureBillet: json['coupureBillet'],
      ligneBudgtaire: json['ligneBudgtaire'],
      deperatment: json['deperatment'],
      typeOperation: json['typeOperation'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomComplet': nomComplet,
      'pieceJustificative': pieceJustificative,
      'libelle': libelle,
      'montant': montant,
      'coupureBillet': coupureBillet,
      'ligneBudgtaire': ligneBudgtaire,
      'deperatment': deperatment,
      'typeOperation': typeOperation,
      'date': date.toIso8601String(),
    };
  }
}
