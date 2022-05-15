import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/finances/banque_api.dart';
import 'package:fokad_admin/src/api/finances/caisse_api.dart';
import 'package:fokad_admin/src/api/finances/creance_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/api/finances/fin_exterieur_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/finances/banque_model.dart';
import 'package:fokad_admin/src/models/finances/caisse_model.dart';
import 'package:fokad_admin/src/models/finances/creances_model.dart';
import 'package:fokad_admin/src/models/finances/dette_model.dart';
import 'package:fokad_admin/src/models/finances/fin_exterieur_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/components/banque/courbe_banque_mounth.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/components/banque/courbe_banque_year.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/components/caisse/courbe_caisse_mounth.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/components/caisse/courbe_caisse_year.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/components/depenses/devie_pie_dep_mounth.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/components/depenses/devie_pie_dep_year.dart';
import 'package:fokad_admin/src/widgets/dashboard_card_widget.dart';

class DashboardFinance extends StatefulWidget {
  const DashboardFinance({Key? key}) : super(key: key);

  @override
  State<DashboardFinance> createState() => _DashboardFinanceState();
}

class _DashboardFinanceState extends State<DashboardFinance> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final scrollController = ScrollController();

  // Banque
  double recetteBanque = 0.0;
  double depensesBanque = 0.0;
  double soldeBanque = 0.0;

  // Caisse
  double recetteCaisse = 0.0;
  double depensesCaisse = 0.0;
  double soldeCaisse = 0.0;

  // Creance
  double payeCreance = 0.0;
  double nonPayesCreance = 0.0;
  double soldeCreance = 0.0;

  // Dette
  double payeDette = 0.0;
  double nonPayesDette = 0.0;
  double soldeDette = 0.0;

  // FinanceExterieur
  double cumulFinanceExterieur = 0.0;

  // Devis
  double depenses = 0.0;

  // Disponible
  double disponible = 0.0;

  @override
  void initState() {
   getData();
    super.initState();
  }


  Future<void> getData() async {
    List<BanqueModel?> dataBanqueList = await BanqueApi().getAllData();
    List<CaisseModel?> dataCaisseList = await CaisseApi().getAllData();
    List<CreanceModel?> dataCreanceList = await CreanceApi().getAllData();
    List<DetteModel?> dataDetteList = await DetteApi().getAllData();
    var dataFinanceExterieurList = await FinExterieurApi().getAllData();
    var dataDevisList = await DevisAPi().getAllData();

    setState(() {
      // Banque
      List<BanqueModel?> recetteBanqueList = dataBanqueList
          .where((element) => element!.typeOperation == "Depot")
          .toList();
      List<BanqueModel?> depensesBanqueList = dataBanqueList
          .where((element) => element!.typeOperation == "Retrait")
          .toList();
      for (var item in recetteBanqueList) {
        recetteBanque += double.parse(item!.montant);
      }
      for (var item in depensesBanqueList) {
        depensesBanque += double.parse(item!.montant);
      }
      // Caisse
      List<CaisseModel?> recetteCaisseList = dataCaisseList
          .where((element) => element!.typeOperation == "Encaissement")
          .toList();
      List<CaisseModel?> depensesCaisseList = dataCaisseList
          .where((element) => element!.typeOperation == "Decaissement")
          .toList();
      for (var item in recetteCaisseList) {
        recetteCaisse += double.parse(item!.montant);
      }
      for (var item in depensesCaisseList) {
        depensesCaisse += double.parse(item!.montant);
      }

      // Creance
      List<CreanceModel?> payeCreanceList = dataCreanceList
          .where((element) => element!.statutPaie == true)
          .toList();
      List<CreanceModel?> nonPayeCreanceList = dataCreanceList
          .where((element) => element!.statutPaie == false)
          .toList();
      for (var item in payeCreanceList) {
        payeCreance += double.parse(item!.montant);
      }
      for (var item in nonPayeCreanceList) {
        nonPayesCreance += double.parse(item!.montant);
      }

      // Dette
      List<DetteModel?> payeDetteList = dataDetteList
          .where((element) => element!.statutPaie == true)
          .toList();
      List<DetteModel?> nonPayeDetteList = dataDetteList
          .where((element) => element!.statutPaie == false)
          .toList();
      for (var item in payeDetteList) {
        payeDette += double.parse(item!.montant);
      }
      for (var item in nonPayeDetteList) {
        nonPayesDette += double.parse(item!.montant);
      }

      // FinanceExterieur
      List<FinanceExterieurModel?> recetteList = dataFinanceExterieurList;
      for (var item in recetteList) {
        cumulFinanceExterieur += double.parse(item!.montant);
      }

      List<DevisModel?> devisList = dataDevisList;

      for (var item in devisList) {
        for (var i in item!.list) {
          depenses += double.parse(i['frais']);
        }
      }

      soldeBanque = recetteBanque - depensesBanque;
      soldeCaisse = recetteCaisse - depensesCaisse;
      soldeCreance = payeCreance - nonPayesCreance;
      soldeDette = payeDette - nonPayesDette;

      disponible = soldeBanque + soldeCaisse + cumulFinanceExterieur;
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
                          title: 'Finance Dashboard',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: ListView(
                        controller: scrollController,
                        children: [
                          const SizedBox(height: p10),
                          Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            spacing: 12.0,
                            runSpacing: 12.0,
                            direction: Axis.horizontal,
                            children: [
                              DashboardCardWidget(
                                title: 'CAISSE',
                                icon: Icons.view_stream_outlined,
                                montant: '$soldeCaisse',
                                color: Colors.yellow.shade700,
                                colorText: Colors.black,
                              ),
                              DashboardCardWidget(
                                title: 'BANQUE',
                                icon: Icons.business,
                                montant: '$soldeBanque',
                                color: Colors.green.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                title: 'DETTES',
                                icon: Icons.money_off,
                                montant: '$soldeDette',
                                color: Colors.red.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                title: 'CREANCES',
                                icon: Icons.money_off_csred,
                                montant: '$soldeCreance',
                                color: Colors.purple.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                title: 'FIN. EXTERNE',
                                icon: Icons.money_outlined,
                                montant: '$cumulFinanceExterieur',
                                color: Colors.teal.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                title: 'DEPENSES',
                                icon: Icons.monetization_on,
                                montant: '$depenses',
                                color: Colors.orange.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                title: 'DIPONIBLES',
                                icon: Icons.attach_money,
                                montant: '$disponible',
                                color: Colors.blue.shade700,
                                colorText: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Responsive.isDesktop(context)
                              ? Row(
                                  children: const [
                                    Expanded(
                                        child:  CourbeCaisseMounth()),
                                    Expanded(
                                        child: CourbeCaisseYear()),
                                  ],
                                )
                              : Column(
                                  children: const [
                                    CourbeCaisseMounth(),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    CourbeCaisseYear(),
                                  ],
                                ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Responsive.isDesktop(context)
                              ? Row(
                                  children: const [
                                    Expanded(child: CourbeBanqueMounth()),
                                    Expanded(child: CourbeBanqueYear()),
                                  ],
                                )
                              : Column(
                                  children: const [
                                    CourbeBanqueMounth(),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    CourbeBanqueYear(),
                                  ],
                                ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Responsive.isDesktop(context)
                              ? Row(
                                  children: const [
                                    Expanded(
                                        child: DeviePieDepMounth()),
                                    Expanded(
                                        child: DeviePieDepYear()),
                                  ],
                                )
                              : Column(
                                  children: const [
                                    DeviePieDepMounth(),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    DeviePieDepYear(),
                                  ],
                                ),
                         
                        ],
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
