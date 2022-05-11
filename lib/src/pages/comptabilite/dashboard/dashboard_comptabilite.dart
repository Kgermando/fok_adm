import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comptabilite/balance_compte_api.dart';
import 'package:fokad_admin/src/api/comptabilite/bilan_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_resultat_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/components/dash_number_widget.dart';

class DashboardComptabilite extends StatefulWidget {
  const DashboardComptabilite({Key? key}) : super(key: key);

  @override
  State<DashboardComptabilite> createState() => _DashboardComptabiliteState();
}

class _DashboardComptabiliteState extends State<DashboardComptabilite> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  int bilanCount = 0;
  int journalCount = 0;
  int balanceCount = 0;
  int compteResultatCount = 0;

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      getData();
      timer.cancel();
    }));

    super.initState();
  }

  Future<void> getData() async {
    var bilans = await BilanApi().getAllData();
    var journals = await JournalApi().getAllData();
    var balances = await BalanceCompteApi().getAllData();
    var compteResults = await CompteResultatApi().getAllData();

    setState(() {
      bilanCount = bilans.length;
      journalCount = journals.length;
      balanceCount = balances.length;
      compteResultatCount = compteResults.length;
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
                          title: 'Comptabilité',
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
                                    number: '$bilanCount',
                                    title: 'Opérations bilan',
                                    icon: Icons.blur_linear_rounded,
                                    color: Colors.green.shade700),
                                DashNumberWidget(
                                    number: '$journalCount',
                                    title: 'Opérations journal',
                                    icon: Icons.backup_table,
                                    color: Colors.blue.shade700),
                                DashNumberWidget(
                                    number: '$compteResultatCount',
                                    title: 'Opérations compte resultat',
                                    icon: Icons.view_compact_rounded,
                                    color: Colors.teal.shade700),
                                DashNumberWidget(
                                    number: '$balanceCount',
                                    title: 'Opérations balance',
                                    icon: Icons.balcony_outlined,
                                    color: Colors.orange.shade700),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // Responsive.isDesktop(context)
                            //     ? Row(
                            //         children: const [
                            //           Expanded(child: CourbeVenteGainMounth()),
                            //           Expanded(child: CourbeVenteGainYear()),
                            //         ],
                            //       )
                            //     : Column(
                            //         children: const [
                            //           CourbeVenteGainMounth(),
                            //           SizedBox(
                            //             height: 20.0,
                            //           ),
                            //           CourbeVenteGainYear(),
                            //         ],
                            //       ),
                            // const SizedBox(
                            //   height: 20.0,
                            // ),
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
