import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/api/logistiques/carburant_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/components/dash_number_widget.dart';
import 'package:intl/intl.dart';

class DashboardLog extends StatefulWidget {
  const DashboardLog({ Key? key }) : super(key: key);

  @override
  State<DashboardLog> createState() => _DashboardLogState();
}

class _DashboardLogState extends State<DashboardLog> {
   final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  int projetsCount = 0;
  int projetsApprouveCount = 0;
  double projetsInvestissementfCount = 0.0; // Tous les projets
  double versementCount = 0.0; // Tous les projets

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      getData();
      timer.cancel();
    }));

    super.initState();
  }

  Future<void> getData() async {
    var projets = await AnguinApi().getAllData();
    var versements = await CarburantApi().getAllData();

    setState(() {
      projetsCount = projets.length;
      projetsApprouveCount = projets
          .where((element) => element.approbationDG == "Approved")
          .length;

      // for (var item in projets) {
      //   projetsInvestissementfCount += double.parse(item.recetteAttendus);
      // }

      // for (var item in versements) {
      //   versementCount += double.parse(item.montantVerser);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
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
                          title: 'Dashboard Logistique',
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
                                    number: '$projetsCount',
                                    title: 'Total projets',
                                    icon: Icons.group,
                                    color: Colors.blue.shade700),
                                DashNumberWidget(
                                    number: '$projetsApprouveCount',
                                    title: 'Projets approvés',
                                    icon: Icons.person,
                                    color: Colors.green.shade700),
                                // DashNumberWidget(
                                //     number:
                                //         '${NumberFormat.decimalPattern('fr').format(projetsInvestissementfCount)} \$',
                                //     title: 'Total investissements projets',
                                //     icon: Icons.monetization_on_outlined,
                                //     color: Colors.red.shade700),
                                // DashNumberWidget(
                                //     number:
                                //         '${NumberFormat.decimalPattern('fr').format(versementCount)} \$',
                                //     title: 'Total versements',
                                //     icon: Icons.monetization_on,
                                //     color: Colors.pink.shade700),
                              ],
                            ),
                            // Wrap(
                            //   children: const [
                            //     ChartLineProjet(),
                            //   ],
                            // )
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