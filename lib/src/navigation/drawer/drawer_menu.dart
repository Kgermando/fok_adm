import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/components/administration_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/archive_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/budget_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/com_marketing_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/comptabilite_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/etat_besoin_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/exploitation_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/finances_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/logistique_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/rh_nav.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key, this.controller}) : super(key: key);
  final PageController? controller;

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  final ScrollController controller = ScrollController();

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
      role: '0',
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    var userModel = await AuthApi().getUserId();
    if (mounted) {
      setState(() {
        user = userModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // String pageCurrente = Routemaster.of(context).currentRoute.fullPath;
    String? pageCurrente = ModalRoute.of(context)!.settings.name;
    // print('pageCurrente $pageCurrente');

    return Drawer(
      elevation: 10.0,
      child: Scrollbar(
        controller: controller,
        child: ListView(
          controller: controller,
          children: [
            DrawerHeader(
                child: Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            )),
            if (user.departement == 'Administration')
              AdministrationNav(pageCurrente: pageCurrente!),
            if (user.departement == 'Ressources Humaines' ||
                user.departement == 'Administration')
              RhNav(pageCurrente: pageCurrente!),
            if (user.departement == 'Budgets' ||
                user.departement == 'Administration')
              BudgetNav(pageCurrente: pageCurrente!),
            if (user.departement == 'Finances' ||
                user.departement == 'Administration')
              FinancesNav(pageCurrente: pageCurrente!),
            if (user.departement == 'Comptabilites' ||
                user.departement == 'Administration')
              ComptabiliteNav(pageCurrente: pageCurrente!),
            if (user.departement == 'Exploitations' ||
                user.departement == 'Administration')
              ExploitationNav(pageCurrente: pageCurrente!),
            if (user.departement == 'Commercial et Marketing' ||
                user.departement == 'Administration')
              ComMarketing(pageCurrente: pageCurrente!),
            if (user.departement == 'Logistique' ||
                user.departement == 'Administration')
              LogistiqueNav(pageCurrente: pageCurrente!),
              
            EtatBesoinNav(pageCurrente: pageCurrente!),
            ArchiveNav(pageCurrente: pageCurrente),

            // MailsNAv(pageCurrente: pageCurrente)
          ],
        ),
      ),
    );
  }
}
