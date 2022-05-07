import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/budgets/components/ligne_budgetaire.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class DetailDepartmentBudget extends StatefulWidget {
  const DetailDepartmentBudget({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailDepartmentBudget> createState() => _DetailDepartmentBudgetState();
}

class _DetailDepartmentBudgetState extends State<DetailDepartmentBudget> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  String departement = "";
  String periodeBudget = "";
  String totalGlobalDispo = "";
  String totalGlobalFinExt = "";
  String totalGlobalPrevisionel = "";

  Future<void> getData() async {
    DepartementBudgetModel data =
        await DepeartementBudgetApi().getOneData(widget.id);
    setState(() {
      departement = data.departement;
      periodeBudget = data.periodeBudget;
      totalGlobalDispo = data.totalGlobalDispo;
      totalGlobalFinExt = data.totalGlobalFinExt;
      totalGlobalPrevisionel = data.totalGlobalPrevisionel;
    });
  }

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
                    child: FutureBuilder<DepartementBudgetModel>(
                        future: DepeartementBudgetApi().getOneData(widget.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<DepartementBudgetModel> snapshot) {
                          if (snapshot.hasData) {
                            DepartementBudgetModel? departementBudgetModel =
                                snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: p20,
                                      child: IconButton(
                                          onPressed: () =>
                                              Routemaster.of(context).pop(),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: departementBudgetModel!
                                              .departement,
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: pageDetail(departementBudgetModel))
                              ],
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(DepartementBudgetModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: ListView(
            controller: _controllerScroll,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: data.periodeBudget),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              tooltip: 'Modifier',
                              onPressed: () {},
                              icon: const Icon(Icons.edit)),
                          PrintWidget(
                              tooltip: 'Imprimer le document', onPressed: () {})
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yy").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              const LigneBudgetaire(),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(DepartementBudgetModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('departement :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.departement,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Periode Budget :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.periodeBudget,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Total Global Dispoible :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.totalGlobalDispo,
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(color: Colors.blueGrey)),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Total Global Fin à trouver :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.totalGlobalFinExt,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Total Global Previsionel :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.totalGlobalPrevisionel,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }
}
