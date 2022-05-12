import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/models/charts/pie_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EnguinPie extends StatefulWidget {
  const EnguinPie({ Key? key }) : super(key: key);

  @override
  State<EnguinPie> createState() => _EnguinPieState();
}

class _EnguinPieState extends State<EnguinPie> {
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

  List<PieChartEnguinModel> dataList = [];
  Future<void> getData() async {
    var data = await AnguinApi().getChartPie();
    setState(() {
      dataList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: SfCircularChart(
          title: ChartTitle(text: "Type d'anguins",
              textStyle: const TextStyle(fontWeight: FontWeight.bold)),
          legend: Legend(isVisible: true, isResponsive: true),
          series: <CircularSeries>[
            // Render pie chart
            PieSeries<PieChartEnguinModel, String>(
                dataSource: dataList,
                // pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (PieChartEnguinModel data, _) => data.genre,
                yValueMapper: (PieChartEnguinModel data, _) => data.count)
          ]),
    );
  }
}