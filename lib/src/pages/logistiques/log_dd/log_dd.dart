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
import 'package:fokad_admin/src/models/logistiques/anguin_model.dart';
import 'package:fokad_admin/src/models/logistiques/carburant_model.dart';
import 'package:fokad_admin/src/models/logistiques/entretien_model.dart';
import 'package:fokad_admin/src/models/logistiques/etat_materiel_model.dart';
import 'package:fokad_admin/src/models/logistiques/immobilier_model.dart';
import 'package:fokad_admin/src/models/logistiques/mobilier_model.dart';
import 'package:fokad_admin/src/models/logistiques/trajet_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_carburant.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_entretien.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_etat_materiels.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_immobilier.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_mobilier.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_trajet.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_trajet_anguin.dart';

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
    List<AnguinModel> anguins = await AnguinApi().getAllData();
    List<CarburantModel> carburants = await CarburantApi().getAllData();
    List<TrajetModel> trajets = await TrajetApi().getAllData();
    List<ImmobilierModel> immobiliers = await ImmobilierApi().getAllData();
    List<MobilierModel> mobiliers = await MobilierApi().getAllData();
    List<EntretienModel> entretiens = await EntretienApi().getAllData();
    List<EtatMaterielModel> etatmateriels = await EtatMaterielApi().getAllData();

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
                              color: const Color.fromARGB(255, 26, 132, 158),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title:
                                    Text('Dossier Anguins', style: headline6),
                                subtitle: Text(
                                    "Vous $anguinsapprobationDD dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: const [TableTrajetAnguinDD()],
                              ),
                            ),
                            Card(
                              color: const Color.fromARGB(255, 221, 27, 173),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title:
                                    Text('Dossier Carburant', style: headline6),
                                subtitle: Text(
                                    "Vous $carburantCount dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog2 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: const [TableCarburantDD()],
                              ),
                            ),
                            Card(
                              color: const Color.fromARGB(255, 61, 180, 235),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title:
                                    Text('Dossier Trajet', style: headline6),
                                subtitle: Text(
                                    "Vous $trajetsCount dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog3 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: const [TableTrajetDD()],
                              ),
                            ),
                            Card(
                              color: const Color.fromARGB(255, 25, 194, 95),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title: Text('Dossier Immobilier', style: headline6),
                                subtitle: Text(
                                    "Vous $immobiliersCount dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog4 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: const [TableImmobilierDD()],
                              ),
                            ),
                            Card(
                              color: const Color.fromARGB(255, 53, 212, 218),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title: Text('Dossier Mobilier', style: headline6),
                                subtitle: Text(
                                    "Vous $mobiliersCount dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog5 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: const [TableMobilierDD()],
                              ),
                            ),
                            Card(
                              color: const Color.fromARGB(255, 233, 156, 40),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title:
                                    Text('Dossier Entretien', style: headline6),
                                subtitle: Text(
                                    "Vous $entretiensCount dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog6 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: const [TableEntretienDD()],
                              ),
                            ),
                            Card(
                              color: Colors.grey.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title:
                                    Text('Dossier Etat de materiels', style: headline6),
                                subtitle: Text(
                                    "Vous $etatmaterielsCount dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog6 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
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