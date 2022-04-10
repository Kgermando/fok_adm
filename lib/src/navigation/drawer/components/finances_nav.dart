import 'package:flutter/material.dart';
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
            selected: widget.pageCurrente == FinanceRoutes.financeDashboard,
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Dashboard',
            style: bodyText1!,
            onTap: () {
              Routemaster.of(context).replace(FinanceRoutes.financeDashboard);
              // Routemaster.of(context).pop();
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
                selected: widget.pageCurrente == FinanceRoutes.transactionsCaisse,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Caisse',
                style: bodyText2!,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsCaisse);
                  // Routemaster.of(context).pop();
                }
              ),
              DrawerWidget(
                selected: widget.pageCurrente == FinanceRoutes.transactionsBanque,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Banque',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsBanque);
                  // Routemaster.of(context).pop();
                }
              ),
              DrawerWidget(
                  selected: widget.pageCurrente == FinanceRoutes.transactionsDettes,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Dettes',
                  style: bodyText2,
                  onTap: () {
                    Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsDettes);
                  // Routemaster.of(context).pop();
                }),
              DrawerWidget(
                selected: widget.pageCurrente == FinanceRoutes.transactionsCreances,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Creances',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsCreances);
                  // Routemaster.of(context).pop();
                }),
              DrawerWidget(
                selected: widget.pageCurrente == FinanceRoutes.transactionsFinancementExterne,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Fin. externes',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsFinancementExterne);
                  // Routemaster.of(context).pop();
                  }),
              DrawerWidget(
                selected: widget.pageCurrente == FinanceRoutes.transactionsDepenses,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Dépenses',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context).replace(FinanceRoutes.transactionsDepenses);
                  // Routemaster.of(context).pop();
                }
              ),
              DrawerWidget(
                selected:
                    widget.pageCurrente == FinanceRoutes.transactionsPaiement,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Paiement salaire',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsPaiement);
                  // Routemaster.of(context).pop();
                }
              ),
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
                  selected: widget.pageCurrente == FinanceRoutes.comptabiliteBilan,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Bilan',
                  style: bodyText2,
                  onTap: () {
                    Routemaster.of(context)
                      .replace(FinanceRoutes.comptabiliteBilan);
                  // Routemaster.of(context).pop();
                  }),
              DrawerWidget(
                  selected: widget.pageCurrente == FinanceRoutes.comptabiliteJournal,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Journal',
                  style: bodyText2,
                  onTap: () {
                    Routemaster.of(context)
                      .replace(FinanceRoutes.comptabiliteJournal);
                  // Routemaster.of(context).pop();
                  }),
              DrawerWidget(
                  selected: widget.pageCurrente == FinanceRoutes.comptabiliteValorisation,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Valorisation',
                  style: bodyText2,
                  onTap: () {
                    Routemaster.of(context)
                      .replace(FinanceRoutes.comptabiliteValorisation);
                  // Routemaster.of(context).pop();
                  }),
              DrawerWidget(
                  selected: widget.pageCurrente == FinanceRoutes.comptabiliteAmortissement,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Amortissement',
                  style: bodyText2,
                  onTap: () {
                    Routemaster.of(context)
                      .replace(FinanceRoutes.comptabiliteAmortissement);
                  // Routemaster.of(context).pop();
                  
                  }),
            ],
          ),
          DrawerWidget(
            selected: widget.pageCurrente == FinanceRoutes.financeBudget,
            icon: Icons.maps_home_work_outlined,
            sizeIcon: 20.0,
            title: 'Budget',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context)
                      .replace(FinanceRoutes.financeBudget);
                  // Routemaster.of(context).pop();
            }
          ),
          DrawerWidget(
            selected: widget.pageCurrente == RhRoutes.rhPerformence,
            icon: Icons.multiline_chart_sharp,
            sizeIcon: 20.0,
            title: 'Performences',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(RhRoutes.rhPerformence);
              // Routemaster.of(context).pop();
            }),
        ],
      );
  }
}
