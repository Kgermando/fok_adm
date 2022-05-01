import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/models/rh/agent_count_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashRHPieWidget extends StatefulWidget {
  const DashRHPieWidget({Key? key}) : super(key: key);

  @override
  State<DashRHPieWidget> createState() => _DashRHPieWidgetState();
}

class _DashRHPieWidgetState extends State<DashRHPieWidget> {
  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      getData();
      timer.cancel();
    }));
    super.initState();
  }

  List<AgentPieChartModel> agentList = [];
  Future<void> getData() async {
    var agents = await AgentsApi().getChartPieSexe();
    setState(() {
      agentList = agents;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Card(
      elevation: 10.0,
      child: SfCircularChart(
          title: ChartTitle(text: 'Genre', textStyle: bodyLarge),
          legend: Legend(isVisible: true, isResponsive: true),
          series: <CircularSeries>[
            // Render pie chart
            PieSeries<AgentPieChartModel, String>(
                dataSource: agentList,
                // pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (AgentPieChartModel data, _) => data.sexe,
                yValueMapper: (AgentPieChartModel data, _) => data.count)
          ]),
    );
  }
}
