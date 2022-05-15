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
import 'package:fokad_admin/src/pages/comptabilite/compt_bb/components/table_balance_compte_dd.dart';
import 'package:fokad_admin/src/pages/comptabilite/compt_bb/components/table_compte_bilan_dd.dart';
import 'package:fokad_admin/src/pages/comptabilite/compt_bb/components/table_compte_resultat_dd.dart';
import 'package:fokad_admin/src/pages/comptabilite/compt_bb/components/table_journal_comptabilite_dd.dart';

class ComptabiliteDD extends StatefulWidget {
  const ComptabiliteDD({Key? key}) : super(key: key);

  @override
  State<ComptabiliteDD> createState() => _ComptabiliteDDState();
}

class _ComptabiliteDDState extends State<ComptabiliteDD> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isOpen1 = false;
  bool isOpen2 = false;
  bool isOpen3 = false;
  bool isOpen4 = false;

  int bilanCount = 0;
  int compteResultatCount = 0;
  int journalCount = 0;
  int balanceCount = 0;

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
    var journal = await JournalApi().getAllData();
    var compteReultats = await CompteResultatApi().getAllData();
    var balances = await BalanceCompteApi().getAllData();

    setState(() {
      bilanCount =
          bilans.where((element) => element.approbationDD == "-").length;
      journalCount = journal
          .where((element) => element.approbationDD == "-").length;
      compteResultatCount = compteReultats
          .where((element) => element.approbationDD == "-").length;
      balanceCount = balances
          .where((element) => element.approbationDD == "-").length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                          title: 'Département Comptabilités',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(
                                  Icons.folder,
                                  color: Colors.white,
                                ),
                                title: Text('Dossier Bilans',
                                    style: headline6!
                                        .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $bilanCount dossiers necessitent votre approbation",
                                    style: bodyMedium!
                                        .copyWith(color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen1 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableCompteBilanDD()],
                              ),
                            ),
                            Card(
                              color: Colors.purple.shade700,
                              child: ExpansionTile(
                                leading: const Icon(
                                  Icons.folder,
                                  color: Colors.white,
                                ),
                                title: Text('Dossier Compte journals',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $journalCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen2 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableJournalComptabiliteDD()],
                              ),
                            ),
                            Card(
                              color: Colors.teal.shade700,
                              child: ExpansionTile(
                                leading: const Icon(
                                  Icons.folder,
                                  color: Colors.white,
                                ),
                                title: Text('Dossier Compte resultats',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $compteResultatCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen4 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableCompteResultatDD()],
                              ),
                            ),
                            Card(
                              color: Colors.orange.shade700,
                              child: ExpansionTile(
                                leading: const Icon(
                                  Icons.folder,
                                  color: Colors.white,
                                ),
                                title: Text('Dossier Compte Balances',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $balanceCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen4 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableBalanceCompteDD()],
                              ),
                            ),
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
