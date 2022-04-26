import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/budgets/components/table_departement_budget.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:provider/provider.dart';

class BudgetFinance extends StatefulWidget {
  const BudgetFinance({Key? key}) : super(key: key);

  @override
  State<BudgetFinance> createState() => _BudgetFinanceState();
}

class _BudgetFinanceState extends State<BudgetFinance> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
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
                       CustomAppbar(title: 'Finance Budget',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: ListView(
                        children: const [TableDepartementBudget()],
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}