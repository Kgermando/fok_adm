import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/navigation/drawer/components/finances_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:routemaster/routemaster.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key, this.controller, this.page})
      : super(key: key);
  final PageController? controller;
  final int? page;

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool isOpen = false;
  bool isOpenTransaction = false;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    String pageCurrente = Routemaster.of(context).currentRoute.fullPath;
    return Drawer(
      elevation: 10.0,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset('assets/images/logo.png', width: 100, height: 100,)
          ),
          DrawerWidget(
            selected: pageCurrente == '/admin-dashboard',
            icon: Icons.dashboard,
            sizeIcon: 30.0,
            title: 'Dashboard',
            style: headline6!,
            onTap: () {
              Routemaster.of(context).replace('/admin-dashboard'); 
              // Responsive.isMobile(context);
              Routemaster.of(context).pop();
            }
          ),
          FinancesNav(pageCurrente: pageCurrente)
        ],
      ),
    );
  }
}
