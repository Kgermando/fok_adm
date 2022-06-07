import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/exploitations/projets_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/exploitations/projet_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/dash_number_budget_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DashboardBudget extends StatefulWidget {
  const DashboardBudget({Key? key}) : super(key: key);

  @override
  State<DashboardBudget> createState() => _DashboardBudgetState();
}

class _DashboardBudgetState extends State<DashboardBudget> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  double coutTotal = 0.0;
  double sommeEnCours = 0.0; // cest la somme des 4 departements
  double sommeRestantes =
      0.0; // la somme restante apres la soustration entre coutTotal - sommeEnCours
  double poursentExecution = 1;

  // Total par departements
  double totalCampaign = 0.0;
  double totalDevis = 0.0;
  double totalProjet = 0.0;
  double totalSalaire = 0.0;

  double caisseetatBesion = 0.0;
  double banqueetatBesion = 0.0;
  double finPropreetatBesion = 0.0;
  double finExterieuretatBesion = 0.0;

  double caissesalaire = 0.0;
  double banquesalaire = 0.0;
  double finPropresalaire = 0.0;
  double finExterieursalaire = 0.0;

  double caisseCampaign = 0.0;
  double banqueCampaign = 0.0;
  double finPropreCampaign = 0.0;
  double finExterieurCampaign = 0.0;

  double caisseProjet = 0.0;
  double banqueProjet = 0.0;
  double finPropreProjet = 0.0;
  double finExterieurProjet = 0.0;

  @override
  void initState() {
    getData();

    super.initState();
  }

  List<LigneBudgetaireModel> ligneBudgetaireList = [];
  List<CampaignModel> dataCampaignList = [];
  List<DevisModel> dataDevisList = [];
  List<ProjetModel> dataProjetList = [];
  List<PaiementSalaireModel> dataSalaireList = [];
  List<DepartementBudgetModel> departementsList = [];

  Future<void> getData() async {
    var departements = await DepeartementBudgetApi().getAllData();
    var budgets = await LIgneBudgetaireApi().getAllData();
    var campaigns = await CampaignApi().getAllData();
    var devis = await DevisAPi().getAllData();
    var projets = await ProjetsApi().getAllData();
    var salaires = await PaiementSalaireApi().getAllData();
    var approbations = await ApprobationApi().getAllData();

    if (mounted) {
      setState(() {
        departementsList = departements
            .where((element) => DateTime.now().isBefore(element.periodeFin))
            .toList();

        ligneBudgetaireList = budgets
            .where((element) =>
                DateTime.now().isBefore(DateTime.parse(element.periodeBudget)))
            .toList();

        for (var item in ligneBudgetaireList) {
          for (var i in approbations) {
            dataCampaignList = campaigns
                .where((element) =>
                    element.created.microsecondsSinceEpoch == i.reference.microsecondsSinceEpoch &&
                    i.fontctionOccupee == 'Directeur générale' &&
                    element.created
                        .isBefore(DateTime.parse(item.periodeBudget)))
                .toList();
            dataDevisList = devis
                .where((element) =>
                    element.created.microsecondsSinceEpoch == i.reference.microsecondsSinceEpoch &&
                    i.fontctionOccupee == 'Directeur générale' &&
                    element.created
                        .isBefore(DateTime.parse(item.periodeBudget)))
                .toList();
            dataProjetList = projets
                .where((element) =>
                    element.created.microsecondsSinceEpoch == i.reference.microsecondsSinceEpoch &&
                    i.fontctionOccupee == 'Directeur générale' &&
                    element.created
                        .isBefore(DateTime.parse(item.periodeBudget)))
                .toList();
            dataSalaireList = salaires
                .where((element) =>
                    element.createdAt.microsecondsSinceEpoch == i.reference.microsecondsSinceEpoch &&
                    i.fontctionOccupee == 'Directeur générale' &&
                    element.createdAt
                        .isBefore(DateTime.parse(item.periodeBudget)))
                .toList();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    for (var item in ligneBudgetaireList) {
      coutTotal += double.parse(item.coutTotal);
    }
    for (var item in dataCampaignList) {
      totalCampaign += double.parse(item.resources);
    }
    // for (var item in dataDevisList) {
    //   totalDevis += double.parse(item.resources);
    // }
    for (var item in dataProjetList) {
      totalProjet += double.parse(item.resources);
    }
    for (var item in dataSalaireList) {
      totalSalaire += double.parse(item.resources);
    }
    sommeEnCours = totalCampaign + totalDevis + totalProjet + totalSalaire;
    sommeRestantes = coutTotal - sommeEnCours;
    poursentExecution = sommeRestantes * 100 / coutTotal;
    

    for (var item in dataCampaignList.where((e) => e.resources == "caisse")) {
      caisseCampaign += double.parse(item.resources);
    }
    // for (var item in dataDevisList.where((e) => e.resources == "caisse")) {
    //   caisseetatBesion += double.parse(item.resources);
    // }
    for (var item in dataProjetList.where((e) => e.resources == "caisse")) {
      caisseProjet += double.parse(item.resources);
    }
    for (var item in dataSalaireList.where((e) => e.resources == "caisse")) {
      caissesalaire += double.parse(item.resources);
    }

    for (var item in dataCampaignList.where((e) => e.resources == "banque")) {
      banqueCampaign += double.parse(item.resources);
    }
    // for (var item in dataDevisList.where((e) => e.resources == "banque")) {
    //   banqueetatBesion += double.parse(item.resources);
    // }
    for (var item in dataProjetList.where((e) => e.resources == "banque")) {
      banqueProjet += double.parse(item.resources);
    }
    for (var item in dataSalaireList.where((e) => e.resources == "banque")) {
      banquesalaire += double.parse(item.resources);
    }

    for (var item
        in dataCampaignList.where((e) => e.resources == "finPropre")) {
      finPropreCampaign += double.parse(item.resources);
    }
    // for (var item in dataDevisList.where((e) => e.resources == "finPropre")) {
    //   finPropreetatBesion += double.parse(item.resources);
    // }
    for (var item in dataProjetList.where((e) => e.resources == "finPropre")) {
      finPropreProjet += double.parse(item.resources);
    }
    for (var item in dataSalaireList.where((e) => e.resources == "finPropre")) {
      finPropresalaire += double.parse(item.resources);
    }

    for (var item
        in dataCampaignList.where((e) => e.resources == "finExterieur")) {
      finExterieurCampaign += double.parse(item.resources);
    }
    // for (var item
    //     in dataDevisList.where((e) => e.resources == "finExterieur")) {
    //   finExterieuretatBesion += double.parse(item.resources);
    // }
    for (var item
        in dataProjetList.where((e) => e.resources == "finExterieur")) {
      finExterieurProjet += double.parse(item.resources);
    }
    for (var item
        in dataSalaireList.where((e) => e.resources == "finExterieur")) {
      finExterieursalaire += double.parse(item.resources);
    }

    // print("poursentExecution $poursentExecution");

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
                          title: 'Dashboard Budgets',
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
                                DashNumberBudgetWidget(
                                    number:
                                        '${NumberFormat.decimalPattern('fr').format(coutTotal)} \$',
                                    title: "Coût Total prévisionnel",
                                    icon: Icons.monetization_on,
                                    color: Colors.blue.shade700),
                                DashNumberBudgetWidget(
                                    number:
                                        '${NumberFormat.decimalPattern('fr').format(sommeEnCours)} \$',
                                    title: "Sommes en cours d'execution",
                                    icon: Icons.monetization_on_outlined,
                                    color: Colors.pink.shade700),
                                DashNumberBudgetWidget(
                                    number:
                                        '${NumberFormat.decimalPattern('fr').format(sommeRestantes)} \$',
                                    title: "Sommes restantes",
                                    icon: Icons.monetization_on_outlined,
                                    color: Colors.red.shade700),
                                DashNumberBudgetWidget(
                                    number: '$poursentExecution %',
                                    title: "Pourcentage d'execution",
                                    icon: Icons.monetization_on_outlined,
                                    color: Colors.green.shade700),
                              ],
                            ),
                            const SizedBox(height: p30),
                            const TitleWidget(title: "Tableau de dépenses"),
                            const SizedBox(height: p10),
                            Table(
                              children: <TableRow>[
                                tableDepartement(),
                                tableCellRH(),
                                tableCellExploitation(),
                                tableCellEtatBesoin(),
                                tableCellMarketing()
                              ],
                            )
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

  TableRow tableDepartement() {
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
          height: 50,
          color: Colors.amber.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "DEPENSES",
            maxLines: 1,
            style: headline6!.copyWith(color: Colors.white),
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
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: AutoSizeText(
            "Coût Total".toUpperCase(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6.copyWith(fontWeight: FontWeight.bold),
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
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: AutoSizeText(
            "Caisse".toUpperCase(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6.copyWith(fontWeight: FontWeight.bold),
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
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: AutoSizeText(
            "Banque".toUpperCase(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6.copyWith(fontWeight: FontWeight.bold),
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
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: AutoSizeText(
            "Fonds Propre".toUpperCase(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6.copyWith(fontWeight: FontWeight.bold),
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
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: AutoSizeText(
            "Reste à trouver".toUpperCase(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellRH() {
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
            "RH",
            maxLines: 1,
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
            "${NumberFormat.decimalPattern('fr').format(totalSalaire)} \$",
            maxLines: 1,
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
            "${NumberFormat.decimalPattern('fr').format(caissesalaire)} \$",
            maxLines: 1,
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
            "${NumberFormat.decimalPattern('fr').format(banquesalaire)} \$",
            maxLines: 1,
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
            "${NumberFormat.decimalPattern('fr').format(finPropresalaire)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.teal,
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
            "${NumberFormat.decimalPattern('fr').format(finExterieursalaire)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellExploitation() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: Colors.grey.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "Exploitations",
            maxLines: 1,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(totalProjet)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(caisseProjet)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(banqueProjet)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(finPropreProjet)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(finExterieurProjet)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellEtatBesoin() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.purple.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: Colors.purple.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "Etat de besoin",
            maxLines: 1,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.purple.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.purple.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(totalDevis)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.purple.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.purple.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(caisseetatBesion)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.purple.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.purple.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(banqueetatBesion)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.purple.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.purple.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(finPropreetatBesion)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.purple.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.purple.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(finExterieuretatBesion)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellMarketing() {
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
            "Marketing",
            maxLines: 1,
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
            "${NumberFormat.decimalPattern('fr').format(totalCampaign)} \$",
            maxLines: 1,
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
            "${NumberFormat.decimalPattern('fr').format(caisseCampaign)} \$",
            maxLines: 1,
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
            "${NumberFormat.decimalPattern('fr').format(banqueCampaign)} \$",
            maxLines: 1,
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
            "${NumberFormat.decimalPattern('fr').format(finPropreCampaign)} \$",
            maxLines: 1,
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
            "${NumberFormat.decimalPattern('fr').format(finExterieurCampaign)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }
}
