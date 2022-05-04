import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/api/logistiques/carburant_api.dart';
import 'package:fokad_admin/src/api/logistiques/etat_materiel_api.dart';
import 'package:fokad_admin/src/api/logistiques/immobiler_api.dart';
import 'package:fokad_admin/src/api/logistiques/mobilier_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/carburant_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/components/dash_number_widget.dart';

class DashboardLog extends StatefulWidget {
  const DashboardLog({Key? key}) : super(key: key);

  @override
  State<DashboardLog> createState() => _DashboardLogState();
}

class _DashboardLogState extends State<DashboardLog> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  int anguinsCount = 0;
  int mobilierCount = 0;
  int immobilierCount = 0;
  int etatMaterielActif = 0;
  int etatMaterielInActif = 0;
  int etatMaterielDeclaser = 0;

  double entrerEssence = 0.0;
  double sortieEssence = 0.0;
  double entrerMazoute = 0.0;
  double sortieMazoute = 0.0;
  double entrerHuilleMoteur = 0.0;
  double sortieHuilleMoteur = 0.0;
  double entrerPetrole = 0.0;
  double sortiePetrole = 0.0;

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
    var mobiliers = await MobilierApi().getAllData();
    var immobliers = await ImmobilierApi().getAllData();
    var etatMaterielList = await EtatMaterielApi().getAllData();
    List<CarburantModel?> dataList = await CarburantApi().getAllData();

    setState(() {
      anguinsCount = anguins.length;
      mobilierCount = mobiliers.length;
      immobilierCount = immobliers.length;
      etatMaterielActif = etatMaterielList
          .where((element) => element.approbationDG == "Actif")
          .length;
      etatMaterielInActif = etatMaterielList
          .where((element) => element.approbationDG == "Inactif")
          .length;
      etatMaterielDeclaser = etatMaterielList
          .where((element) => element.approbationDG == "Declaser")
          .length;

      List<CarburantModel?> entreListEssence = dataList
          .where((element) =>
              element!.operationEntreSortie == "Entrer" &&
              element.typeCaburant == "Essence")
          .toList();
      List<CarburantModel?> sortieListEssence = dataList
          .where((element) =>
              element!.operationEntreSortie == "Sortie" &&
              element.typeCaburant == "Essence")
          .toList();
      for (var item in entreListEssence) {
        entrerEssence += double.parse(item!.qtyAchat);
      }
      for (var item in sortieListEssence) {
        sortieEssence += double.parse(item!.qtyAchat);
      }

      List<CarburantModel?> entrerListMazoute = dataList
          .where((element) =>
              element!.operationEntreSortie == "Entrer" &&
              element.typeCaburant == "Mazoutte")
          .toList();
      List<CarburantModel?> sortieListMazoute = dataList
          .where((element) =>
              element!.operationEntreSortie == "Sortie" &&
              element.typeCaburant == "Mazoutte")
          .toList();
      for (var item in entrerListMazoute) {
        entrerMazoute += double.parse(item!.qtyAchat);
      }
      for (var item in sortieListMazoute) {
        sortieMazoute += double.parse(item!.qtyAchat);
      }

      List<CarburantModel?> entrerListHuilleMoteur = dataList
          .where((element) =>
              element!.operationEntreSortie == "Entrer" &&
              element.typeCaburant == "Huille moteur")
          .toList();
      List<CarburantModel?> sortieListHuilleMoteur = dataList
          .where((element) =>
              element!.operationEntreSortie == "Sortie" &&
              element.typeCaburant == "Huille moteur")
          .toList();
      for (var item in entrerListHuilleMoteur) {
        entrerHuilleMoteur += double.parse(item!.qtyAchat);
      }
      for (var item in sortieListHuilleMoteur) {
        sortieHuilleMoteur += double.parse(item!.qtyAchat);
      }

      List<CarburantModel?> entrerListPetrole = dataList
          .where((element) =>
              element!.operationEntreSortie == "Entrer" &&
              element.typeCaburant == "Pétrole")
          .toList();
      List<CarburantModel?> sortieListPetrole = dataList
          .where((element) =>
              element!.operationEntreSortie == "Sortie" &&
              element.typeCaburant == "Pétrole")
          .toList();
      for (var item in entrerListPetrole) {
        entrerPetrole += double.parse(item!.qtyAchat);
      }
      for (var item in sortieListPetrole) {
        sortiePetrole += double.parse(item!.qtyAchat);
      }
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
                                    number: '$anguinsCount',
                                    title: 'Total anguins',
                                    icon: Icons.car_rental,
                                    color: Colors.blue.shade700),
                                DashNumberWidget(
                                    number: '$mobilierCount',
                                    title: 'Total mobilier',
                                    icon: Icons.desktop_mac,
                                    color: Colors.grey.shade700),
                                DashNumberWidget(
                                  number: '$immobilierCount',
                                  title: 'Total immobilier',
                                  icon: Icons.house_sharp,
                                  color: Colors.brown.shade700),
                                DashNumberWidget(
                                  number: '$etatMaterielActif',
                                  title: 'Materiels actifs',
                                  icon: Icons.check,
                                  color: Colors.green.shade700),
                                DashNumberWidget(
                                  number: '$etatMaterielInActif',
                                  title: 'Materiels inactifs',
                                  icon: Icons.indeterminate_check_box_sharp,
                                  color: Colors.pink.shade700),
                                DashNumberWidget(
                                  number: '$etatMaterielDeclaser',
                                  title: 'Materiels déclaser ',
                                  icon: Icons.not_interested,
                                  color: Colors.red.shade700),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                DashNumberWidget(
                                  number: '$entrerEssence',
                                  title: 'Essence Ravitailement',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.green.shade700),
                                DashNumberWidget(
                                  number: '$sortieEssence',
                                  title: 'Essence Consommation',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.pink.shade700),
                                DashNumberWidget(
                                  number: '${entrerEssence - sortieEssence}',
                                  title: 'Essence Disponible',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.orange.shade700),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                DashNumberWidget(
                                  number: '$entrerMazoute',
                                  title: 'Mazoute Ravitailement',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.green.shade700),
                                DashNumberWidget(
                                  number: '$sortieMazoute',
                                  title: 'Mazoute Consommation',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.pink.shade700),
                                DashNumberWidget(
                                  number: '${entrerMazoute - sortieMazoute}',
                                  title: 'Mazoute Disponible ',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.orange.shade700),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                DashNumberWidget(
                                  number: '$entrerPetrole',
                                  title: 'Petrole Ravitailement',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.green.shade700),
                                DashNumberWidget(
                                  number: '$sortiePetrole',
                                  title: 'Petrole Consommation',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.pink.shade700),
                                DashNumberWidget(
                                  number: '${entrerPetrole - sortiePetrole}',
                                  title: 'Petrole Disponible ',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.orange.shade700),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                DashNumberWidget(
                                  number: '$entrerHuilleMoteur',
                                  title: 'Huile Moteur Ravitailement',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.green.shade700),
                                DashNumberWidget(
                                  number: '$sortieHuilleMoteur',
                                  title: 'Huile Moteur Consommation',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.pink.shade700),
                                DashNumberWidget(
                                  number:
                                      '${entrerHuilleMoteur - sortieHuilleMoteur}',
                                  title: 'Huile Moteur Disponible ',
                                  icon: Icons.ev_station_sharp,
                                  color: Colors.orange.shade700
                                ),
                              ],
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
