import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
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
              Navigator.of(context)
                  .pushReplacementNamed(FinanceRoutes.financeDashboard);
              Navigator.of(context).pop();
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
                  Navigator.of(context)
                      .pushReplacementNamed(FinanceRoutes.transactionsCaisse);
                  Navigator.of(context).pop();
                }
              ),
              DrawerWidget(
                selected: widget.pageCurrente == FinanceRoutes.transactionsBanque,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Banque',
                style: bodyText2,
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(FinanceRoutes.transactionsBanque);
                  Navigator.of(context).pop();
                }
              ),
              DrawerWidget(
                  selected: widget.pageCurrente == FinanceRoutes.transactionsDettes,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Dettes',
                  style: bodyText2,
                  onTap: () {
                    Navigator.of(context)
                      .pushReplacementNamed(FinanceRoutes.transactionsDettes);
                    Navigator.of(context).pop();
                }),
              DrawerWidget(
                selected: widget.pageCurrente == FinanceRoutes.transactionsCreances,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Creances',
                style: bodyText2,
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                      FinanceRoutes.transactionsCreances);
                  Navigator.of(context).pop();
                }),
              DrawerWidget(
                selected: widget.pageCurrente == FinanceRoutes.transactionsFinancementExterne,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Fin. externes',
                style: bodyText2,
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(FinanceRoutes.transactionsFinancementExterne);
                  Navigator.of(context).pop();
                  }),
              DrawerWidget(
                  selected: widget.pageCurrente == FinanceRoutes.transactionsDepenses,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Dépenses',
                  style: bodyText2,
                  onTap: () {
                    Navigator.of(context)
                      .pushReplacementNamed(FinanceRoutes.transactionsDepenses);
                    Navigator.of(context).pop();
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
                  selected: widget.pageCurrente == FinanceRoutes.comptabiliteBilan,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Bilan',
                  style: bodyText2,
                  onTap: () {
                    Navigator.of(context)
                      .pushReplacementNamed(FinanceRoutes.comptabiliteBilan);
                    Navigator.of(context).pop();
                  }),
              DrawerWidget(
                  selected: widget.pageCurrente == FinanceRoutes.comptabiliteJournal,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Journal',
                  style: bodyText2,
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                      FinanceRoutes.comptabiliteJournal);
                    Navigator.of(context).pop();
                  }),
              DrawerWidget(
                  selected: widget.pageCurrente == FinanceRoutes.comptabiliteValorisation,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Valorisation',
                  style: bodyText2,
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                      FinanceRoutes.comptabiliteValorisation);
                    Navigator.of(context).pop();
                  }),
              DrawerWidget(
                  selected: widget.pageCurrente == FinanceRoutes.comptabiliteAmortissement,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Amortissement',
                  style: bodyText2,
                  onTap: () {
                    Navigator.of(context)
                      .pushReplacementNamed(FinanceRoutes.comptabiliteAmortissement);
                    Navigator.of(context).pop();
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
              Navigator.of(context).pushReplacementNamed(FinanceRoutes.financeBudget);
              Navigator.of(context).pop();
            }
          ),
        ],
      );
  }
}
