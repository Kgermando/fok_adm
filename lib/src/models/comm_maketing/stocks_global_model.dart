class StocksGlobalMOdel {
  late int? id;
  late String idProduct;
  late String quantity;
  late String quantityAchat;
  late String priceAchatUnit;
  late String prixVenteUnit;
  late String unite;
  late bool modeAchat;
  late String tva;
  late String qtyRavitailler;
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

  StocksGlobalMOdel({
    this.id,
    required this.idProduct,
    required this.quantity,
    required this.quantityAchat,
    required this.priceAchatUnit,
    required this.prixVenteUnit,
    required this.unite,
    required this.modeAchat,
    required this.tva,
    required this.qtyRavitailler,
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

  factory StocksGlobalMOdel.fromSQL(List<dynamic> row) {
    return StocksGlobalMOdel(
      id: row[0],
      idProduct: row[1],
      quantity: row[2],
      quantityAchat: row[3],
      priceAchatUnit: row[4],
      prixVenteUnit: row[5],
      unite: row[6],
      modeAchat: row[7],
      tva: row[8],
      qtyRavitailler: row[9],
        approbationDG: row[10],
        signatureDG: row[11],
        signatureJustificationDG: row[12],
        approbationFin: row[13],
        signatureFin: row[14],
        signatureJustificationFin: row[15],
        approbationBudget: row[16],
        signatureBudget: row[17],
        signatureJustificationBudget: row[18],
        approbationDD: row[19],
        signatureDD: row[20],
        signatureJustificationDD: row[21],
        signature: row[22],
        created: row[23]
    );
  }

  factory StocksGlobalMOdel.fromJson(Map<String, dynamic> json) {
    return StocksGlobalMOdel(
      id: json['id'],
      idProduct: json['idProduct'],
      quantity: json['quantity'],
      quantityAchat: json['quantityAchat'],
      priceAchatUnit: json['priceAchatUnit'],
      prixVenteUnit: json['prixVenteUnit'],
      unite: json['unite'],
      modeAchat: json['modeAchat'],
      tva: json["tva"],
      qtyRavitailler: json["qtyRavitailler"],
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
      'idProduct': idProduct,
      'quantity': quantity,
      'quantityAchat': quantityAchat,
      'priceAchatUnit': priceAchatUnit,
      'prixVenteUnit': prixVenteUnit,
      'unite': unite,
      'modeAchat': modeAchat,
      "tva": tva,
      "qtyRavitailler": qtyRavitailler,
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