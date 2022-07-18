class GrandLivreModel {
  late String comptedebit;
  late DateTime dateStart;
  late DateTime dateEnd;

  GrandLivreModel(
      {required this.comptedebit,
      required this.dateStart,
      required this.dateEnd});

  factory GrandLivreModel.fromJson(Map<String, dynamic> json) {
    return GrandLivreModel(
        comptedebit: json['comptedebit'], 
        dateStart: DateTime.parse(json['dateStart']),
        dateEnd: DateTime.parse(json['dateEnd']));
  }

  Map<String, dynamic> toJson() {
    return {
      'comptedebit': comptedebit, 
      'dateStart': dateStart.toIso8601String(),
      'dateEnd': dateEnd.toIso8601String()
    };
  }
}
