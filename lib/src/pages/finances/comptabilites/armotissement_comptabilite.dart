import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/amortissement_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/amortissement_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/comptabilites/components/amortissements/table_amortissement.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class AmortissementComptabilite extends StatefulWidget {
  const AmortissementComptabilite({Key? key}) : super(key: key);

  @override
  State<AmortissementComptabilite> createState() =>
      _AmortissementComptabiliteState();
}

class _AmortissementComptabiliteState extends State<AmortissementComptabilite> {
  final controller = ScrollController();
  bool isLoading = false;

  final TextEditingController titleArmotissementController =
      TextEditingController();
  final TextEditingController comptesController = TextEditingController();
  final TextEditingController intituleController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController typeJournalController = TextEditingController();

  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }

  @override
  void dispose() {
    titleArmotissementController.dispose();
    comptesController.dispose();
    intituleController.dispose();
    montantController.dispose();
    montantController.dispose();
    typeJournalController.dispose();
    super.dispose();
  }

  String? matricule;
  int numberItem = 0;

  Future<void> getData() async {
    final userModel = await AuthApi().getUserId();
    final data = await AmortissementApi().getAllData();
    setState(() {
      matricule = userModel.matricule;
      numberItem = data.length;
    });
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
                      const CustomAppbar(title: 'Amortissement'),
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
                            const TableAmortissement()
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
                                  title: 'Nouvelle armotissement'),
                              PrintWidget(onPressed: () {})
                            ],
                          ),
                          const SizedBox(
                            height: p20,
                          ),
                          Row(
                            children: [
                              Expanded(child: titleArmotissementWidget()),
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
                          typeJournalWidget(),
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

  Widget titleArmotissementWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: titleArmotissementController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Titre d\'armotissement',
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

  Widget typeJournalWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: typeJournalController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Type de Journal',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Future submit() async {
    final amortissementModel = AmortissementModel(
        titleArmotissement: titleArmotissementController.text,
        comptes: comptesController.text,
        intitule: intituleController.text,
        montant: montantController.text,
        typeJournal: typeJournalController.text,
        created: DateTime.now(),
        signature: matricule.toString());
    await AmortissementApi().insertData(amortissementModel);
    Routemaster.of(context).replace(FinanceRoutes.comptabiliteAmortissement);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
