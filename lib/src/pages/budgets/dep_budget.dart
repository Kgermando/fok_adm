import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/budgets/components/dep_budgets/table_departement_budget_dd.dart';
import 'package:fokad_admin/src/pages/budgets/components/dep_budgets/table_salaire_budget.dart';
import 'package:fokad_admin/src/pages/budgets/components/ligne_budgetaire.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:provider/provider.dart';

class DepBudget extends StatefulWidget {
  const DepBudget({Key? key}) : super(key: key);

  @override
  State<DepBudget> createState() => _DepBudgetState();
}

class _DepBudgetState extends State<DepBudget> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenBudget1 = false;
  bool isOpenBudget2 = false;

  int nonPaye = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    // UserModel userLoggIn = await AuthApi().getUserId();
    List<PaiementSalaireModel?> dataList =
        await PaiementSalaireApi().getAllData();
    setState(() {
      nonPaye = dataList
          .where((element) => element!.approbationDD != '-')
          .toList()
          .length;
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
                       CustomAppbar(title: 'Département de finance',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                              color: const Color.fromARGB(255, 126, 170, 214),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title:
                                    Text('Dossier Salaires', style: headline6),
                                subtitle: Text(
                                    "Ces dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenBudget1 = !val;
                                  });
                                },
                                trailing: Row(
                                  children: [
                                    Badge(
                                      elevation: 10,
                                      badgeContent: Text(nonPaye.toString()),
                                      position: const BadgePosition(top: 20.0),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                children: const [TableSalaireBudget()],
                              ),
                            ),
                            Card(
                              color: const Color.fromARGB(255, 126, 170, 214),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title: Text('Dossier budgetaire',
                                    style: headline6),
                                subtitle: Text(
                                    "Ces dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenBudget2 = !val;
                                  });
                                },
                                trailing: Row(
                                  children: [
                                    Badge(
                                      elevation: 10,
                                      badgeContent: Text(nonPaye.toString()),
                                      position: const BadgePosition(top: 20.0),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                children: const [
                                  TableDepartementBudgetDD(),
                                  LigneBudgetaire()
                                ],
                              ),
                            ),
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
