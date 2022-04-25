import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class BudgetNav extends StatefulWidget {
  const BudgetNav({ Key? key, required this.pageCurrente }) : super(key: key);
  final String pageCurrente;

  @override
  State<BudgetNav> createState() => _BudgetNavState();
}

class _BudgetNavState extends State<BudgetNav> {
  bool isOpenBudget = false;

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    return ExpansionTile(
      leading: const Icon(Icons.fact_check, size: 30.0),
      title: Text('Budgets', style: bodyMedium),
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
              // Routemaster.of(context).pop();
            }),
      ],
    );
  }
}