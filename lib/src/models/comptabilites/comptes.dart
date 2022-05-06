class Comptes {
  late String compte;
  late String montant;

  Comptes({required this.compte, required this.montant});

  factory Comptes.fromJson(Map<String, dynamic> json) {
    return Comptes(compte: json['compte'], montant: json['montant']);
  }
}
