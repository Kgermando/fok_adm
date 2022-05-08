import 'package:auto_size_text/auto_size_text.dart';
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
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    return ExpansionTile(
      leading: const Icon(Icons.account_balance, size: 30.0),
      title: AutoSizeText('Finances', maxLines: 1, style: bodyLarge),
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
              // Navigator.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == FinanceRoutes.financeDashboard,
            icon: Icons.manage_accounts,
            sizeIcon: 20.0,
            title: 'Directeur de departement',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(FinanceRoutes.financeDashboard);
              // Navigator.of(context).pop();
            }),
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
                selected:
                    widget.pageCurrente == FinanceRoutes.transactionsBanque,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Banque',
                style: bodyText2!,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsBanque);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == FinanceRoutes.transactionsCaisse,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Caisse',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsCaisse);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == FinanceRoutes.transactionsCreances,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Creances',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsCreances);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == FinanceRoutes.transactionsDettes,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Dettes',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsDettes);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    FinanceRoutes.transactionsFinancementExterne,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Autres Fin.',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(FinanceRoutes.transactionsFinancementExterne);
                  // Navigator.of(context).pop();
                }),
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
                  // Navigator.of(context).pop();
                }),
          ],
        ),
        DrawerWidget(
            selected: widget.pageCurrente == DevisRoutes.devis,
            icon: Icons.note_alt,
            sizeIcon: 20.0,
            title: 'Etat de besoin',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(DevisRoutes.devis);
              // Navigator.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == RhRoutes.rhPerformence,
            icon: Icons.multiline_chart_sharp,
            sizeIcon: 20.0,
            title: 'Performences',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(RhRoutes.rhPerformence);
              // Navigator.of(context).pop();
            }),
      ],
    );
  }
}
