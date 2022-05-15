import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/components/administration_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/archive_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/budget_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/com_marketing_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/comptabilite_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/exploitation_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/finances_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/logistique_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/mails_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/rh_nav.dart';
import 'package:routemaster/routemaster.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key, this.controller}) : super(key: key);
  final PageController? controller;

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {

    String pageCurrente = Routemaster.of(context).currentRoute.fullPath;
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
            AdministrationNav(pageCurrente: pageCurrente),
            RhNav(pageCurrente: pageCurrente),
            BudgetNav(pageCurrente: pageCurrente),
            ComptabiliteNav(pageCurrente: pageCurrente),
            FinancesNav(pageCurrente: pageCurrente),
            ExploitationNav(pageCurrente: pageCurrente),
            ComMarketing(pageCurrente: pageCurrente),
            LogistiqueNav(pageCurrente: pageCurrente),
            ArchiveNav(pageCurrente: pageCurrente),
            // MailsNAv(pageCurrente: pageCurrente)
          ],
        ),
      ),
    );
  }
}
