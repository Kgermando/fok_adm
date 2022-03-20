import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/bilan_model.dart';
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

class BilanComptabilite extends StatefulWidget {
  const BilanComptabilite({Key? key}) : super(key: key);

  @override
  State<BilanComptabilite> createState() => _BilanComptabiliteState();
}

class _BilanComptabiliteState extends State<BilanComptabilite> {
  final controller = ScrollController();

  bool isLoading = false;

  final TextEditingController titleBilanController =
      TextEditingController();
  final TextEditingController comptesController = TextEditingController();
  final TextEditingController intituleController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController typeBilanController = TextEditingController();

  @override
  void dispose() {
    titleBilanController.dispose();
    comptesController.dispose();
    intituleController.dispose();
    montantController.dispose();
    montantController.dispose();
    typeBilanController.dispose();
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
                      const CustomAppbar(title: 'Bilan'),
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: const [
                                  BarChartWidget(),
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
                              const TitleWidget(
                                  title: 'Nouveau Bilan'),
                              PrintWidget(onPressed: () {})
                            ],
                          ),
                          const SizedBox(
                            height: p20,
                          ),
                          Row(
                            children: [
                              Expanded(child: titleBilanWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: comptesWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: intituleWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: montantWidget())
                            ],
                          ),
                          typeBilanWidget(),
                          const SizedBox(
                            height: p20,
                          ),
                          BtnWidget(
                              title: 'Soumettre',
                              isLoading: isLoading,
                              press: () {})
                        ],
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  Widget titleBilanWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: titleBilanController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Titre du bilan',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget comptesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: comptesController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Comptes',
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

  Widget montantWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: montantController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Montant',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget typeBilanWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: typeBilanController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Type de bilan',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Future submit() async {
    final bilanModel = BilanModel(
      titleBilan: titleBilanController.text,
      comptes: comptesController.text,
      intitule: intituleController.text,
      montant: montantController.text,
      typeBilan: typeBilanController.text,
      date: DateTime.now(),
    );
  }
}
