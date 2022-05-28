import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/exploitations/projets_api.dart';
import 'package:fokad_admin/src/api/finances/creance_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

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

  int creanceCount = 0;
  int detteCount = 0;

  int salaireCount = 0;
  int campaignCount = 0;
  int devisCount = 0;
  int projetCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

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
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');

  Future<void> getData() async {
    var userModel = await AuthApi().getUserId();
    var creances = await CreanceApi().getAllData();
    var dettes = await DetteApi().getAllData();
    var salaires = await PaiementSalaireApi().getAllData();
    var campaigns = await CampaignApi().getAllData();
    var devis = await DevisAPi().getAllData();
    var projets = await ProjetsApi().getAllData();
    var approbations = await ApprobationApi().getAllData();

    if (mounted) {
      setState(() {
      user = userModel;
      for (var item in approbations) {
        creanceCount = creances
            .where((element) =>
                element.statutPaie == false &&
                element.id == item.reference &&
                item.fontctionOccupee == 'Directeur budget')
            .toList()
            .length;
      }

      for (var item in approbations) {
        detteCount = dettes
            .where((element) =>
                element.statutPaie == false &&
                element.id == item.reference &&
                item.fontctionOccupee == 'Directeur budget')
            .toList()
            .length;
      }

      for (var item in approbations) {
        salaireCount = salaires
            .where((element) =>
                element.id == item.reference &&
                item.fontctionOccupee == 'Directeur budget')
            .toList()
            .length;
      }
      for (var item in approbations) {
        campaignCount = campaigns
            .where((element) =>
                element.id == item.reference &&
                item.fontctionOccupee == 'Directeur budget')
            .toList()
            .length;
      }
      for (var item in approbations) {
        devisCount = devis
            .where((element) =>
                element.id == item.reference &&
                item.fontctionOccupee == 'Directeur budget')
            .toList()
            .length;
      }
      for (var item in approbations) {
        projetCount = projets
            .where((element) =>
                element.id == item.reference &&
                item.fontctionOccupee == 'Directeur finance')
            .toList()
            .length;
      }
    });
    }
  }


  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    double userRole = double.parse(user.role);

    itemCount =  creanceCount + detteCount + salaireCount + campaignCount +
       devisCount + projetCount;

    return ExpansionTile(
      leading: const Icon(Icons.account_balance, size: 30.0),
      title: AutoSizeText('Finances', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpen = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        if (userRole <= 2)
        DrawerWidget(
            selected: widget.pageCurrente == FinanceRoutes.financeDashboard,
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Dashboard',
            style: bodyText1!,
            onTap: () {
              Routemaster.of(context).replace(FinanceRoutes.financeDashboard);
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
                  style: const TextStyle(fontSize: 10.0, color: Colors.white)),
              child: const Icon(Icons.notifications),
            ),
            onTap: () {
              Routemaster.of(context).replace(FinanceRoutes.finDD);
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
                selected:
                    widget.pageCurrente == FinanceRoutes.transactionsBanque,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Banque',
                style: bodyText2!,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsBanque);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == FinanceRoutes.transactionsCaisse,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Caisse',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsCaisse);
                  // Navigator.of(context).pop();
                }),
            if (userRole <= 2)
            DrawerWidget(
                selected:
                    widget.pageCurrente == FinanceRoutes.transactionsCreances,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Creances',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsCreances);
                  // Navigator.of(context).pop();
                }),
            if (userRole <= 2)
            DrawerWidget(
                selected:
                    widget.pageCurrente == FinanceRoutes.transactionsDettes,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Dettes',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsDettes);
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
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsFinancementExterne);
                  // Navigator.of(context).pop();
                }),
          ],
        ),
        DrawerWidget(
            selected: widget.pageCurrente == RhRoutes.rhPerformence,
            icon: Icons.multiline_chart_sharp,
            sizeIcon: 20.0,
            title: 'Performences',
            style: bodyText1!,
            onTap: () {
              Routemaster.of(context).replace(RhRoutes.rhPerformence);
              // Navigator.of(context).pop();
            }),
      ],
    );
  }
}
