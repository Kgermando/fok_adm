import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/components/dash_number_widget.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/components/dash_pie_wdget.dart';


class DashboardRh extends StatefulWidget {
  const DashboardRh({Key? key}) : super(key: key);

  @override
  State<DashboardRh> createState() => _DashboardRhState();
}

class _DashboardRhState extends State<DashboardRh> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  int agentsCount = 0;
  int agentActifCount = 0;
  int agentInactifCount = 0;
  int agentFemmeCount = 0;
  int agentHommeCount = 0;

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      getData();
      timer.cancel();
    }));

    super.initState();
  }

  Future<void> getData() async {
    var agents = await AgentsApi().getAllData();
    setState(() {
      agentsCount = agents.length;
      agentActifCount =
          agents.where((element) => element.statutAgent == true).length;
      agentInactifCount =
          agents.where((element) => element.statutAgent == false).length;
      agentFemmeCount =
          agents.where((element) => element.sexe == 'Femme').length;
      agentHommeCount =
          agents.where((element) => element.sexe == 'Homme').length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppbar(
                          title: 'Dashboard RH',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                DashNumberWidget(
                                    number: '$agentsCount',
                                    title: 'Total agents',
                                    icon: Icons.group,
                                    color: Colors.blue.shade700),
                                DashNumberWidget(
                                    number: '$agentActifCount',
                                    title: 'Agent Actifs',
                                    icon: Icons.person,
                                    color: Colors.green.shade700),
                                DashNumberWidget(
                                    number: '$agentInactifCount',
                                    title: 'Agent inactifs',
                                    icon: Icons.person_off,
                                    color: Colors.red.shade700),
                                DashNumberWidget(
                                    number: '$agentFemmeCount',
                                    title: 'Femmes',
                                    icon: Icons.woman_sharp,
                                    color: Colors.pink.shade700),
                                DashNumberWidget(
                                    number: '$agentHommeCount',
                                    title: 'Hommes',
                                    icon: Icons.man_sharp,
                                    color: Colors.grey.shade700),
                              ],
                            ),
                            Wrap(
                              children: const [
                                DashRHPieWidget(),
                              ],
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
