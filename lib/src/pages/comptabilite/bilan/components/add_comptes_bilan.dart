import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_actif_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_passif_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/bilan_model.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_actif_model.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_passif_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/comptes_dropdown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class AddCompteBilan extends StatefulWidget {
  const AddCompteBilan({Key? key}) : super(key: key);

  @override
  State<AddCompteBilan> createState() => _AddCompteBilanState();
}

class _AddCompteBilanState extends State<AddCompteBilan> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _actifFormKey = GlobalKey<FormState>();
  final _passifFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isLoadingActif = false;
  bool isLoadingPassif = false;
  bool isLoadingDelete = false;

  String? comptesActifValue;
  String? comptesPassifValue;
  TextEditingController montantActifController = TextEditingController();
  TextEditingController montantPassifController = TextEditingController();
  bool statut = false;

  List<String> comptesActifList = [];
  List<String> comptesPassifList = [];

  final comptesDropdown = ComptesDropdown().classCompte;
  final classActiveCompte = ComptesDropdown().classCompte;
  final classPassiveCompte = ComptesDropdown().classCompte;
  final class1Dropdown = ComptesDropdown().classe1compte;
  final class2Dropdown = ComptesDropdown().classe2compte;
  final class3Dropdown = ComptesDropdown().classe3compte;
  final class4Dropdown = ComptesDropdown().classe4compte;
  final class5Dropdown = ComptesDropdown().classe5compte;
  final class6Dropdown = ComptesDropdown().classe6compte;
  final class7Dropdown = ComptesDropdown().classe7compte;
  final class8Dropdown = ComptesDropdown().classe8compte;
  final class9Dropdown = ComptesDropdown().classe9compte;

  Timer? timer;
  @override
  initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getData();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    montantActifController.dispose();
    montantPassifController.dispose();
    super.dispose();
  }

  List<CompteActifModel> compteActifList = [];
  List<ComptePassifModel> comptePassifList = [];
  List<CompteActifModel> compteActifFilter = [];
  List<ComptePassifModel> comptePassifFilter = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var compteActif = await CompteActifApi().getAllData();
    var comptePassif = await ComptePassifApi().getAllData();
    if (!mounted) return;
    setState(() {
      user = userModel;
      compteActifFilter = compteActif;
      comptePassifFilter = comptePassif;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bilanModel = ModalRoute.of(context)!.settings.arguments as BilanModel;
    compteActifList = compteActifFilter
        .where((element) =>
            element.reference.microsecondsSinceEpoch ==
            bilanModel.createdRef.microsecondsSinceEpoch)
        .toList();
    comptePassifList = comptePassifFilter
        .where((element) =>
            element.reference.microsecondsSinceEpoch ==
            bilanModel.createdRef.microsecondsSinceEpoch)
        .toList();
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
                          const SizedBox(
                            width: p10,
                          ),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Nouveau bilan',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: addPageWidget(bilanModel),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget(BilanModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p16),
            child: SizedBox(
              width: Responsive.isDesktop(context)
                  ? MediaQuery.of(context).size.width / 1.5
                  : MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TitleWidget(title: data.titleBilan),
                    ],
                  ),
                  const SizedBox(
                    height: p20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Text("Actifs",
                              textAlign: TextAlign.center,
                              style: headline6!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: p20,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 1.8,
                              width: double.infinity,
                              child:  Column(
                                children: [
                                  for (var item in compteActifList)
                                    tableWidget(
                                        'Actif', item.comptes, item.montant),
                                  const SizedBox(height: p20),
                                  compteActifWidget(data),
                                ],
                              )),
                        ],
                      )),
                      const SizedBox(
                        width: p20,
                      ),
                      Expanded(
                          child: Column(children: [
                        Text("Passifs",
                            textAlign: TextAlign.center,
                            style: headline6.copyWith(
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: p20,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 1.8,
                            width: double.infinity,
                            child: Column(
                              children: [
                                for (var item in comptePassifList)
                                  tableWidget(
                                      'Passif', item.comptes, item.montant),
                                const SizedBox(height: p20),
                                comptePassifWidget(data),
                              ],
                            )),
                      ]))
                    ],
                  ),
                  const SizedBox(
                    height: p20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget tableWidget(String type, String comptes, String montant) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Table(
      border: TableBorder.all(color: Colors.amber.shade700),
      columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(1)},
      children: [
        TableRow(children: [
          Container(
            padding: const EdgeInsets.all(p10),
            child: SelectableText(comptes,
                textAlign: TextAlign.start, style: bodyMedium),
          ),
          Container(
            padding: const EdgeInsets.all(p10),
            child: SelectableText(
                "${NumberFormat.decimalPattern('fr').format(double.parse(montant))} \$",
                textAlign: TextAlign.center,
                style: bodyMedium),
          ),
        ])
      ],
    );
  }

  // Widget detailComptes(String type, String comptes, String montant) {
  //   final bodyMedium = Theme.of(context).textTheme.bodyMedium;
  //   return Row(
  //     children: [
  //       Expanded(
  //         flex: 3,
  //         child: Container(
  //           decoration: BoxDecoration(
  //               border: Border(
  //             bottom: BorderSide(
  //               color: Colors.amber.shade700,
  //               width: 2,
  //             ),
  //           )),
  //           child: SelectableText(comptes,
  //               textAlign: TextAlign.start, style: bodyMedium),
  //         ),
  //       ),
  //       Expanded(
  //         flex: 1,
  //         child: Container(
  //           decoration: BoxDecoration(
  //               border: Border(
  //             left: BorderSide(
  //               color: Colors.amber.shade700,
  //               width: 2,
  //             ),
  //             bottom: BorderSide(
  //               color: Colors.amber.shade700,
  //               width: 2,
  //             ),
  //           )),
  //           child: SelectableText(
  //               "${NumberFormat.decimalPattern('fr').format(double.parse(montant))} \$",
  //               textAlign: TextAlign.center,
  //               style: bodyMedium),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget compteActifWidget(BilanModel data) {
    return Form(
      key: _actifFormKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: p20),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Classe des comptes',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                contentPadding: const EdgeInsets.only(left: 5.0),
              ),
              // value: compteClassActifDrop,
              isExpanded: true,
              items: comptesDropdown
                  .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toSet()
                  .toList(),
              onChanged: (value) {
                if (value == "Classe_1_Comptes_de_ressources_durables") {
                  comptesActifList = class1Dropdown;
                } else if (value == "Classe_2_Comptes_Actif_immobilise") {
                  comptesActifList = class2Dropdown;
                } else if (value == "Classe_3_Comptes_de_stocks") {
                  comptesActifList = class3Dropdown;
                } else if (value == "Classe_4_Comptes_de_tiers") {
                  comptesActifList = class4Dropdown;
                } else if (value == "Classe_5_Comptes_de_tresorerie") {
                  comptesActifList = class5Dropdown;
                } else if (value ==
                    "Classe_6_Comptes_de_charges_des_activites_ordinaires") {
                  comptesActifList = class6Dropdown;
                } else if (value ==
                    "Classe_7_Comptes_de_produits_des_activites_ordinaires") {
                  comptesActifList = class7Dropdown;
                } else if (value ==
                    "Classe_8_Comptes_des_autres_charges_et_des_autres_produits") {
                  comptesActifList = class8Dropdown;
                } else if (value ==
                    "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion") {
                  comptesActifList = class9Dropdown;
                } else {
                  comptesActifList = [];
                }
                setState(() {});
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: p20),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Comptes',
                        labelStyle: const TextStyle(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        contentPadding: const EdgeInsets.only(left: 5.0),
                      ),
                      // value: comptesActifControllerList[index],
                      isExpanded: true,
                      items: comptesActifList
                          .map((String? value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value!),
                            );
                          })
                          .toSet()
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          comptesActifValue = value!;
                        });
                      },
                    ),
                  )),
              const SizedBox(width: p10),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: montantActifController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: 'Montant \$',
                              ),
                              style: const TextStyle(),
                            )),
                      ),
                      const SizedBox(width: p20),
                      Expanded(
                          flex: 1,
                          child: Text("\$",
                              style: Theme.of(context).textTheme.headline6))
                    ],
                  ))
            ],
          ),
          const SizedBox(height: p20),
          BtnWidget(
              title: "Soumettre l'actif",
              isLoading: isLoadingActif,
              press: () {
                final form = _actifFormKey.currentState!;
                if (form.validate()) {
                  submitCompteActif(data).then((value) {
                    setState(() {
                      isLoadingActif = false;
                    });
                  });
                  form.reset();
                }
              })
        ],
      ),
    );
  }

  Widget comptePassifWidget(BilanModel data) {
    return Form(
      key: _passifFormKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: p20),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Classe des comptes',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                contentPadding: const EdgeInsets.only(left: 5.0),
              ),
              // value: compteClassActifDrop,
              isExpanded: true,
              items: classPassiveCompte.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                if (value == "Classe_1_Comptes_de_ressources_durables") {
                  comptesPassifList = class1Dropdown;
                } else if (value == "Classe_2_Comptes_Actif_immobilise") {
                  comptesPassifList = class2Dropdown;
                } else if (value == "Classe_3_Comptes_de_stocks") {
                  comptesPassifList = class3Dropdown;
                } else if (value == "Classe_4_Comptes_de_tiers") {
                  comptesPassifList = class4Dropdown;
                } else if (value == "Classe_5_Comptes_de_tresorerie") {
                  comptesPassifList = class5Dropdown;
                } else if (value ==
                    "Classe_6_Comptes_de_charges_des_activites_ordinaires") {
                  comptesPassifList = class6Dropdown;
                } else if (value ==
                    "Classe_7_Comptes_de_produits_des_activites_ordinaires") {
                  comptesPassifList = class7Dropdown;
                } else if (value ==
                    "Classe_8_Comptes_des_autres_charges_et_des_autres_produits") {
                  comptesPassifList = class8Dropdown;
                } else if (value ==
                    "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion") {
                  comptesPassifList = class9Dropdown;
                } else {
                  comptesPassifList = [];
                }

                setState(() {});
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: p20),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Comptes',
                        labelStyle: const TextStyle(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        contentPadding: const EdgeInsets.only(left: 5.0),
                      ),
                      // value: comptesPassifControllerList[index],
                      isExpanded: true,
                      items: comptesPassifList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          comptesPassifValue = value!;
                        });
                      },
                    ),
                  )),
              const SizedBox(width: p10),
              Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: montantPassifController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: 'Montant \$',
                              ),
                              style: const TextStyle(),
                            )),
                      ),
                      const SizedBox(width: p20),
                      Expanded(
                          flex: 1,
                          child: Text("\$",
                              style: Theme.of(context).textTheme.headline6))
                    ],
                  )),
            ],
          ),
          const SizedBox(height: p20),
          BtnWidget(
              title: "Soumettre le passif",
              isLoading: isLoadingPassif,
              press: () {
                final form = _passifFormKey.currentState!;
                if (form.validate()) {
                  submitComptePassif(data).then((value) {
                    setState(() {
                      isLoadingPassif = false;
                    });
                  });
                  form.reset();
                }
              })
        ],
      ),
    );
  }

  Future<void> submitCompteActif(BilanModel data) async {
    final bilan = CompteActifModel(
        reference: data.createdRef,
        comptes: comptesActifValue.toString(),
        montant: montantActifController.text);
    await CompteActifApi().insertData(bilan);
    // Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitComptePassif(BilanModel data) async {
    final bilan = ComptePassifModel(
        reference: data.createdRef,
        comptes: comptesPassifValue.toString(),
        montant: montantPassifController.text);
    await ComptePassifApi().insertData(bilan);
    // Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
