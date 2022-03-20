class DepensesModel {
  final int? id;
  final String nomComplet;
  final String pieceJustificative;
  final String naturePayement;
  final String montant;
  final List<dynamic> coupureBillet;
  final String ligneBudgtaire; // somme d'affectation pour le budget
  final DateTime date;
  final String numeroOperation;
  final String modePayement;

  DepensesModel( 
    {
      this.id,
    required this.nomComplet,
    required this.pieceJustificative,
    required this.naturePayement,
    required this.montant,
    required this.coupureBillet,
    required this.ligneBudgtaire,
    required this.date,
    required this.numeroOperation,
    required this.modePayement,
  });

  factory DepensesModel.fromSQL(List<dynamic> row) {
    return DepensesModel(
        id: row[0],
        nomComplet: row[1],
        pieceJustificative: row[2],
        naturePayement: row[3],
        montant: row[4],
        coupureBillet: row[5],
        ligneBudgtaire: row[6],
        date: row[7],
        numeroOperation: row[8],
        modePayement: row[9]
    );
  }

  factory DepensesModel.fromJson(Map<String, dynamic> json) {
    return DepensesModel(
      id: json['id'],
      nomComplet: json['nomComplet'],
      pieceJustificative: json['pieceJustificative'],
      naturePayement: json['naturePayement'],
      montant: json['montant'],
      coupureBillet: json['coupureBillet'],
      ligneBudgtaire: json['ligneBudgtaire'],
      date: DateTime.parse(json['date']),
      numeroOperation: json['numeroOperation'],
      modePayement: json['modePayement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomComplet': nomComplet,
      'pieceJustificative': pieceJustificative,
      'naturePayement': naturePayement,
      'montant': montant,
      'coupureBillet': coupureBillet,
      'ligneBudgtaire': ligneBudgtaire,
      'date': date.toIso8601String(),
      'numeroOperation': numeroOperation,
      'modePayement': modePayement,
    };
  }
}
