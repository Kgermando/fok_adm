class EtatMaterielModel {
  late int? id;
  late String nom;
  late String modele;
  late String marque;
  late String typeObjet;  // anguin , mobilier ou immobilier,
  late String statut;
  
  late String approbationDG; // button radio OUi et NON if non text field
  late String signatureDG;
  late String signatureJustificationDG;

  late String approbationFin;
  late String signatureFin;
  late String signatureJustificationFin;

  late String approbationBudget;
  late String signatureBudget;
  late String signatureJustificationBudget;

  late String approbationDD;
  late String signatureDD; // directeur de departement
  late String signatureJustificationDD;

  late String signature; // celui qui fait le document
  late DateTime created;

  EtatMaterielModel(
      {this.id,
      required this.nom,
      required this.modele,
      required this.marque,
      required this.typeObjet,
      required this.statut,
      required this.approbationDG,
      required this.signatureDG,
      required this.signatureJustificationDG,
      required this.approbationFin,
      required this.signatureFin,
      required this.signatureJustificationFin,
      required this.approbationBudget,
      required this.signatureBudget,
      required this.signatureJustificationBudget,
      required this.approbationDD,
      required this.signatureDD,
      required this.signatureJustificationDD,
      required this.signature,
      required this.created
      
    });

  factory EtatMaterielModel.fromSQL(List<dynamic> row) {
    return EtatMaterielModel(
        id: row[0],
        nom: row[1],
        modele: row[2],
        marque: row[3],
        typeObjet: row[4],
        statut: row[5],
        approbationDG: row[6],
        signatureDG: row[7],
        signatureJustificationDG: row[8],
        approbationFin: row[9],
        signatureFin: row[10],
        signatureJustificationFin: row[11],
        approbationBudget: row[12],
        signatureBudget: row[13],
        signatureJustificationBudget: row[14],
        approbationDD: row[15],
        signatureDD: row[16],
        signatureJustificationDD: row[17],
        signature: row[18],
        created: row[19]
    );
  }

  factory EtatMaterielModel.fromJson(Map<String, dynamic> json) {
    return EtatMaterielModel(
        id: json['id'],
        nom: json['nom'],
        modele: json['modele'],
        marque: json['marque'],
        typeObjet: json['typeObjet'],
        statut: json['statut'],
        approbationDG: json['approbationDG'],
        signatureDG: json['signatureDG'],
        signatureJustificationDG: json['signatureJustificationDG'],
        approbationFin: json['approbationFin'],
        signatureFin: json['signatureFin'],
        signatureJustificationFin: json['signatureJustificationFin'],
        approbationBudget: json['approbationBudget'],
        signatureBudget: json['signatureBudget'],
        signatureJustificationBudget: json['signatureJustificationBudget'],
        approbationDD: json['approbationDD'],
        signatureDD: json['signatureDD'],
        signatureJustificationDD: json['signatureJustificationDD'],
        signature: json['signature'],
        created: DateTime.parse(json['created'])
        
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'modele': modele,
      'marque': marque,
      'typeObjet': typeObjet,
      'statut': statut,
      'approbationDG': approbationDG,
      'signatureDG': signatureDG,
      'signatureJustificationDG': signatureJustificationDG,
      'approbationFin': approbationFin,
      'signatureFin': signatureFin,
      'signatureJustificationFin': signatureJustificationFin,
      'approbationBudget': approbationBudget,
      'signatureBudget': signatureBudget,
      'signatureJustificationBudget': signatureJustificationBudget,
      'approbationDD': approbationDD,
      'signatureDD': signatureDD,
      'signatureJustificationDD': signatureJustificationDD,
      'signature': signature,
      'created': created.toIso8601String()
    };
  }
}