import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/budgets/autre_dep_budgets/components/table_salaire_budget.dart';
import 'package:fokad_admin/src/pages/budgets/components/ligne_budgetaire.dart';

class AutresDepBudget extends StatefulWidget {
  const AutresDepBudget({Key? key}) : super(key: key);

  @override
  State<AutresDepBudget> createState() => _AutresDepBudgetState();
}

class _AutresDepBudgetState extends State<AutresDepBudget> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenBudget1 = false;
  bool isOpenBudget2 = false;

  int nonPaye = 0;
  int nbrBudget = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    List<PaiementSalaireModel?> dataList =
        await PaiementSalaireApi().getAllData();
    List<LigneBudgetaireModel?> dataLigneBudgetaireList =
        await LIgneBudgetaireApi().getAllData();
    setState(() {
      nonPaye = dataList
          .where((element) => element!.approbationDD != '-')
          .toList()
          .length;
      nbrBudget = dataLigneBudgetaireList
          .where((element) => element!.approbationDD == "-")
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
                      CustomAppbar(
                          title: 'Ligne budgetaire pour départements',
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
                                    "Vous avez $nonPaye dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenBudget1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
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
                                    "Vous avez $nonPaye dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenBudget2 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: const [
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
