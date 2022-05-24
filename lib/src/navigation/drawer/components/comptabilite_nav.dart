import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/balance_compte_api.dart';
import 'package:fokad_admin/src/api/comptabilite/bilan_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_resultat_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class ComptabiliteNav extends StatefulWidget {
  const ComptabiliteNav({Key? key, required this.pageCurrente})
      : super(key: key);
  final String pageCurrente;

  @override
  State<ComptabiliteNav> createState() => _ComptabiliteNavState();
}

class _ComptabiliteNavState extends State<ComptabiliteNav> {
  bool isOpenComptabilite = false;
  int itemCount = 0;

  int bilanCount = 0;
  int compteResultatCount = 0;
  int journalCount = 0;
  int balanceCount = 0;

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
    var bilans = await BilanApi().getAllData();
    var journal = await JournalApi().getAllData();
    var compteReultats = await CompteResultatApi().getAllData();
    var balances = await BalanceCompteApi().getAllData();

    setState(() {
      user = userModel;
      bilanCount = bilans.length;
      journalCount = journal.length;
      compteResultatCount = compteReultats.length;
      balanceCount = balances.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    double userRole = double.parse(user.role);

    itemCount = bilanCount + compteResultatCount + journalCount + balanceCount;

    return ExpansionTile(
      leading: const Icon(Icons.table_view, size: 30.0),
      title: AutoSizeText('Comptabilités', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenComptabilite = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        if (userRole <= 2)
          DrawerWidget(
              selected: widget.pageCurrente ==
                  ComptabiliteRoutes.comptabiliteDashboard,
              icon: Icons.dashboard,
              sizeIcon: 20.0,
              title: 'Dashboard',
              style: bodyText1!,
              onTap: () {
                Routemaster.of(context)
                    .replace(ComptabiliteRoutes.comptabiliteDashboard);
                // Navigator.of(context).pop();
              }),
        if (userRole <= 2)
          DrawerWidget(
              selected:
                  widget.pageCurrente == ComptabiliteRoutes.comptabiliteDD,
              icon: Icons.manage_accounts,
              sizeIcon: 15.0,
              title: 'Directeur departement',
              style: bodyText2!,
              badge: Badge(
                showBadge: (itemCount >= 1) ? true : false,
                badgeColor: Colors.teal,
                badgeContent: Text('$itemCount',
                    style:
                        const TextStyle(fontSize: 10.0, color: Colors.white)),
                child: const Icon(Icons.notifications),
              ),
              onTap: () {
                Routemaster.of(context)
                    .replace(ComptabiliteRoutes.comptabiliteDD);
                // Navigator.of(context).pop();
              }),
        DrawerWidget(
            selected:
                widget.pageCurrente == ComptabiliteRoutes.comptabiliteBilan,
            icon: Icons.arrow_right,
            sizeIcon: 15.0,
            title: 'Bilan',
            style: bodyText2!,
            onTap: () {
              Routemaster.of(context)
                  .replace(ComptabiliteRoutes.comptabiliteBilan);
              // Navigator.of(context).pop();
            }),
        DrawerWidget(
            selected:
                widget.pageCurrente == ComptabiliteRoutes.comptabiliteJournal,
            icon: Icons.arrow_right,
            sizeIcon: 15.0,
            title: 'Journal',
            style: bodyText2,
            onTap: () {
              Routemaster.of(context)
                  .replace(ComptabiliteRoutes.comptabiliteJournal);
              // Navigator.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente ==
                ComptabiliteRoutes.comptabiliteCompteResultat,
            icon: Icons.arrow_right,
            sizeIcon: 15.0,
            title: 'Compte resultats',
            style: bodyText2,
            onTap: () {
              Routemaster.of(context)
                  .replace(ComptabiliteRoutes.comptabiliteCompteResultat);
              // Navigator.of(context).pop();
            }),
        DrawerWidget(
            selected:
                widget.pageCurrente == ComptabiliteRoutes.comptabiliteBalance,
            icon: Icons.arrow_right,
            sizeIcon: 15.0,
            title: 'Balance',
            style: bodyText2,
            onTap: () {
              Routemaster.of(context)
                  .replace(ComptabiliteRoutes.comptabiliteBalance);
              // Navigator.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente ==
                ComptabiliteRoutes.comptabiliteGrandLivre,
            icon: Icons.arrow_right,
            sizeIcon: 15.0,
            title: 'Grand livre',
            style: bodyText2,
            onTap: () {
              Routemaster.of(context)
                  .replace(ComptabiliteRoutes.comptabiliteGrandLivre);
              // Navigator.of(context).pop();
            }),
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
