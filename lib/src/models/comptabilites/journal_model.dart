class JournalModel {
  final int? id;
  final String titleBilan;
  final String comptes;
  final String intitule;
  final String montant;
  final String typeJournal; // Debit ou Credit
  final DateTime date;

  JournalModel(
      {this.id,
      required this.titleBilan,
      required this.comptes,
      required this.intitule,
      required this.montant,
      required this.typeJournal,
      required this.date});

  factory JournalModel.fromSQL(List<dynamic> row) {
    return JournalModel(
      id: row[0],
      titleBilan: row[1],
      comptes: row[2],
      intitule: row[3],
      montant: row[4],
      typeJournal: row[5],
      date: row[6]
    );
  }

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'],
      titleBilan: json['titleBilan'],
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
      'titleBilan': titleBilan,
      'comptes': comptes,
      'intitule': intitule,
      'montant': montant,
      'typeJournal': typeJournal,
      'date': date.toIso8601String(),
    };
  }
}
