class PieChartModel {
  final String departement;
  final int count;

  PieChartModel({required this.departement, required this.count});

  factory PieChartModel.fromSQL(List<dynamic> row) {
    return PieChartModel(
      departement: row[0],
      count: row[1],
    );
  }

  factory PieChartModel.fromJson(Map<String, dynamic> json) {
    return PieChartModel(departement: json['departement'], count: json['count']);
  }

  Map<String, dynamic> toJson() {
    return {'departement': departement, 'count': count};
  }
}
