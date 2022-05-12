import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/charts/pie_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DeviePieDepMounth extends StatefulWidget {
  const DeviePieDepMounth({ Key? key }) : super(key: key);

  @override
  State<DeviePieDepMounth> createState() => _DeviePieDepMounthState();
}

class _DeviePieDepMounthState extends State<DeviePieDepMounth> {
  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      setState(() {
        getData();
      });

      timer.cancel();
    }));
    super.initState();
  }

  List<PieChartModel> dataList = [];
  Future<void> getData() async {
    var agents = await DevisAPi().getChartPieDepMounth();
    setState(() {
      dataList = agents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(p8),
      child: Material(
        elevation: 10.0,
        child: SfCircularChart(
            title: ChartTitle(text: 'Dépenses mensuelle par département', 
            textStyle: const TextStyle(fontWeight: FontWeight.bold)),
            legend: Legend(isVisible: true, isResponsive: true),
            series: <CircularSeries>[
              // Render pie chart
              PieSeries<PieChartModel, String>(
                  dataSource: dataList,
                  // pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (PieChartModel data, _) => data.departement,
                  yValueMapper: (PieChartModel data, _) => data.count)
            ]),
      ),
    );
  }
}
