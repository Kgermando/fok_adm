import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/components/administration_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/finances_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/rh_nav.dart';
import 'package:routemaster/routemaster.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key, this.controller, this.page}) : super(key: key);
  final PageController? controller;
  final int? page;

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    String pageCurrente = Routemaster.of(context).currentRoute.fullPath;

    print('pageCurrente $pageCurrente');
    // print('path $path');
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
            FinancesNav(pageCurrente: pageCurrente),
            RhNav(pageCurrente: pageCurrente),
          ],
        ),
      ),
    );
  }
}
