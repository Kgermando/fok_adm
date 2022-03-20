class AmortissementModel {
  final int? id;
  final String titleArmotissement;
  final String comptes;
  final String intitule;
  final String montant;
  final String typeJournal; // Debit ou Credit
  final DateTime date;

  AmortissementModel(
      {this.id,
      required this.titleArmotissement,
      required this.comptes,
      required this.intitule,
      required this.montant,
      required this.typeJournal,
      required this.date});

  factory AmortissementModel.fromSQL(List<dynamic> row) {
    return AmortissementModel(
        id: row[0],
        titleArmotissement: row[1],
        comptes: row[2],
        intitule: row[3],
        montant: row[4],
        typeJournal: row[5],
        date: row[6]);
  }

  factory AmortissementModel.fromJson(Map<String, dynamic> json) {
    return AmortissementModel(
      id: json['id'],
      titleArmotissement: json['titleArmotissement'],
      comptes: json['comptes'],
      intitule: json['intitule'],
      montant: json['montant'],
      typeJournal: json['typeJournal'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleArmotissement': titleArmotissement,
      'comptes': comptes,
      'intitule': intitule,
      'montant': montant,
      'typeJournal': typeJournal,
      'date': date.toIso8601String(),
    };
  }
}
