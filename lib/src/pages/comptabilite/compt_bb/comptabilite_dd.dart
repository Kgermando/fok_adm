import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comptabilite/bilan_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/bilan_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comptabilite/compt_bb/components/table_compte_dd.dart';

class ComptabiliteDD extends StatefulWidget {
  const ComptabiliteDD({ Key? key }) : super(key: key);

  @override
  State<ComptabiliteDD> createState() => _ComptabiliteDDState();
}

class _ComptabiliteDDState extends State<ComptabiliteDD> {
   final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isOpenExp1 = false;
  bool isOpenExp2 = false;

  int bilanCount = 0;
  int userAcount = 0;

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      getData();
      timer.cancel();
    }));

    super.initState();
  }

  Future<void> getData() async {
    // RH
    List<BilanModel> agents = await BilanApi().getAllData();

    setState(() {
      bilanCount =
          agents.where((element) => element.approbationDD == "-").length;
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
                          title: 'DD Comptabilité',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              color: const Color.fromARGB(255, 61, 73, 235),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder, color: Colors.white,),
                                title:
                                    Text('Dossier Bilan', style: headline6!.copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous $bilanCount dossiers necessitent votre approbation",
                                    style: bodyMedium!.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenExp1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down, color: Colors.white,),
                                children: const [TableCompteDD()],
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