import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/budgets/ligne_budgetaire_admin.dart';

class BudgetsAdmin extends StatefulWidget {
  const BudgetsAdmin({Key? key}) : super(key: key);

  @override
  State<BudgetsAdmin> createState() => _BudgetsAdminState();
}

class _BudgetsAdminState extends State<BudgetsAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenBudget = false;

  int nbrBudget = 0;

  @override
  initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    List<LigneBudgetaireModel?> dataLigneBudgetaireList =
        await LIgneBudgetaireApi().getAllData();
    setState(() {
      nbrBudget = dataLigneBudgetaireList
          .where((element) => element!.approbationDG == "-")
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
                          title: 'Budgets Admin', controllerMenu: () => _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                                color: const Color.fromARGB(255, 117, 190, 121),
                                child: ExpansionTile(
                                  leading: const Icon(Icons.folder),
                                  title:
                                      Text('Dossier Budgets', style: headline6),
                                  subtitle: Text(
                                      "Ces dossiers necessitent votre approbation",
                                      style: bodyMedium),
                                  initiallyExpanded: false,
                                  onExpansionChanged: (val) {
                                    setState(() {
                                      isOpenBudget = !val;
                                    });
                                  },
                                  trailing: Row(
                                    children: [
                                      Badge(
                                        elevation: 10,
                                        badgeContent:
                                            Text(nbrBudget.toString()),
                                        position:
                                            const BadgePosition(top: 20.0),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                  children: const [LigneBudgetaireAdmin()],
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
