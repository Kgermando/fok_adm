import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/exploitations/projets_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/api/rh/transport_restaurant_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class BudgetNav extends StatefulWidget {
  const BudgetNav({Key? key, required this.pageCurrente}) : super(key: key);
  final String pageCurrente;

  @override
  State<BudgetNav> createState() => _BudgetNavState();
}

class _BudgetNavState extends State<BudgetNav> {
  bool isOpenBudget = false;

  int itemCount = 0;

  int salaireCount = 0;
  int transRestCount = 0;
  int campaignCount = 0;
  int devisCount = 0;
  int projetCount = 0;
  int budgetDepCount = 0;

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: 'false',
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');

  @override
  void initState() {
    getData();

    super.initState();
  }

  Future<void> getData() async {
    var userModel = await AuthApi().getUserId();
    var salaires = await PaiementSalaireApi().getAllData();
    var transRests = await TransportRestaurationApi().getAllData();
    var campaigns = await CampaignApi().getAllData();
    var devis = await DevisAPi().getAllData();
    var projets = await ProjetsApi().getAllData();
    var budgetDep = await DepeartementBudgetApi().getAllData();
    if (mounted) {
      setState(() {
        user = userModel;
        salaireCount = salaires
            .where((element) =>
                element.createdAt.month == DateTime.now().month &&
                element.createdAt.year == DateTime.now().year &&
                element.approbationDD == 'Approved' &&
                element.observation == 'false' &&
                element.approbationBudget == '-')
            .length;
        
        transRestCount = transRests
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved' &&
                element.approbationBudget == '-')
            .length;

        campaignCount = campaigns
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved' &&
                element.approbationBudget == '-')
            .length;

        devisCount = devis
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved' &&
                element.approbationBudget == '-')
            .length;

        projetCount = projets
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved' &&
                element.approbationBudget == '-')
            .length;

        budgetDepCount = budgetDep
            .where((element) =>
                DateTime.now().millisecondsSinceEpoch <=
                    element.periodeFin.millisecondsSinceEpoch &&
                element.approbationDD == '-')
            .length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    itemCount = salaireCount +
        transRestCount +
        campaignCount +
        devisCount +
        projetCount +
        budgetDepCount;

    return FutureBuilder<UserModel>(
        future: AuthApi().getUserId(),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            UserModel? user = snapshot.data;
            int userRole = int.parse(user!.role);
            return ExpansionTile(
              leading: const Icon(Icons.fact_check, size: 30.0),
              title: AutoSizeText('Budgets', maxLines: 1, style: bodyLarge),
              initiallyExpanded: (user.departement == 'Budgets') ? true : false,
              onExpansionChanged: (val) {
                setState(() {
                  isOpenBudget = !val;
                });
              },
              trailing: const Icon(Icons.arrow_drop_down),
              children: [
                if (userRole <= 2)
                  DrawerWidget(
                      selected:
                          widget.pageCurrente == BudgetRoutes.budgetDashboard,
                      icon: Icons.dashboard,
                      sizeIcon: 20.0,
                      title: 'Dashboard',
                      style: bodyText1!,
                      onTap: () {
                        Navigator.pushNamed(
                            context, BudgetRoutes.budgetDashboard);
                        // Navigator.of(context).pop();
                      }),
                if (userRole <= 2)
                  DrawerWidget(
                      selected: widget.pageCurrente == BudgetRoutes.budgetDD,
                      icon: Icons.manage_accounts,
                      sizeIcon: 20.0,
                      title: 'Directeur de departement',
                      style: bodyText1!,
                      badge: Badge(
                        showBadge: (itemCount >= 1) ? true : false,
                        badgeColor: Colors.teal,
                        badgeContent: Text('$itemCount',
                            style: const TextStyle(
                                fontSize: 10.0, color: Colors.white)),
                        child: const Icon(Icons.notifications),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, BudgetRoutes.budgetDD);
                        // Navigator.of(context).pop();
                      }),
                DrawerWidget(
                    selected: widget.pageCurrente ==
                        BudgetRoutes.budgetBudgetPrevisionel,
                    icon: Icons.wallet_giftcard,
                    sizeIcon: 20.0,
                    title: 'Budgets previsonels',
                    style: bodyText1!,
                    onTap: () {
                      Navigator.pushNamed(
                          context, BudgetRoutes.budgetBudgetPrevisionel);
                      // Navigator.of(context).pop();
                    }),
                DrawerWidget(
                    selected: widget.pageCurrente ==
                        BudgetRoutes.historiqueBudgetBudgetPrevisionel,
                    icon: Icons.history_sharp,
                    sizeIcon: 20.0,
                    title: 'Historique Budgetaires',
                    style: bodyText1,
                    onTap: () {
                      Navigator.pushNamed(context,
                          BudgetRoutes.historiqueBudgetBudgetPrevisionel);
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
                      // Navigator.of(context).pop();
                    }),
                DrawerWidget(
                    selected: widget.pageCurrente == ArchiveRoutes.archives,
                    icon: Icons.archive,
                    sizeIcon: 20.0,
                    title: 'Archives',
                    style: bodyLarge!,
                    onTap: () {
                      Navigator.pushNamed(context, ArchiveRoutes.archives);
                      // Navigator.of(context).pop();
                    }),
              ],
            );
          } else {
            return Column(
              children: [loading(), const SizedBox(height: p20)],
            );
          }
        });
  }
}
