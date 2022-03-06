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
          const SizedBox(
            height: 50.0,
          ),
          ExpansionTile(
            leading: const Icon(Icons.monetization_on, size: 30.0,),
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
                icon: Icons.dashboard,
                sizeIcon: 20.0,
                title: 'Dashboard',
                style: bodyText1!,
                onTap: () {
                  Routemaster.of(context).replace('/finance-dashboard');
                  // Responsive.isMobile(context);
                  Routemaster.of(context).pop();
                }
              ),

              ExpansionTile(
                leading: const Icon(Icons.compare_arrows, size: 20.0,),
                title: Text('Transactions', style: bodyText1),
                initiallyExpanded: false,
                onExpansionChanged: (val) {
                  setState(() {
                    isOpenTransaction = !val;
                  });
                },
                children: [
                  DrawerWidget(
                    selected: pageCurrente == '/transactions-caisse',
                    icon: Icons.arrow_right,
                    sizeIcon: 15.0,
                    title: 'Caisse',
                    style: bodyText2!,
                    onTap: () {
                      Routemaster.of(context)
                          .replace('/transactions-caisse');
                      // Responsive.isMobile(context);
                      Routemaster.of(context).pop();
                    }
                  ),
                  DrawerWidget(
                    selected: pageCurrente == '/transactions-banque',
                    icon: Icons.arrow_right,
                    sizeIcon: 15.0,
                    title: 'Banque',
                    style: bodyText2,
                    onTap: () {
                      Routemaster.of(context)
                          .replace('/transactions-banque');
                      // Responsive.isMobile(context);
                      Routemaster.of(context).pop();
                    }
                  ),
                  DrawerWidget(
                      selected: pageCurrente == '/transactions-dettes',
                      icon: Icons.arrow_right,
                      sizeIcon: 15.0,
                      title: 'Dettes',
                      style: bodyText2,
                      onTap: () {
                        Routemaster.of(context)
                            .replace('/transactions-dettes');
                        // Responsive.isMobile(context);
                        Routemaster.of(context).pop();
                    }),
                  DrawerWidget(
                    selected: pageCurrente == '/transactions-creances',
                    icon: Icons.arrow_right,
                    sizeIcon: 15.0,
                    title: 'Creances',
                    style: bodyText2,
                    onTap: () {
                      Routemaster.of(context)
                          .replace('/transactions-creances');
                      // Responsive.isMobile(context);
                      Routemaster.of(context).pop();
                    }),
                  DrawerWidget(
                    selected: pageCurrente == '/transactions-financement-externe',
                    icon: Icons.arrow_right,
                    sizeIcon: 15.0,
                    title: 'Fin. externes',
                    style: bodyText2,
                    onTap: () {
                      Routemaster.of(context)
                          .replace('/transactions-financement-externe');
                      // Responsive.isMobile(context);
                      Routemaster.of(context).pop();
                      }),
                  DrawerWidget(
                      selected: pageCurrente == '/transactions-depenses',
                      icon: Icons.arrow_right,
                      sizeIcon: 15.0,
                      title: 'Dépenses',
                      style: bodyText2,
                      onTap: () {
                        Routemaster.of(context)
                            .replace('/transactions-depenses');
                        // Responsive.isMobile(context);
                        Routemaster.of(context).pop();
                      }),
                ],
              ),
              DrawerWidget(
                selected: pageCurrente == '/finance-budget',
                icon: Icons.maps_home_work_outlined,
                sizeIcon: 20.0,
                title: 'Budget',
                style: bodyText1,
                onTap: () {
                  Routemaster.of(context).replace('/finance-budget');
                  // Responsive.isMobile(context);
                  Routemaster.of(context).pop();
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}
