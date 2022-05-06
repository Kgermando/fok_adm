import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/bilan_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/bilan_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/comptes_dropdown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:routemaster/routemaster.dart';

class AddBilan extends StatefulWidget {
  const AddBilan({Key? key}) : super(key: key);

  @override
  State<AddBilan> createState() => _AddBilanState();
}

class _AddBilanState extends State<AddBilan> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerActifList = ScrollController();
  final ScrollController _controllerPassifList = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController titleBilanController = TextEditingController();
  List<String> comptesActifControllerList = [];
  List<String> comptesPassifControllerList = [];
  List<TextEditingController> montantActifControllerList = [];
  List<TextEditingController> montantPassifControllerList = [];
  bool statut = false;

  // String? compteClassActifDrop;
  // String? compteClassPassifDrop;
  List<List<String>> comptesActifList = [];
  List<List<String>> comptesPassifList = [];
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

  late List<Map<String, dynamic>> _valuesActif;
  late List<Map<String, dynamic>> _valuesPassif;

  late int countActif;
  late int countPassif;

  @override
  initState() {
    getData();
    countActif = 0;
    countPassif = 0;
    _valuesActif = [];
    _valuesPassif = [];
    super.initState();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  void dispose() {
    titleBilanController.dispose();
    for (final controller in montantActifControllerList) {
      controller.dispose();
    }
    for (final controller in montantPassifControllerList) {
      controller.dispose();
    }
    super.dispose();
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
                                  Routemaster.of(context).pop();
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
    final headline6 = Theme.of(context).textTheme.headline6;
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
                    ? MediaQuery.of(context).size.width / 1.5
                    : MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        TitleWidget(title: "Ajout Bilan"),
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    titleBilanWidget(),
                    const SizedBox(
                      width: p20,
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
                            if (countActif == 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          var comptes = "";
                                          var montant = TextEditingController();
                                          List<String> actifList = [];
                                          comptesActifControllerList
                                              .add(comptes);
                                          montantActifControllerList
                                              .add(montant);
                                           comptesActifList.add(actifList);
                                          countActif++;
                                        });
                                      })
                                ],
                              ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 1.8,
                                width: double.infinity,
                                child: compteMontantActifWidget()),
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
                          if (countPassif == 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        var comptes = "";
                                        var montant = TextEditingController();
                                         List<String> passifList = [];
                                        comptesPassifControllerList
                                            .add(comptes);
                                        montantPassifControllerList
                                            .add(montant);
                                        comptesPassifList.add(passifList);
                                        countPassif++;
                                      });
                                    })
                              ],
                            ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 1.8,
                              width: double.infinity,
                              child: compteMontantPassifWidget()),
                        ]))
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

  Widget titleBilanWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: titleBilanController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Titre du Bilan',
          ),
          keyboardType: TextInputType.text,
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

  Widget compteMontantActifWidget() {
    return Scrollbar(
      controller: _controllerActifList,
      isAlwaysShown: true,
      child: ListView.builder(
          controller: _controllerActifList,
          itemCount: countActif,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (index == index)
                        IconButton(
                            tooltip: "Ajout",
                            onPressed: () {
                              setState(() {
                                var comptes = "";
                                var montant = TextEditingController();
                                List<String> actifList = [];
                                comptesActifControllerList.add(comptes);
                                montantActifControllerList.add(montant);
                                comptesActifList.add(actifList);
                                countActif++;
                                onUpdateActif(
                                    index,
                                    comptesActifControllerList[index],
                                    montantActifControllerList[index].text);
                              });
                            },
                            icon: const Icon(Icons.add)),
                        if (countActif > 0)
                          IconButton(
                              tooltip: "Retirer",
                              onPressed: () {
                                setState(() {
                                  var comptes = "";
                                  var montant = TextEditingController();
                                  List<String> actifList = [];
                                  comptesActifControllerList.remove(comptes);
                                  montantActifControllerList.remove(montant);
                                  comptesActifList.remove(actifList);
                                  countActif--;
                                  // onUpdate(index, agentControllerList[index].text,
                                  //     roleControllerList[index].text);
                                });
                              },
                              icon: const Icon(Icons.close)),
                      ],
                    ),
                  ],
                ),
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
                        comptesActifList[index] = class1Dropdown;
                      } else if (value == "Classe_2_Comptes_Actif_immobilise") {
                        comptesActifList[index] = class2Dropdown;
                      } else if (value == "Classe_3_Comptes_de_stocks") {
                        comptesActifList[index] = class3Dropdown;
                      } else if (value == "Classe_4_Comptes_de_tiers") {
                        comptesActifList[index] = class4Dropdown;
                      } else if (value == "Classe_5_Comptes_de_tresorerie") {
                        comptesActifList[index] = class5Dropdown;
                      } else if (value ==
                          "Classe_6_Comptes_de_charges_des_activites_ordinaires") {
                        comptesActifList[index] = class6Dropdown;
                      } else if (value ==
                          "Classe_7_Comptes_de_produits_des_activites_ordinaires") {
                        comptesActifList[index] = class7Dropdown;
                      } else if (value ==
                          "Classe_8_Comptes_des_autres_charges_et_des_autres_produits") {
                        comptesActifList[index] = class8Dropdown;
                      } else if (value ==
                          "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion") {
                        comptesActifList[index] = class9Dropdown;
                      } else {
                        comptesActifList[index] = [];
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
                            items: comptesActifList[index]
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
                                comptesActifControllerList[index] = value!;
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
                                    controller:
                                        montantActifControllerList[index],
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      labelText: '${index + 1}. Montant \$',
                                    ),
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(),
                                  )),
                            ),
                            const SizedBox(width: p20),
                            Expanded(
                                flex: 1,
                                child: Text("\$",
                                    style:
                                        Theme.of(context).textTheme.headline6))
                          ],
                        ))
                  ],
                ),
              ],
            );
          }),
    );
  }

  compteMontantPassifWidget() {
    return Scrollbar(
      controller: _controllerPassifList,
      isAlwaysShown: true,
      child: ListView.builder(
          controller: _controllerPassifList,
          itemCount: countPassif,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            tooltip: "Ajout",
                            onPressed: () {
                              setState(() {
                                var comptes = "";
                                var montant = TextEditingController();
                                List<String> passifList = [];
                                comptesPassifControllerList.add(comptes);
                                montantPassifControllerList.add(montant);
                                comptesPassifList.add(passifList);
                                countPassif++;
                                onUpdatePassif(
                                    index,
                                    comptesPassifControllerList[index],
                                    montantPassifControllerList[index].text);
                              });
                            },
                            icon: const Icon(Icons.add)),
                        if (countPassif > 0)
                          IconButton(
                              tooltip: "Retirer",
                              onPressed: () {
                                setState(() {
                                  var comptes = "";
                                  var montant = TextEditingController();
                                  List<String> passifList = [];
                                  comptesPassifControllerList.remove(comptes);
                                  montantPassifControllerList.remove(montant);
                                  comptesPassifList.remove(passifList);
                                  countPassif--;
                                  // onUpdate(index, agentControllerList[index].text,
                                  //     roleControllerList[index].text);
                                });
                              },
                              icon: const Icon(Icons.close)),
                      ],
                    ),
                  ],
                ),
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
                        comptesPassifList[index] = class1Dropdown;
                      } else if (value == "Classe_2_Comptes_Actif_immobilise") {
                        comptesPassifList[index] = class2Dropdown;
                      } else if (value == "Classe_3_Comptes_de_stocks") {
                        comptesPassifList[index] = class3Dropdown;
                      } else if (value == "Classe_4_Comptes_de_tiers") {
                        comptesPassifList[index] = class4Dropdown;
                      } else if (value == "Classe_5_Comptes_de_tresorerie") {
                        comptesPassifList[index] = class5Dropdown;
                      } else if (value ==
                          "Classe_6_Comptes_de_charges_des_activites_ordinaires") {
                        comptesPassifList[index] = class6Dropdown;
                      } else if (value ==
                          "Classe_7_Comptes_de_produits_des_activites_ordinaires") {
                        comptesPassifList[index] = class7Dropdown;
                      } else if (value ==
                          "Classe_8_Comptes_des_autres_charges_et_des_autres_produits") {
                        comptesPassifList[index] = class8Dropdown;
                      } else if (value ==
                          "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion") {
                        comptesPassifList[index] = class9Dropdown;
                      } else {
                        comptesPassifList[index] = [];
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
                            items: comptesPassifList[index].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                comptesPassifControllerList[index] = value!;
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
                                    controller:
                                        montantPassifControllerList[index],
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      labelText: '${index + 1}. Montant \$',
                                    ),
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(),
                                  )),
                            ),
                            const SizedBox(width: p20),
                            Expanded(
                                flex: 1,
                                child: Text("\$",
                                    style:
                                        Theme.of(context).textTheme.headline6))
                          ],
                        ))
                  ],
                ),
              ],
            );
          }),
    );
  }

  onUpdateActif(int key, String compte, String montant) {
    int foundKey = -1;
    for (var map in _valuesActif) {
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      _valuesActif.removeWhere((map) {
        return map['id'] == foundKey;
      });
    }
    Map<String, dynamic> json = {
      'id': key,
      'compte': compte,
      'montant': montant
    };
    _valuesActif.add(json);
  }

  onUpdatePassif(int key, String compte, String montant) {
    int foundKey = -1;
    for (var map in _valuesPassif) {
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      _valuesPassif.removeWhere((map) {
        return map['id'] == foundKey;
      });
    }
    Map<String, dynamic> json = {
      'id': key,
      'compte': compte,
      'montant': montant
    };
    _valuesPassif.add(json);
  }

  Future<void> submit() async {
    final jsonActifList = _valuesActif.map((item) => jsonEncode(item)).toList();
    final jsonPassifList =
        _valuesPassif.map((item) => jsonEncode(item)).toList();

    final bilanModel = BilanModel(
        titleBilan: titleBilanController.text,
        comptesActif: jsonActifList,
        comptesPactif: jsonPassifList,
        statut: statut,
        approbationDG: '-',
        signatureDG: '-',
        signatureJustificationDG: '-',
        approbationDD: '-',
        signatureDD: '-',
        signatureJustificationDD: '-',
        signature: user!.matricule.toString(),
        created: DateTime.now());
    await BilanApi().insertData(bilanModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
