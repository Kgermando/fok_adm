import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/valorisation_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/utils/pluto_grid.dart';
import 'package:fokad_admin/src/widgets/bar_chart_widget.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/pie_chart_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:provider/provider.dart';

class ValorisationComptabilite extends StatefulWidget {
  const ValorisationComptabilite({Key? key}) : super(key: key);

  @override
  State<ValorisationComptabilite> createState() =>
      _ValorisationComptabiliteState();
}

class _ValorisationComptabiliteState extends State<ValorisationComptabilite> {
  final controller = ScrollController();

  final TextEditingController numeroOrdreController = TextEditingController();
  final TextEditingController intituleController = TextEditingController();
  final TextEditingController quantiteController = TextEditingController();
  final TextEditingController prixUnitaireController = TextEditingController();
  final TextEditingController prixTotalController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

  @override
  void dispose() {
    numeroOrdreController.dispose();
    intituleController.dispose();
    quantiteController.dispose();
    prixUnitaireController.dispose();
    prixTotalController.dispose();
    sourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade700,
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                transactionsDialogDonation();
              });
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
                      const CustomAppbar(title: 'Valorisation'),
                      Expanded(
                          child: Scrollbar(
                        controller: controller,
                        child: ListView(
                          controller: controller,
                          children: [
                            const SizedBox(
                              height: p20,
                            ),
                            PrintWidget(onPressed: (() {})),
                            const SizedBox(
                              height: p10,
                            ),
                            SizedBox(
                                height: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    BarChartWidget(),
                                    PieChartWidget()
                                  ],
                                )),
                            const SizedBox(
                              height: p10,
                            ),
                            const ColumnFilteringScreen()
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

  transactionsDialogDonation() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(p8),
                ),
                backgroundColor: Colors.transparent,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(p16),
                    child: SizedBox(
                      width: Responsive.isDesktop(context)
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.width,
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitleWidget(title: 'Nouveau Valorisation'),
                              PrintWidget(onPressed: () {})
                            ],
                          ),
                          const SizedBox(
                            height: p20,
                          ),
                          Row(
                            children: [
                              Expanded(child: numeroOrdreWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: intituleWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: quantiteWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: prixUnitaireWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: prixTotalWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: sourcelWidget())
                            ],
                          ),
                          const SizedBox(
                            height: p20,
                          ),
                          BtnWidget(title: 'Soumettre', press: () {})
                        ],
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  Widget numeroOrdreWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: numeroOrdreController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nuéero d\'ordre',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget intituleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: intituleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Intitulé',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget quantiteWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: quantiteController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Quantité',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget prixUnitaireWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: prixUnitaireController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Prix Unitaire',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget prixTotalWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: prixTotalController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Prix Total',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget sourcelWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: sourceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Source',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Future submit() async {
    final valorisationModel = ValorisationModel(
        numeroOrdre: numeroOrdreController.text,
        intitule: intituleController.text,
        quantite: quantiteController.text,
        prixUnitaire: prixUnitaireController.text,
        prixTotal: prixTotalController.text,
        source: sourceController.text,
        date: DateTime.now(),
    );
  }
}
