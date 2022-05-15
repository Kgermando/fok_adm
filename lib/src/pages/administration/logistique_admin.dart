import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/api/logistiques/carburant_api.dart';
import 'package:fokad_admin/src/api/logistiques/immobiler_api.dart';
import 'package:fokad_admin/src/api/logistiques/mobilier_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/logistiques/table_carburant_admin.dart';
import 'package:fokad_admin/src/pages/administration/components/logistiques/table_immobilier_admin.dart';
import 'package:fokad_admin/src/pages/administration/components/logistiques/table_mobilier_admin.dart';
import 'package:fokad_admin/src/pages/administration/components/logistiques/table_trajet_anguin_admin.dart';


class LogistiquesAdmin extends StatefulWidget {
  const LogistiquesAdmin({ Key? key }) : super(key: key);

  @override
  State<LogistiquesAdmin> createState() => _LogistiquesAdminState();
}

class _LogistiquesAdminState extends State<LogistiquesAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenLog1 = false;
  bool isOpenLog2 = false;
  bool isOpenLog3 = false;
  bool isOpenLog4 = false;

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
    var immobiliers = await ImmobilierApi().getAllData();
    var mobiliers = await MobilierApi().getAllData();

    setState(() {
      anguinsapprobationDD =
          anguins.where((element) => element.approbationDG == "-" && 
          element.approbationDD == "Approved").length;
      carburantCount =
          carburants.where((element) => element.approbationDG == "-" && 
          element.approbationDD == "Approved").length;
      immobiliersCount =
          immobiliers.where((element) => element.approbationDG == "-" && 
          element.approbationDD == "Approved").length;
      mobiliersCount =
          mobiliers.where((element) => element.approbationDG == "-" && 
          element.approbationDD == "Approved").length;
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
                      CustomAppbar(title: 'Logistique',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Anguins',
                                    style: headline6!
                                        .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $anguinsapprobationDD dossiers necessitent votre approbation",
                                    style: bodyMedium!
                                        .copyWith(color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableTrajetAnguinDG()],
                              ),
                            ),
                            Card(
                              color: Colors.orange.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Carburants',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
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
                                children: const [TableCarburantDG()],
                              ),
                            ),
                            Card(
                              color: Colors.lime.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Immobiliers',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $immobiliersCount dossiers necessitent votre approbation",
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
                                children: const [TableImmobilierDG()],
                              ),
                            ),
                            Card(
                              color: Colors.blueGrey,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Mobiliers',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $mobiliersCount dossiers necessitent votre approbation",
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
                                children: const [TableMobilierDG()],
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
