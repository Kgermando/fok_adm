import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:fokad_admin/src/pages/logistiques/dashboard/components/enguin_pie.dart';
import 'package:fokad_admin/src/pages/logistiques/dashboard/components/etat_materiel_pie.dart';
import 'package:fokad_admin/src/widgets/dash_number_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

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
    getData();

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

                            const SizedBox(height: p30),
                            const TitleWidget(title: "Tableau carburants"),
                            const SizedBox(height: p10),
                            Table(
                              children: <TableRow>[
                                tableCarburant(),
                                tableCellEssence(),
                                tableCellMazoute(),
                                tableCellPetrole(),
                                tableCellHuileMoteur()
                              ],
                            ),

                            const SizedBox(
                              height: 20.0,
                            ),
                            Responsive.isDesktop(context)
                                ? Row(
                                    children: const [
                                      Expanded(child: EtatMaterielPie()),
                                      Expanded(child: EnguinPie()),
                                    ],
                                  ) 
                                : Column(
                                    children: const [
                                      EtatMaterielPie(),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      EnguinPie(),
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


  TableRow tableCarburant() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.amber.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: Responsive.isMobile(context) ? 100 : 50,
          color: Colors.amber.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Responsive.isMobile(context)
                  ? Container()
                  : const Icon(Icons.ev_station_sharp),
              Responsive.isMobile(context)
                  ? Container()
                  : const SizedBox(width: p10),
              Expanded(
                child: AutoSizeText(
                  "CARBURANTS",
                  maxLines: 2,
                  style: headline6!.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.amber.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: Responsive.isMobile(context) ? 100 : 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Responsive.isMobile(context)
                  ? Container()
                  : const Icon(Icons.ev_station_sharp),
              Responsive.isMobile(context)
                  ? Container()
                  : const SizedBox(width: p10),
              Expanded(
                child: AutoSizeText(
                  "Ravitailements".toUpperCase(),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: headline6.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.amber.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: Responsive.isMobile(context) ? 100 : 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Responsive.isMobile(context)
                  ? Container()
                  : const Icon(Icons.ev_station_sharp),
              Responsive.isMobile(context)
                  ? Container()
                  : const SizedBox(width: p10),
              Expanded(
                child: AutoSizeText(
                  "Consommations".toUpperCase(),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: headline6.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.amber.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: Responsive.isMobile(context) ? 100 : 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Responsive.isMobile(context)
                  ? Container()
                  : const Icon(Icons.ev_station_sharp),
              Responsive.isMobile(context)
                  ? Container()
                  : const SizedBox(width: p10),
              Expanded(
                child: AutoSizeText(
                  "Disponibles".toUpperCase(),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: headline6.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
     
    ]);
  }

  TableRow tableCellEssence() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.orange.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: Colors.orange.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "Essence",
            maxLines: 2,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.orange.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.orange.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(entrerEssence)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.orange.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.orange.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(sortieEssence)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.orange.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.orange.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(entrerEssence - sortieEssence)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellMazoute() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.teal.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: Colors.teal.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "Mazoute",
            maxLines: 2,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.teal.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.teal.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(entrerMazoute)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.teal.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.teal.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(sortieMazoute)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.teal.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.teal.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(entrerMazoute - sortieMazoute)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellPetrole() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.lime.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: Colors.lime.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "Petrole",
            maxLines: 2,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.lime.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.lime.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(entrerPetrole)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.lime.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.lime.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(sortiePetrole)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.lime.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.lime.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(entrerPetrole - sortiePetrole)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellHuileMoteur() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.indigo.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: Colors.indigo.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "Huile Moteur",
            maxLines: 2,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.indigo.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.indigo.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(entrerHuilleMoteur)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.indigo.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.indigo.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(sortieHuilleMoteur)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.indigo.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.indigo.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(entrerHuilleMoteur - sortieHuilleMoteur)} L",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }

  
 


  
}
