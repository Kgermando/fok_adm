class MailModel {
  late int? id;
  late String fullName;
  late String email;
  late List cc;
  late String objet;
  late String message;
  late String pieceJointe;
  late bool read;
  late DateTime dateSend;
  late DateTime dateRead;

  MailModel(
    { this.id,
      required this.fullName,
      required this.email,
      required this.cc,
      required this.objet,
      required this.message,
      required this.pieceJointe,
      required this.read,
      required this.dateSend,
      required this.dateRead
  });

  factory MailModel.fromSQL(List<dynamic> row) {
    return MailModel(
        id: row[0],
        fullName: row[1],
        email: row[2],
        cc: row[3],
        objet: row[4],
        message: row[5],
        pieceJointe: row[6],
        read: row[7],
        dateSend: row[8],
        dateRead: row[9]
    );
  }

  factory MailModel.fromJson(Map<String, dynamic> json) {
    return MailModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      cc: json['cc'],
      objet: json['objet'],
      message: json['message'],
      pieceJointe: json['pieceJointe'],
      read: json['read'],
      dateSend: DateTime.parse(json['dateSend']),
      dateRead: DateTime.parse(json['dateRead'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'cc': cc,
      'objet': objet,
      'message': message,
      'pieceJointe': pieceJointe,
      'read': read,
      'dateSend': dateSend.toIso8601String(),
      'dateRead': dateRead.toIso8601String()
    };
  }
}