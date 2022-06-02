import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/produit_model_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/comptabilite/balance_compte_api.dart';
import 'package:fokad_admin/src/api/comptabilite/bilan_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_resultat_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/exploitations/projets_api.dart';
import 'package:fokad_admin/src/api/finances/creance_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/api/logistiques/carburant_api.dart';
import 'package:fokad_admin/src/api/logistiques/immobiler_api.dart';
import 'package:fokad_admin/src/api/logistiques/mobilier_api.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class AdministrationNav extends StatefulWidget {
  const AdministrationNav({Key? key, required this.pageCurrente})
      : super(key: key);
  final String pageCurrente;

  @override
  State<AdministrationNav> createState() => _AdministrationNavState();
}

class _AdministrationNavState extends State<AdministrationNav> {
  String departement = '';
  bool isOpenAdmin = false;

  int budgetCount = 0;
  int financeCount = 0;
  int comptabiliteCount = 0;
  int rhCount = 0;
  int exploitationCount = 0;
  int commMarketingCount = 0;
  int logistiqueCount = 0;
  int etatBesoinCount = 0;

  // RH
  int agentInactifs = 0;
  int salaireCount = 0;

  // Finances
  int creanceCount = 0;
  int detteCount = 0;

  // Comptabilites
  int bilanCount = 0;
  int compteResultatCount = 0;
  int journalCount = 0;
  int balanceCount = 0;

  // Comm & Marketing
  int campaignCount = 0;
  int succursaleCount = 0;
  int prodModelCount = 0;

  // Logistique
  int anguinsCount = 0;
  int carburantCount = 0;
  int immobiliersCount = 0;
  int mobiliersCount = 0;

  int countPaie = 0;
  int nbrCreance = 0;
  int nbrDette = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    var userModel = await AuthApi().getUserId();
    // Budgets
    var dataLigneBudgetaireList = await LIgneBudgetaireApi().getAllData();

    // RH
    var agents = await AgentsApi().getAllData();
    var salaires = await PaiementSalaireApi().getAllData();

    // Finances
    var creances = await CreanceApi().getAllData();
    var dettes = await DetteApi().getAllData();

    // Comptabilites
    var bilans = await BilanApi().getAllData();
    var journal = await JournalApi().getAllData();
    var compteReultats = await CompteResultatApi().getAllData();
    var balances = await BalanceCompteApi().getAllData();

    // Exploitations
    var exploitations = await ProjetsApi().getAllData();

    // Comm & Marketing
    var campaigns = await CampaignApi().getAllData();
    var succursale = await SuccursaleApi().getAllData();
    var prodModels = await ProduitModelApi().getAllData();

    // Logistique
    var anguins = await AnguinApi().getAllData();
    var carburants = await CarburantApi().getAllData();
    var immobiliers = await ImmobilierApi().getAllData();
    var mobiliers = await MobilierApi().getAllData();

    // Etaat de Besoins
    var etatBesions = await DevisAPi().getAllData();
    if (mounted) {
      setState(() {
        departement = userModel.departement;
        // Budgets
        budgetCount = dataLigneBudgetaireList.length;

        // RH
        agentInactifs =
            agents.where((element) => element.statutAgent == false).length;
        salaireCount =
            salaires.where((element) => element.observation == false).length;

        // Finances
        creanceCount = creances
            .where((element) => element.statutPaie == false)
            .toList()
            .length;
        detteCount = dettes
            .where((element) => element.statutPaie == false)
            .toList()
            .length;

        // Comptabilites
        bilanCount = bilans.length;
        journalCount = journal.length;
        compteResultatCount = compteReultats.length;
        balanceCount = balances.length;

        // Exploitations
        exploitationCount = exploitations.length;

        // Comm & Marketing
        campaignCount = campaigns.length;
        succursaleCount = succursale.length;
        prodModelCount = prodModels.length;

        // Logistique
        anguinsCount = anguins.length;
        carburantCount = carburants.length;
        immobiliersCount = immobiliers.length;
        mobiliersCount = mobiliers.length;

        // Etaat de Besoins
        etatBesoinCount = etatBesions.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    rhCount = agentInactifs + salaireCount;

    financeCount = creanceCount + detteCount;

    comptabiliteCount =
        bilanCount + compteResultatCount + journalCount + balanceCount;

    commMarketingCount = campaignCount + succursaleCount + prodModelCount;

    logistiqueCount =
        anguinsCount + carburantCount + immobiliersCount + mobiliersCount;

    return ExpansionTile(
      leading: const Icon(
        Icons.admin_panel_settings,
        size: 30.0,
      ),
      title: AutoSizeText('Administration', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged:  (val) {
        setState(() {
          if (departement == 'Administration') {
            isOpenAdmin = true;
            isOpenAdmin = !val;
          } else {
            isOpenAdmin = !val;
          }
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        FutureBuilder<UserModel>(
            future: AuthApi().getUserId(),
            builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
              if (snapshot.hasData) {
                // UserModel? user = snapshot.data;
                // int userRole = int.parse(user!.role);
                return Column(
                  children: [
                    DrawerWidget(
                        selected:
                            widget.pageCurrente == AdminRoutes.adminDashboard,
                        icon: Icons.dashboard,
                        sizeIcon: 20.0,
                        title: 'Dashboard',
                        style: bodyText1!,
                        onTap: () {
                          Navigator.pushNamed(
                              context, AdminRoutes.adminDashboard);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected:
                            widget.pageCurrente == AdminRoutes.adminBudget,
                        icon: Icons.fact_check,
                        sizeIcon: 20.0,
                        title: 'Budgets',
                        style: bodyText1,
                        badge: Badge(
                          showBadge: (budgetCount >= 1) ? true : false,
                          badgeColor: Colors.teal,
                          badgeContent: Text('$budgetCount',
                              style: const TextStyle(
                                  fontSize: 10.0, color: Colors.white)),
                          child: const Icon(Icons.notifications),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, AdminRoutes.adminBudget);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected:
                            widget.pageCurrente == AdminRoutes.adminFinance,
                        icon: Icons.account_balance,
                        sizeIcon: 20.0,
                        title: 'Finances',
                        style: bodyText1,
                        badge: Badge(
                          showBadge: (financeCount >= 1) ? true : false,
                          badgeColor: Colors.teal,
                          badgeContent: Text('$financeCount',
                              style: const TextStyle(
                                  fontSize: 10.0, color: Colors.white)),
                          child: const Icon(Icons.notifications),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, AdminRoutes.adminFinance);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected:
                            widget.pageCurrente == AdminRoutes.adminEtatBesoin,
                        icon: Icons.note_alt,
                        sizeIcon: 20.0,
                        title: 'Etat de besoin',
                        style: bodyText1,
                        badge: Badge(
                          showBadge: (etatBesoinCount >= 1) ? true : false,
                          badgeColor: Colors.teal,
                          badgeContent: Text('$financeCount',
                              style: const TextStyle(
                                  fontSize: 10.0, color: Colors.white)),
                          child: const Icon(Icons.notifications),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, AdminRoutes.adminEtatBesoin);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected: widget.pageCurrente ==
                            AdminRoutes.adminComptabilite,
                        icon: Icons.table_view,
                        sizeIcon: 20.0,
                        title: 'Comptabilités',
                        style: bodyText1,
                        badge: Badge(
                          showBadge: (comptabiliteCount >= 1) ? true : false,
                          badgeColor: Colors.teal,
                          badgeContent: Text('$comptabiliteCount',
                              style: const TextStyle(
                                  fontSize: 10.0, color: Colors.white)),
                          child: const Icon(Icons.notifications),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, AdminRoutes.adminComptabilite);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected: widget.pageCurrente == AdminRoutes.adminRH,
                        icon: Icons.group,
                        sizeIcon: 20.0,
                        title: 'RH',
                        style: bodyText1,
                        badge: Badge(
                          showBadge: (rhCount >= 1) ? true : false,
                          badgeColor: Colors.teal,
                          badgeContent: Text('$rhCount',
                              style: const TextStyle(
                                  fontSize: 10.0, color: Colors.white)),
                          child: const Icon(Icons.notifications),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, AdminRoutes.adminRH);
                        }),
                    DrawerWidget(
                        selected: widget.pageCurrente ==
                            AdminRoutes.adminExploitation,
                        icon: Icons.work,
                        sizeIcon: 20.0,
                        title: 'Exploitations',
                        style: bodyText1,
                        badge: Badge(
                          showBadge: (exploitationCount >= 1) ? true : false,
                          badgeColor: Colors.teal,
                          badgeContent: Text('$exploitationCount',
                              style: const TextStyle(
                                  fontSize: 10.0, color: Colors.white)),
                          child: const Icon(Icons.notifications),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, AdminRoutes.adminExploitation);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected: widget.pageCurrente ==
                            AdminRoutes.adminCommMarketing,
                        icon: Icons.add_business,
                        sizeIcon: 20.0,
                        title: 'Comm. & Marketing',
                        style: bodyText1,
                        badge: Badge(
                          showBadge: (commMarketingCount >= 1) ? true : false,
                          badgeColor: Colors.teal,
                          badgeContent: Text('$commMarketingCount',
                              style: const TextStyle(
                                  fontSize: 10.0, color: Colors.white)),
                          child: const Icon(Icons.notifications),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, AdminRoutes.adminCommMarketing);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected:
                            widget.pageCurrente == AdminRoutes.adminLogistique,
                        icon: Icons.home_work,
                        sizeIcon: 20.0,
                        title: 'Logistiques',
                        style: bodyText1,
                        badge: Badge(
                          showBadge: (logistiqueCount >= 1) ? true : false,
                          badgeColor: Colors.teal,
                          badgeContent: Text('$logistiqueCount',
                              style: const TextStyle(
                                  fontSize: 10.0, color: Colors.white)),
                          child: const Icon(Icons.notifications),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, AdminRoutes.adminLogistique);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected: widget.pageCurrente == RhRoutes.rhPerformence,
                        icon: Icons.multiline_chart_sharp,
                        sizeIcon: 20.0,
                        title: 'Performences',
                        style: bodyText1,
                        onTap: () {
                          Navigator.pushNamed(context, RhRoutes.rhPerformence);
                        }),
                  ],
                );
              } else {
                return Center(child: loadingColor());
              }
            }),
      ],
    );
  }
}
