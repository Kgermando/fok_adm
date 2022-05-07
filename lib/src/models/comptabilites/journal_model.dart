class JournalModel {
  late int? id;
  late String libele;
  late String compteDebit; 
  late String montantDebit; // Montant
  late String compteCredit;
  late String montantCredit; // TVA
  late String remarque;
  late bool statut;

  late String approbationDG; // button radio OUi et NON if non text field
  late String signatureDG;
  late String signatureJustificationDG;

  late String approbationDD;
  late String signatureDD; // directeur de departement
  late String signatureJustificationDD;
  
  late String signature;
  late DateTime created;

  JournalModel(
      {this.id,
      required this.libele,
      required this.compteDebit,
      required this.montantDebit,
      required this.compteCredit,
      required this.montantCredit,
      required this.remarque,
      required this.statut,
      required this.approbationDG,
      required this.signatureDG,
      required this.signatureJustificationDG,
      required this.approbationDD,
      required this.signatureDD,
      required this.signatureJustificationDD,
      required this.signature,
      required this.created});

  factory JournalModel.fromSQL(List<dynamic> row) {
    return JournalModel(
        id: row[0],
        libele: row[1],
        compteDebit: row[2],
        montantDebit: row[3],
        compteCredit: row[4],
        montantCredit: row[5],
        remarque: row[6],
        statut: row[7],
        approbationDG: row[8],
        signatureDG: row[9],
        signatureJustificationDG: row[10],
        approbationDD: row[11],
        signatureDD: row[12],
        signatureJustificationDD: row[13],
        signature: row[14],
        created: row[15]);
  }

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
        id: json['id'],
        libele: json['libele'],
        compteDebit: json['compteDebit'],
        montantDebit: json['montantDebit'],
        compteCredit: json['compteCredit'],
        montantCredit: json['montantCredit'],
        remarque: json['remarque'],
        statut: json['statut'],
        approbationDG: json['approbationDG'],
        signatureDG: json['signatureDG'],
        signatureJustificationDG: json['signatureJustificationDG'],
        approbationDD: json['approbationDD'],
        signatureDD: json['signatureDD'],
        signatureJustificationDD: json['signatureJustificationDD'],
        signature: json['signature'],
        created: DateTime.parse(json['created']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libele': libele,
      'compteDebit': compteDebit,
      'montantDebit': montantDebit,
      'compteCredit': compteCredit,
      'montantCredit': montantCredit,
      'remarque': remarque,
      'statut': statut,
      'approbationDG': approbationDG,
      'signatureDG': signatureDG,
      'signatureJustificationDG': signatureJustificationDG,
      'approbationDD': approbationDD,
      'signatureDD': signatureDD,
      'signatureJustificationDD': signatureJustificationDD,
      'signature': signature,
      'created': created.toIso8601String()
    };
  }
}