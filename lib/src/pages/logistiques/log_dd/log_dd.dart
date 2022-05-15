import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/api/logistiques/carburant_api.dart';
import 'package:fokad_admin/src/api/logistiques/entretien_api.dart';
import 'package:fokad_admin/src/api/logistiques/etat_materiel_api.dart';
import 'package:fokad_admin/src/api/logistiques/immobiler_api.dart';
import 'package:fokad_admin/src/api/logistiques/mobilier_api.dart';
import 'package:fokad_admin/src/api/logistiques/trajet_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_carburant_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_entretien_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_etat_materiels_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_immobilier_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_mobilier_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_trajet_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_trajet_anguin_dd.dart';

class LogDD extends StatefulWidget {
  const LogDD({ Key? key }) : super(key: key);

  @override
  State<LogDD> createState() => _LogDDState();
}

class _LogDDState extends State<LogDD> {
   final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isOpenLog1 = false;
  bool isOpenLog2 = false;
  bool isOpenLog3 = false;
  bool isOpenLog4 = false;
  bool isOpenLog5 = false;
  bool isOpenLog6 = false;
  bool isOpenLog7 = false;

  int anguinsapprobationDD = 0;
  int carburantCount = 0;
  int trajetsCount = 0;
  int immobiliersCount = 0;
  int mobiliersCount = 0;
  int entretiensCount = 0;
  int etatmaterielsCount = 0;
  

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      getData();
      timer.cancel();
    }));

    super.initState();
  }

  Future<void> getData() async {
var anguins = await AnguinApi().getAllData();
    var carburants = await CarburantApi().getAllData();
    var trajets = await TrajetApi().getAllData();
    var immobiliers = await ImmobilierApi().getAllData();
    var mobiliers = await MobilierApi().getAllData();
    var entretiens = await EntretienApi().getAllData();
    var etatmateriels = await EtatMaterielApi().getAllData();

    setState(() {
      anguinsapprobationDD =
          anguins.where((element) => element.approbationDD == "-").length;
      carburantCount =
          carburants.where((element) => element.approbationDD == "-").length;
      trajetsCount =
          trajets.where((element) => element.approbationDD == "-").length;
      immobiliersCount =
          immobiliers.where((element) => element.approbationDD == "-").length;
      mobiliersCount =
          mobiliers.where((element) => element.approbationDD == "-").length;
      entretiensCount =
          entretiens.where((element) => element.approbationDD == "-").length;
      etatmaterielsCount =
          etatmateriels.where((element) => element.approbationDD == "-").length;
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
                          title: 'Département Logistique',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder, color: Colors.white),
                                title:
                                    Text('Dossier Anguins', style: headline6!.copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $anguinsapprobationDD dossiers necessitent votre approbation",
                                    style: bodyMedium!.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableTrajetAnguinDD()],
                              ),
                            ),
                            Card(
                              color: Colors.orange.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder, color: Colors.white),
                                title:
                                    Text('Dossier Carburants', style: headline6
                                        .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $carburantCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog2 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableCarburantDD()],
                              ),
                            ),
                            Card(
                              color: Colors.teal.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title:
                                    Text('Dossier Trajets', style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $trajetsCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog3 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableTrajetDD()],
                              ),
                            ),
                            Card(
                              color: Colors.lime.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Immobiliers', style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $immobiliersCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog4 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableImmobilierDD()],
                              ),
                            ),
                            Card(
                              color: Colors.blueGrey,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Mobiliers', style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $mobiliersCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog5 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableMobilierDD()],
                              ),
                            ),
                            Card(
                              color: Colors.brown.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title:
                                    Text('Dossier maintenances', style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $entretiensCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog6 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableEntretienDD()],
                              ),
                            ),
                            Card(
                              color: Colors.grey.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title:
                                    Text('Dossier Etat de materiels', style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $etatmaterielsCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog7 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableEtatMaterielDD()],
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