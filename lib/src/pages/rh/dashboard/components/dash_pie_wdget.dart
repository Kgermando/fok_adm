import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashRHPieWidget extends StatefulWidget {
  const DashRHPieWidget({Key? key}) : super(key: key);

  @override
  State<DashRHPieWidget> createState() => _DashRHPieWidgetState();
}

class _DashRHPieWidgetState extends State<DashRHPieWidget> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<AgentModel> agentList = [];
  Future<void> getData() async {
    var agents = await AgentsApi().getAllData();
    setState(() {
      agentList = agents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: SfCircularChart(
          legend: Legend(isVisible: true, isResponsive: true),
          series: <CircularSeries>[
            // Render pie chart
            PieSeries<AgentModel, String>(
                dataSource: agentList,
                // pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (AgentModel data, _) => data.sexe,
                yValueMapper: (AgentModel data, _) => data.sexe.length)
          ]),
    );
  }
}
