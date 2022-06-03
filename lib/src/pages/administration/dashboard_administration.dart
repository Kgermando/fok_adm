import 'dart:async';

import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/comptabilite/bilan_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/exploitations/projets_api.dart';
import 'package:fokad_admin/src/api/finances/banque_api.dart';
import 'package:fokad_admin/src/api/finances/caisse_api.dart';
import 'package:fokad_admin/src/api/finances/creance_api.dart';
import 'package:fokad_admin/src/api/finances/creance_dette_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/api/finances/fin_exterieur_api.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/exploitations/projet_model.dart';
import 'package:fokad_admin/src/models/finances/banque_model.dart';
import 'package:fokad_admin/src/models/finances/caisse_model.dart';
import 'package:fokad_admin/src/models/finances/creances_model.dart';
import 'package:fokad_admin/src/models/finances/dette_model.dart';
import 'package:fokad_admin/src/models/finances/fin_exterieur_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/dashboard/components/courbe_vente_gain_mounth.dart';
import 'package:fokad_admin/src/pages/comm_marketing/dashboard/components/courbe_vente_gain_year.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/components/dash_pie_wdget.dart';
import 'package:fokad_admin/src/widgets/dash_number_widget.dart';
import 'package:intl/intl.dart';

class DashboardAdministration extends StatefulWidget {
  const DashboardAdministration({Key? key}) : super(key: key);

  @override
  State<DashboardAdministration> createState() =>
      _DashboardAdministrationState();
}

class _DashboardAdministrationState extends State<DashboardAdministration> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // RH
  int agentsCount = 0;
  int agentActifCount = 0;

  // Budgets
  double coutTotal = 0.0;
  double sommeEnCours = 0.0;
  double sommeRestantes = 0.0;
  double poursentExecution = 0.0;
  double totalCampaign = 0.0;
  double totalDevis = 0.0;
  double totalProjet = 0.0;
  double totalSalaire = 0.0;

  // Comptabilite
  int bilanCount = 0;
  int journalCount = 0;

  // Finance
  double depenses = 0.0;
  double disponible = 0.0;
  double recetteBanque = 0.0;
  double depensesBanque = 0.0;
  double soldeBanque = 0.0;
  double recetteCaisse = 0.0;
  double depensesCaisse = 0.0;
  double soldeCaisse = 0.0;
  double nonPayesCreance = 0.0;
  double creancePayement = 0.0;
  double soldeCreance = 0.0;
  double nonPayesDette = 0.0;
  double detteRemboursement = 0.0;
  double soldeDette = 0.0;
  double cumulFinanceExterieur = 0.0;

  // Exploitations
  int projetsApprouveCount = 0;

  // Campaigns
  int campaignCount = 0;

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
    // RH
    var agents = await AgentsApi().getAllData();

    // Budgets
    var departements = await DepeartementBudgetApi().getAllData();
    var budgets = await LIgneBudgetaireApi().getAllData();
    var campaigns = await CampaignApi().getAllData();
    var devis = await DevisAPi().getAllData();
    var projets = await ProjetsApi().getAllData();
    var salaires = await PaiementSalaireApi().getAllData();

    // Comptabilite
    var bilans = await BilanApi().getAllData();
    var journals = await JournalApi().getAllData();

    // Finances
    var dataBanqueList = await BanqueApi().getAllData();
    var dataCaisseList = await CaisseApi().getAllData();
    var dataCreanceList = await CreanceApi().getAllData();
    var dataDetteList = await DetteApi().getAllData();
    var creanceDettes = await CreanceDetteApi().getAllData();
    var dataFinanceExterieurList = await FinExterieurApi().getAllData();
    var dataDevisList = await DevisAPi().getAllData();
    var approbations = await ApprobationApi().getAllData();

    if (mounted) {
      setState(() {
        agentsCount = agents.length;
        agentActifCount =
            agents.where((element) => element.statutAgent == true).length;

        // Exploitations
        for (var item in approbations) {
          projetsApprouveCount = projets
              .where((element) =>
                  element.created.microsecondsSinceEpoch == item.reference &&
                  item.fontctionOccupee == 'Directeur générale')
              .length;
        }

        // Comm & Marketing
        for (var item in approbations) {
          campaignCount = campaigns
              .where((element) =>
                  element.created.microsecondsSinceEpoch == item.reference &&
                  item.fontctionOccupee == 'Directeur générale')
              .length;
        }

        // Budgets
        for (var item in approbations) {
          departementsList = departements
              .where((element) =>
                  element.created.microsecondsSinceEpoch == item.reference &&
                  item.fontctionOccupee == 'Directeur générale' &&
                  DateTime.now().isBefore(element.periodeFin))
              .toList();
        }

        ligneBudgetaireList = budgets
            .where((element) =>
                DateTime.now().isBefore(DateTime.parse(element.periodeBudget)))
            .toList();

        for (var item in ligneBudgetaireList) {
          for (var i in approbations) {
            dataCampaignList = campaigns
                .where((element) =>
                    element.id == i.reference &&
                    i.fontctionOccupee == 'Directeur générale' &&
                    element.created
                        .isBefore(DateTime.parse(item.periodeBudget)))
                .toList();
            dataDevisList = devis
                .where((element) =>
                    element.id == i.reference &&
                    i.fontctionOccupee == 'Directeur générale' &&
                    element.created
                        .isBefore(DateTime.parse(item.periodeBudget)))
                .toList();
            dataProjetList = projets
                .where((element) =>
                    element.id == i.reference &&
                    i.fontctionOccupee == 'Directeur générale' &&
                    element.created
                        .isBefore(DateTime.parse(item.periodeBudget)))
                .toList();
            dataSalaireList = salaires
                .where((element) =>
                    element.id == i.reference &&
                    i.fontctionOccupee == 'Directeur générale' &&
                    element.createdAt
                        .isBefore(DateTime.parse(item.periodeBudget)))
                .toList();
          }
        }

        // Comptabilite
        bilanCount = bilans.length;
        journalCount = journals.length;

        // FINANCE
        // Banque
        List<BanqueModel?> recetteBanqueList = dataBanqueList
            .where((element) => element.typeOperation == "Depot")
            .toList();
        List<BanqueModel?> depensesBanqueList = dataBanqueList
            .where((element) => element.typeOperation == "Retrait")
            .toList();
        for (var item in recetteBanqueList) {
          recetteBanque += double.parse(item!.montant);
        }
        for (var item in depensesBanqueList) {
          depensesBanque += double.parse(item!.montant);
        }
        // Caisse
        List<CaisseModel?> recetteCaisseList = dataCaisseList
            .where((element) => element.typeOperation == "Encaissement")
            .toList();
        List<CaisseModel?> depensesCaisseList = dataCaisseList
            .where((element) => element.typeOperation == "Decaissement")
            .toList();
        for (var item in recetteCaisseList) {
          recetteCaisse += double.parse(item!.montant);
        }
        for (var item in depensesCaisseList) {
          depensesCaisse += double.parse(item!.montant);
        }

        // Creance
        var creancePayementList = creanceDettes
            .where((element) => element.creanceDette == 'creances');

        List<CreanceModel?> nonPayeCreanceList = dataCreanceList
            .where((element) => element.statutPaie == false)
            .toList();
        for (var item in nonPayeCreanceList) {
          nonPayesCreance += double.parse(item!.montant);
        }
        for (var item in creancePayementList) {
          creancePayement += double.parse(item.montant);
        }

        // Dette
        var detteRemboursementList =
            creanceDettes.where((element) => element.creanceDette == 'dettes');
        List<DetteModel?> nonPayeDetteList = dataDetteList
            .where((element) => element.statutPaie == false)
            .toList();
        for (var item in nonPayeDetteList) {
          nonPayesDette += double.parse(item!.montant);
        }
        for (var item in detteRemboursementList) {
          detteRemboursement += double.parse(item.montant);
        }

        // FinanceExterieur
        List<FinanceExterieurModel?> recetteList = dataFinanceExterieurList;
        for (var item in recetteList) {
          cumulFinanceExterieur += double.parse(item!.montant);
        }

        List<DevisModel?> devisList = dataDevisList;

        // for (var item in devisList) {
        //   for (var i in item!.list) {
        //     depenses += double.parse(i['frais']);
        //   }
        // }

        soldeBanque = recetteBanque - depensesBanque;
        soldeCaisse = recetteCaisse - depensesCaisse;
        soldeCreance = nonPayesCreance - creancePayement;
        soldeDette = nonPayesDette - detteRemboursement;

        disponible = soldeBanque + soldeCaisse + cumulFinanceExterieur;
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
                          title: 'Tableau de bord',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: ListView(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            children: [
                              DashNumberWidget(
                                  number: '$agentsCount',
                                  title: 'Total agents',
                                  icon: Icons.group,
                                  color: Colors.blue.shade700),
                              DashNumberWidget(
                                  number: '$agentActifCount',
                                  title: 'Agent Actifs',
                                  icon: Icons.person,
                                  color: Colors.green.shade700),
                              DashNumberWidget(
                                  number: '$poursentExecution %',
                                  title: "Budgets",
                                  icon: Icons.monetization_on_outlined,
                                  color: Colors.purple.shade700),
                              DashNumberWidget(
                                  number:
                                      "${NumberFormat.decimalPattern('fr').format(soldeDette)} \$",
                                  title: 'Dette',
                                  icon: Icons.blur_linear_rounded,
                                  color: Colors.red.shade700),
                              DashNumberWidget(
                                  number:
                                      "${NumberFormat.decimalPattern('fr').format(soldeCreance)} \$",
                                  title: 'Créance',
                                  icon: Icons.money_off_csred,
                                  color: Colors.deepOrange.shade700),
                              DashNumberWidget(
                                  number:
                                      "${NumberFormat.decimalPattern('fr').format(depenses)} \$",
                                  title: 'Dépenses',
                                  icon: Icons.monetization_on,
                                  color: Colors.pink.shade700),
                              DashNumberWidget(
                                  number:
                                      "${NumberFormat.decimalPattern('fr').format(disponible)} \$",
                                  title: 'Disponible',
                                  icon: Icons.attach_money,
                                  color: Colors.teal.shade700),
                              DashNumberWidget(
                                  number: '$bilanCount',
                                  title: 'Bilans',
                                  icon: Icons.blur_linear_rounded,
                                  color: Colors.blueGrey.shade700),
                              DashNumberWidget(
                                  number: '$journalCount',
                                  title: 'Journals',
                                  icon: Icons.backup_table,
                                  color: Colors.blueAccent.shade700),
                              DashNumberWidget(
                                  number: '$projetsApprouveCount',
                                  title: 'Projets approvés',
                                  icon: Icons.work,
                                  color: Colors.grey.shade700),
                              DashNumberWidget(
                                  number: '$campaignCount',
                                  title: 'Campaignes',
                                  icon: Icons.campaign,
                                  color: Colors.orange.shade700),
                            ],
                          ),
                          const SizedBox(height: p20),
                          Responsive.isDesktop(context)
                              ? Row(
                                  children: const [
                                    Expanded(
                                        flex: 3,
                                        child: FlashCard(
                                            height: 300,
                                            width: double.infinity,
                                            frontWidget: CourbeVenteGainYear(),
                                            backWidget:
                                                CourbeVenteGainMounth())),
                                    Expanded(flex: 1, child: DashRHPieWidget())
                                  ],
                                )
                              : Column(
                                  children: const [
                                    FlashCard(
                                        height: 300,
                                        width: double.infinity,
                                        frontWidget: CourbeVenteGainYear(),
                                        backWidget: CourbeVenteGainMounth()),
                                    SizedBox(height: p20),
                                    DashRHPieWidget()
                                  ],
                                )
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
