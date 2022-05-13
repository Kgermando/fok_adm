import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class AjoutLigneBudgetaire extends StatefulWidget {
  const AjoutLigneBudgetaire({Key? key, required this.departementBudgetModel})
      : super(key: key);
  final DepartementBudgetModel departementBudgetModel;

  @override
  State<AjoutLigneBudgetaire> createState() => _AjoutLigneBudgetaireState();
}

class _AjoutLigneBudgetaireState extends State<AjoutLigneBudgetaire> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController nomLigneBudgetaireController = TextEditingController();
  TextEditingController departementController = TextEditingController();
  TextEditingController periodeBudgetController = TextEditingController();
  TextEditingController uniteChoisieController = TextEditingController();
  TextEditingController nombreUniteController = TextEditingController();
  TextEditingController coutUnitaireController = TextEditingController();
  TextEditingController coutTotalController = TextEditingController();
  TextEditingController caisseController = TextEditingController();
  TextEditingController banqueController = TextEditingController();
  TextEditingController finPropreController = TextEditingController();
  TextEditingController finExterieurController = TextEditingController();

  @override
  initState() {
    getData();
    setState(() {
      departementController = TextEditingController(
          text: widget.departementBudgetModel.departement);
      periodeBudgetController = TextEditingController(
          text: DateFormat("dd-MM-yyyy")
              .format(widget.departementBudgetModel.periodeFin));
    });
    super.initState();
  }

  @override
  void dispose() {
    nomLigneBudgetaireController.dispose();
    departementController.dispose();
    periodeBudgetController.dispose();
    uniteChoisieController.dispose();
    nombreUniteController.dispose();
    coutUnitaireController.dispose();
    coutTotalController.dispose();
    caisseController.dispose();
    banqueController.dispose();
    finPropreController.dispose();
    finExterieurController.dispose();

    super.dispose();
  }

  String? signature;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      signature = userModel.matricule;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ),
                          const SizedBox(width: p10),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Ajout Ligne Budgetaire',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addPageWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: SizedBox(
                width: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width,
                child: ListView(
                  controller: _controllerScroll,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleWidget(title: "Ligne Budgetaire"),
                        PrintWidget(onPressed: () {})
                      ],
                    ),
                    const SizedBox(
                      height: p30,
                    ),
                    Row(
                      children: [
                        Expanded(child: nomLigneBudgetaireWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: departementWidget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: periodeBudgetWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: uniteChoisieWidget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: nombreUniteWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: coutUnitaireWidget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: coutTotalWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: caisseWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: banqueWidget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: finPropreWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: finExterieurWidget())
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Soumettre',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submit();
                            form.reset();
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nomLigneBudgetaireWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomLigneBudgetaireController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Linge budgetaire',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget departementWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: departementController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Département',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget periodeBudgetWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: periodeBudgetController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Periode de fin',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget uniteChoisieWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: uniteChoisieController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Unité Choisie',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget nombreUniteWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nombreUniteController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nombre Unité',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget coutUnitaireWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: coutUnitaireController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Cout Unitaire',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget coutTotalWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: coutTotalController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Coût Total',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget caisseWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: caisseController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Caisse',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget banqueWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: banqueController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Banque',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget finPropreWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: finPropreController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Fond Propre',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget finExterieurWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: finExterieurController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'fond Exterieur',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Future<void> submit() async {
    final ligneBudgetaireModel = LigneBudgetaireModel(
        nomLigneBudgetaire: nomLigneBudgetaireController.text,
        departement: departementController.text,
        periodeBudget: periodeBudgetController.text,
        uniteChoisie: uniteChoisieController.text,
        nombreUnite: nombreUniteController.text,
        coutUnitaire: coutUnitaireController.text,
        coutTotal: coutTotalController.text,
        caisse: caisseController.text,
        banque: banqueController.text,
        finPropre: finPropreController.text,
        finExterieur: finExterieurController.text,
        approbationDG: '-',
        signatureDG: '-',
        signatureJustificationDG: '-',
        approbationFin: '-',
        signatureFin: '-',
        signatureJustificationFin: '-',
        approbationBudget: '-',
        signatureBudget: '-',
        signatureJustificationBudget: '-',
        approbationDD: '-',
        signatureDD: '-',
        signatureJustificationDD: '-',
        signature: signature.toString(),
        created: DateTime.now());

    await LIgneBudgetaireApi().insertData(ligneBudgetaireModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
