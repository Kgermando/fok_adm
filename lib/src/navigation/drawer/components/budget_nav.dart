import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class BudgetNav extends StatefulWidget {
  const BudgetNav({Key? key, required this.pageCurrente}) : super(key: key);
  final String pageCurrente;

  @override
  State<BudgetNav> createState() => _BudgetNavState();
}

class _BudgetNavState extends State<BudgetNav> {
  bool isOpenBudget = false;

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    return ExpansionTile(
      leading: const Icon(Icons.fact_check, size: 30.0),
      title: AutoSizeText('Budgets', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenBudget = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        DrawerWidget(
            selected: widget.pageCurrente == BudgetRoutes.budgetDashboard,
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Dashboard',
            style: bodyText1!,
            onTap: () {
              Routemaster.of(context).replace(
                BudgetRoutes.budgetDashboard,
              );
              // Navigator.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == BudgetRoutes.budgetDD,
            icon: Icons.manage_accounts,
            sizeIcon: 20.0,
            title: 'Directeur de departement',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(
                BudgetRoutes.budgetDD,
              );
              // Navigator.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == BudgetRoutes.budgetAutreDep,
            icon: Icons.manage_accounts,
            sizeIcon: 20.0,
            title: 'Approbation lignes budgetaires',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(
                BudgetRoutes.budgetAutreDep,
              );
              // Navigator.of(context).pop();
            }),
      ],
    );
  }
}
