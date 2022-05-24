import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/budgets/table_departement_budget_dd.dart';

class BudgetsAdmin extends StatefulWidget {
  const BudgetsAdmin({Key? key}) : super(key: key);

  @override
  State<BudgetsAdmin> createState() => _BudgetsAdminState();
}

class _BudgetsAdminState extends State<BudgetsAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenBudget = false;

  int budgetCount = 0;

  @override
  initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    List<LigneBudgetaireModel?> dataLigneBudgetaireList =
        await LIgneBudgetaireApi().getAllData();
    setState(() {
      budgetCount = dataLigneBudgetaireList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                      CustomAppbar(
                          title: 'Budgets', controllerMenu: () => _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                                color: Colors.blue.shade700,
                                child: ExpansionTile(
                                  leading: const Icon(Icons.folder, color: Colors.white),
                                  title:
                                      Text('Dossier Budgets', style: headline6!.copyWith(color: Colors.white)),
                                  subtitle: Text(
                                      "Vous avez $budgetCount dossiers necessitent votre approbation",
                                      style: bodyMedium!
                                          .copyWith(color: Colors.white)),
                                  initiallyExpanded: false,
                                  onExpansionChanged: (val) {
                                    setState(() {
                                      isOpenBudget = !val;
                                    });
                                  },
                                  trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                  children: const [TableDepartementBudgetDG()],
                                )),
                          ],
                        ),
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
