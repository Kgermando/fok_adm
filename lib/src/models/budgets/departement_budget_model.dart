class DepartementBudgetModel { 
  late int? id;
  late String departement;
  late DateTime periodeDebut; // Durée
  late DateTime periodeFin; // Durée de fin
  late String totalGlobalDispo;
  late String totalGlobalFinExt; // Reste à trouver
  late String totalGlobalPrevisionel;
  
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
  late String signatureDD;  // directeur de departement
  late String signatureJustificationDD;

  late String signature; // celui qui fait le document
  late DateTime created;

  DepartementBudgetModel(
      {this.id,
      required this.departement,
      required this.periodeDebut,
      required this.periodeFin,
      required this.totalGlobalDispo,
      required this.totalGlobalFinExt,
      required this.totalGlobalPrevisionel, 

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
    }
  ); 

  factory DepartementBudgetModel.fromSQL(List<dynamic> row) {
    return DepartementBudgetModel(
        id: row[0],
        departement: row[1],
        periodeDebut: row[2],
        periodeFin: row[3],
        totalGlobalDispo: row[4],
        totalGlobalFinExt: row[5],
        totalGlobalPrevisionel: row[6],

        approbationDG: row[7],
        signatureDG: row[8],
        signatureJustificationDG: row[9],
        approbationFin: row[10],
        signatureFin: row[11],
        signatureJustificationFin: row[12],
        approbationBudget: row[13],
        signatureBudget: row[14],
        signatureJustificationBudget: row[15],
        approbationDD: row[16],
        signatureDD: row[17],
        signatureJustificationDD: row[18],

        signature: row[19],
        created: row[20]
    );
  }

  factory DepartementBudgetModel.fromJson(Map<String, dynamic> json) {
    return DepartementBudgetModel(
        id: json['id'],
        departement: json['departement'],
        periodeDebut: DateTime.parse(json['periodeDebut']),
        periodeFin: DateTime.parse(json['periodeFin']),
        totalGlobalDispo: json['totalGlobalDispo'],
        totalGlobalFinExt: json['totalGlobalFinExt'],
        totalGlobalPrevisionel: json['totalGlobalPrevisionel'],

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
      'departement': departement,
      'periodeDebut': periodeDebut.toIso8601String(),
      'periodeFin': periodeFin.toIso8601String(),
      'totalGlobalDispo': totalGlobalDispo,
      'totalGlobalFinExt': totalGlobalFinExt,
      'totalGlobalPrevisionel': totalGlobalPrevisionel,
      
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
