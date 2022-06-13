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
  const AjoutLigneBudgetaire({Key? key})
      : super(key: key);

  @override
  State<AjoutLigneBudgetaire> createState() => _AjoutLigneBudgetaireState();
}

class _AjoutLigneBudgetaireState extends State<AjoutLigneBudgetaire> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController nomLigneBudgetaireController = TextEditingController();
  // TextEditingController departementController = TextEditingController();
  // TextEditingController periodeBudgetController = TextEditingController();
  TextEditingController uniteChoisieController = TextEditingController();
  double nombreUniteController = 0.0;
  double coutUnitaireController = 0.0;
  double caisseController = 0.0;
  double banqueController = 0.0;
  double finPropreController = 0.0;

  @override
  initState() {
    getData();
    setState(() {
      // departementController = TextEditingController(
      //     text: widget.departementBudgetModel.departement);
      // periodeBudgetController = TextEditingController(
      //     text: DateFormat("dd-MM-yyyy")
      //         .format(widget.departementBudgetModel.periodeFin));
    });
    super.initState();
  }

  @override
  void dispose() {
    nomLigneBudgetaireController.dispose();
    // departementController.dispose();
    // periodeBudgetController.dispose();
    uniteChoisieController.dispose();

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
    final data = ModalRoute.of(context)!.settings.arguments as DepartementBudgetModel;
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
                        child: addPageWidget(data),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget(DepartementBudgetModel data) {
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
                        Expanded(child: coutTotalValeur()),
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
                        Expanded(child: finExterieurValeur())
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
                            submit(data);
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

  // Widget departementWidget() {
  //   return Container(
  //       margin: const EdgeInsets.only(bottom: p20),
  //       child: TextFormField(
  //         controller: departementController,
  //         keyboardType: TextInputType.text,
  //         decoration: InputDecoration(
  //           border:
  //               OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
  //           labelText: 'Département',
  //         ),
  //         style: const TextStyle(),
  //         validator: (value) {
  //           if (value != null && value.isEmpty) {
  //             return 'Ce champs est obligatoire';
  //           } else {
  //             return null;
  //           }
  //         },
  //       ));
  // }

  // Widget periodeBudgetWidget() {
  //   return Container(
  //       margin: const EdgeInsets.only(bottom: p20),
  //       child: TextFormField(
  //         controller: periodeBudgetController,
  //         keyboardType: TextInputType.text,
  //         decoration: InputDecoration(
  //           border:
  //               OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
  //           labelText: 'Periode de fin',
  //         ),
  //         style: const TextStyle(),
  //         validator: (value) {
  //           if (value != null && value.isEmpty) {
  //             return 'Ce champs est obligatoire';
  //           } else {
  //             return null;
  //           }
  //         },
  //       ));
  // }

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
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
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
          onChanged: (value) => setState(() {
            nombreUniteController = (value == "") ? 1 : double.parse(value);
          }),
        ));
  }

  Widget coutUnitaireWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
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
          onChanged: (value) => setState(() {
            coutUnitaireController = (value == "") ? 1 : double.parse(value);
          }),
        ));
  }

  Widget caisseWidget() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
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
                onChanged: (value) => setState(() {
                  caisseController = (value == "") ? 1 : double.parse(value);
                }),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                    margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
                    child: Text('\$', style: headline6)))
          ],
        ));
  }

  Widget banqueWidget() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
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
                onChanged: (value) => setState(() {
                  banqueController = (value == "") ? 1 : double.parse(value);
                }),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                    margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
                    child: Text('\$', style: headline6)))
          ],
        ));
  }

  Widget finPropreWidget() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Fonds Propres',
                ),
                style: const TextStyle(),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) => setState(() {
                  finPropreController = (value == "") ? 1 : double.parse(value);
                }),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                    margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
                    child: Text('\$', style: headline6)))
          ],
        ));
  }

  Widget coutTotalValeur() {
    final headline6 = Theme.of(context).textTheme.headline6;
    final coutToal = nombreUniteController * coutUnitaireController;
    return Container(
        margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
        child: Text('Coût total: ${NumberFormat.decimalPattern('fr').format(double.parse(coutToal.toStringAsFixed(2)))} \$',
            style: headline6));
  }

  Widget finExterieurValeur() {
    final headline6 = Theme.of(context).textTheme.headline6;
    final coutToal = nombreUniteController * coutUnitaireController;
    final fonds = caisseController + banqueController + finPropreController;
    final fondsAtrouver = coutToal - fonds;
    return Container(
        margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
        child: Text('Reste à trouver: ${NumberFormat.decimalPattern('fr').format(double.parse(fondsAtrouver.toStringAsFixed(2)))} \$',
            style: headline6!.copyWith(color: Colors.red.shade700)));
  }

  Future<void> submit(DepartementBudgetModel data) async {
    final coutToal = nombreUniteController * coutUnitaireController;
    final fonds = caisseController + banqueController + finPropreController;
    final fondsAtrouver = coutToal - fonds;

    final ligneBudgetaireModel = LigneBudgetaireModel(
        nomLigneBudgetaire: nomLigneBudgetaireController.text,
        departement: data.departement,
        periodeBudget: data.periodeDebut.toIso8601String(),
        uniteChoisie: uniteChoisieController.text,
        nombreUnite: nombreUniteController.toString(),
        coutUnitaire: coutUnitaireController.toString(),
        coutTotal: coutToal.toString(),
        caisse: caisseController.toString(),
        banque: banqueController.toString(),
        finPropre: finPropreController.toString(),
        finExterieur: fondsAtrouver.toString(),
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
