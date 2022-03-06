import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
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

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    String pageCurrente = Routemaster.of(context).currentRoute.fullPath;
    return Drawer(
      elevation: 10.0,
      child: ListView(
        children: [
          const SizedBox(
            height: 50.0,
          ),
          ExpansionTile(
            leading: const Icon(Icons.monetization_on),
            title: Text('Finances', style: headline6),
            initiallyExpanded: false,
            onExpansionChanged: (val) {
              setState(() {
                isOpen = !val;
              });
            },
            trailing: const Icon(Icons.arrow_drop_down),
            children: [
              DrawerWidget(
                selected: pageCurrente == '/finance-dashboard',
                icon: Icons.arrow_right,
                title: 'Dashboard',
                onTap: () {
                  Routemaster.of(context).replace('/finance-dashboard');
                  Responsive.isMobile(context);
                  Navigator.of(context).pop();
                }
              ),
              DrawerWidget(
                selected: pageCurrente == '/finance-transactions',
                icon: Icons.arrow_right,
                title: 'Transactions',
                onTap: () {
                  Routemaster.of(context).replace('/finance-transactions');
                  Responsive.isMobile(context);
                  Navigator.of(context).pop();
                }
              ),
              DrawerWidget(
                selected: pageCurrente == '/finance-budget',
                icon: Icons.arrow_right,
                title: 'Budget',
                onTap: () {
                  Routemaster.of(context).replace('/finance-budget');
                  Responsive.isMobile(context);
                  Navigator.of(context).pop();
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}
