import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/budgets/budgets_previsionels/components/add_budget_previsionel.dart';
import 'package:fokad_admin/src/pages/budgets/budgets_previsionels/components/table_departement_budget.dart';

class BudgetsPrevisionnels extends StatefulWidget {
  const BudgetsPrevisionnels({Key? key}) : super(key: key);

  @override
  State<BudgetsPrevisionnels> createState() => _BudgetsPrevisionnelsState();
}

class _BudgetsPrevisionnelsState extends State<BudgetsPrevisionnels> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            // Routemaster.of(context)
            //   .replace(BudgetRoutes.budgetBudgetPrevisionelAdd);
            Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddBudgetPrevionel()));
          }),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppbar(
                          title: 'Budgets previsionels',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableDepartementBudget())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
