import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/notifications/comm_marketing/campaign_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/devis/devis_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/exploitations/projet_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/finances/creance_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/finances/dette_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/rh/salaires_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/rh/trans_rest_notify_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class FinancesNav extends StatefulWidget {
  const FinancesNav({Key? key, required this.pageCurrente}) : super(key: key);
  final String pageCurrente;

  @override
  State<FinancesNav> createState() => _FinancesNavState();
}

class _FinancesNavState extends State<FinancesNav> {
  bool isOpen = false;
  bool isOpenTransaction = false;
  int itemCount = 0;
  int observationCount = 0;

  int creanceCount = 0;
  int detteCount = 0;

  int salaireCount = 0;
  int transRestCount = 0;
  int campaignCount = 0;
  int devisCount = 0;
  int projetCount = 0;

  int salaireObsCount = 0;
  int transRestObsCount = 0;
  int campaignObsCount = 0;
  int devisObsCount = 0;
  int projetObsCount = 0;

  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getData();
    });
    super.initState();
  }

  @override
  dispose() {
    timer!.cancel();
    super.dispose();
  }

  Future<void> getData() async {
    var creanceCountNotify = await CreanceNotifyApi().getCountDD();
    var dettesCountNotify = await DetteNotifyApi().getCountDD();
    var salairesCountNotify = await SalaireNotifyApi().getCountFin();
    var transRestsCountNotify = await TransRestNotifyApi().getCountFin();
    var campaignsCountNotify = await CampaignNotifyApi().getCountFin();
    var devisCountNotify = await DevisNotifyApi().getCountFin();
    var projetsCountNotify = await ProjetNotifyApi().getCountFin(); 

    var salairesObsCountNotify = await SalaireNotifyApi().getCountObs();
    var transRestObssCountNotify = await TransRestNotifyApi().getCountObs();
    var campaignsObsCountNotify = await CampaignNotifyApi().getCountObs();
    var devisCountObsNotify = await DevisNotifyApi().getCountObs();
    var projetsObsCountNotify = await ProjetNotifyApi().getCountObs();

    if (mounted) {
      setState(() {
        // Approbations salaires
        creanceCount = creanceCountNotify.count;
        detteCount = dettesCountNotify.count;
        salaireCount = salairesCountNotify.count;
        transRestCount = transRestsCountNotify.count;
        campaignCount = campaignsCountNotify.count;
        devisCount = devisCountNotify.count;
        projetCount = projetsCountNotify.count; 

        // Observations
        salaireObsCount = salairesObsCountNotify.count; 
        transRestObsCount = transRestObssCountNotify.count; 
        campaignObsCount = campaignsObsCountNotify.count; 
        devisObsCount = devisCountObsNotify.count; 
        projetObsCount = projetsObsCountNotify.count;   

        itemCount = 
          creanceCount +
          detteCount +
          salaireCount +
          transRestCount +
          campaignCount +
          devisCount +
          projetCount;

        observationCount = 
          salaireObsCount +
          transRestObsCount +
          campaignObsCount +
          devisObsCount +
          projetObsCount;
      }); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2; 

    return FutureBuilder<UserModel>(
        future: AuthApi().getUserId(),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            UserModel? user = snapshot.data;
            int userRole = int.parse(user!.role);
            return ExpansionTile(
              leading: const Icon(Icons.account_balance, size: 30.0),
              title: AutoSizeText('Finances', maxLines: 1, style: bodyLarge),
              initiallyExpanded:
                  (user.departement == 'Finances') ? true : false,
              onExpansionChanged: (val) {
                setState(() {
                  isOpen = !val;
                });
              },
              trailing: const Icon(Icons.arrow_drop_down),
              children: [
                if (userRole <= 2)
                  DrawerWidget(
                      selected:
                          widget.pageCurrente == FinanceRoutes.financeDashboard,
                      icon: Icons.dashboard,
                      sizeIcon: 20.0,
                      title: 'Dashboard',
                      style: bodyText1!,
                      onTap: () {
                        Navigator.pushNamed(
                            context, FinanceRoutes.financeDashboard);
                        // Navigator.of(context).pop();
                      }),
                if (userRole <= 2)
                  DrawerWidget(
                      selected: widget.pageCurrente == FinanceRoutes.finDD,
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
                        Navigator.pushNamed(context, FinanceRoutes.finDD);
                        // Navigator.of(context).pop();
                      }),
                DrawerWidget(
                    selected:
                        widget.pageCurrente == FinanceRoutes.finObservation,
                    icon: Icons.grid_view,
                    sizeIcon: 20.0,
                    title: 'Observations',
                    style: bodyText1!,
                    badge: Badge(
                      showBadge: (observationCount >= 1) ? true : false,
                      badgeColor: Colors.purple,
                      badgeContent: Text('$observationCount',
                          style: const TextStyle(
                              fontSize: 10.0, color: Colors.white)),
                      child: const Icon(Icons.notifications),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context, FinanceRoutes.finObservation);
                      // Navigator.of(context).pop();
                    }),
                ExpansionTile(
                  leading: const Icon(Icons.compare_arrows, size: 20.0),
                  title: Text('Transactions', style: bodyText1),
                  initiallyExpanded: false,
                  onExpansionChanged: (val) {
                    setState(() {
                      isOpenTransaction = !val;
                    });
                  },
                  children: [
                    DrawerWidget(
                        selected: widget.pageCurrente ==
                            FinanceRoutes.transactionsBanque,
                        icon: Icons.arrow_right,
                        sizeIcon: 15.0,
                        title: 'Banque',
                        style: bodyText2!,
                        onTap: () {
                          Navigator.pushNamed(
                              context, FinanceRoutes.transactionsBanque);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected: widget.pageCurrente ==
                            FinanceRoutes.transactionsCaisse,
                        icon: Icons.arrow_right,
                        sizeIcon: 15.0,
                        title: 'Caisse',
                        style: bodyText2,
                        onTap: () {
                          Navigator.pushNamed(
                              context, FinanceRoutes.transactionsCaisse);
                          // Navigator.of(context).pop();
                        }),
                    if (userRole <= 2)
                      DrawerWidget(
                          selected: widget.pageCurrente ==
                              FinanceRoutes.transactionsCreances,
                          icon: Icons.arrow_right,
                          sizeIcon: 15.0,
                          title: 'Creances',
                          style: bodyText2,
                          onTap: () {
                            Navigator.pushNamed(
                                context, FinanceRoutes.transactionsCreances);
                            // Navigator.of(context).pop();
                          }),
                    if (userRole <= 2)
                      DrawerWidget(
                          selected: widget.pageCurrente ==
                              FinanceRoutes.transactionsDettes,
                          icon: Icons.arrow_right,
                          sizeIcon: 15.0,
                          title: 'Dettes',
                          style: bodyText2,
                          onTap: () {
                            Navigator.pushNamed(
                                context, FinanceRoutes.transactionsDettes);
                            // Navigator.of(context).pop();
                          }),
                    DrawerWidget(
                        selected: widget.pageCurrente ==
                            FinanceRoutes.transactionsFinancementExterne,
                        icon: Icons.arrow_right,
                        sizeIcon: 15.0,
                        title: 'Autres Fin.',
                        style: bodyText2,
                        onTap: () {
                          Navigator.pushNamed(context,
                              FinanceRoutes.transactionsFinancementExterne);
                          // Navigator.of(context).pop();
                        }),
                  ],
                ),
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
