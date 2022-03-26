class PresenceModel {
  late int? id;
  late String matricule;
  late DateTime arrive;
  late DateTime sortie;
  late bool presence;
  late String motif;
  late DateTime created;

  PresenceModel(
    {
      this.id,
      required this.matricule,
      required this.arrive,
      required this.sortie,
      required this.presence,
      required this.motif,
      required this.created
    }
  );

  factory PresenceModel.fromSQL(List<dynamic> row) {
    return PresenceModel(
      id: row[0], 
      matricule: row[1], 
      arrive: row[2], 
      sortie: row[3], 
      presence: row[4], 
      motif: row[5],
      created: row[6]
    );
  }

  factory PresenceModel.fromJson(Map<String, dynamic> json) {
    return PresenceModel(
      id: json['id'],
      matricule: json['matricule'],
      arrive: DateTime.parse(json['arrive']),
      sortie: DateTime.parse(json['sortie']),
      presence: json['presence'],
      motif: json['motif'],
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matricule': matricule,
      'arrive': arrive.toIso8601String(),
      'sortie': sortie.toIso8601String(),
      'presence': presence,
      'motif': motif,
      'created': created.toIso8601String()
    };
  }
  
}