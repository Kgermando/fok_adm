import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
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
  
  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    
    return ExpansionTile(
        leading: const Icon(Icons.monetization_on, size: 30.0),
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
            selected: widget.pageCurrente == '/finance-dashboard',
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
                selected: widget.pageCurrente == '/transactions-caisse',
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
                selected: widget.pageCurrente == '/transactions-banque',
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
                  selected: widget.pageCurrente == '/transactions-dettes',
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
                selected: widget.pageCurrente == '/transactions-creances',
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
                selected: widget.pageCurrente == '/transactions-financement-externe',
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
                  selected: widget.pageCurrente == '/transactions-depenses',
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
          ExpansionTile(
            leading: const Icon(Icons.analytics, size: 20.0),
            title: Text('Comptabilités', style: bodyText1),
            initiallyExpanded: false,
            onExpansionChanged: (val) {
              setState(() {
                isOpenTransaction = !val;
              });
            },
            children: [
              DrawerWidget(
                  selected: widget.pageCurrente == '/comptabilite-bilan',
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Bilan',
                  style: bodyText2,
                  onTap: () {
                    Routemaster.of(context).replace('/comptabilite-bilan');
                    Routemaster.of(context).pop();
                  }),
              DrawerWidget(
                  selected: widget.pageCurrente == '/comptabilite-journal',
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Journal',
                  style: bodyText2,
                  onTap: () {
                    Routemaster.of(context).replace('/comptabilite-journal');
                    // Responsive.isMobile(context);
                    Routemaster.of(context).pop();
                  }),
              DrawerWidget(
                  selected: widget.pageCurrente == '/comptabilite-valorisation',
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Valorisation',
                  style: bodyText2,
                  onTap: () {
                    Routemaster.of(context).replace('/comptabilite-valorisation');
                    // Responsive.isMobile(context);
                    Routemaster.of(context).pop();
                  }),
              DrawerWidget(
                  selected: widget.pageCurrente == '/comptabilite-amortissement',
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Amortissement',
                  style: bodyText2,
                  onTap: () {
                    Routemaster.of(context)
                        .replace('/comptabilite-amortissement');
                    // Responsive.isMobile(context);
                    Routemaster.of(context).pop();
                  }),
            ],
          ),
          DrawerWidget(
            selected: widget.pageCurrente == '/finance-budget',
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
      );
  }
}
