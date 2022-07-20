import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/utils/comptes_dropdown.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddJournalComptabilite extends StatefulWidget {
  const AddJournalComptabilite({Key? key}) : super(key: key);

  @override
  State<AddJournalComptabilite> createState() => _AddJournalComptabiliteState();
}

class _AddJournalComptabiliteState extends State<AddJournalComptabilite> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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

  String? comptesDebit;
  String? comptesCredit;
  List<String> comptesDebitList = [];
  List<String> comptesCreditList = [];

  TextEditingController numeroOperationController = TextEditingController();
  TextEditingController libeleController = TextEditingController();
  String? comptesDebitController;
  String? comptesCreditController;
  TextEditingController montantDebitController = TextEditingController();
  TextEditingController montantCreditController = TextEditingController();
  TextEditingController tvaController = TextEditingController();
  TextEditingController remarqueController = TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  String? signature;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      signature = userModel.matricule;
    });
  }

  @override
  void dispose() {
    numeroOperationController.dispose();
    libeleController.dispose();
    montantDebitController.dispose();
    montantCreditController.dispose();
    tvaController.dispose();
    remarqueController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: addDataWidget());
  }

  Widget addDataWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Form(
      key: _formKey,
      child: Card(
        elevation: 10,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                TitleWidget(title: "Insertion d'écriture dans le journal"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(p10),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text("N° operation",
                          textAlign: TextAlign.center,
                          style: bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text("Libele",
                          textAlign: TextAlign.center,
                          style:
                              bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                  const SizedBox(
                    width: p10,
                  ),
                  Expanded(
                      flex: 4,
                      child: Text("Comptes",
                          textAlign: TextAlign.center,
                          style:
                              bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                  const SizedBox(
                    width: p10,
                  ),
                  Expanded(
                      flex: 1,
                      child: Text("TVA en %",
                          textAlign: TextAlign.center,
                          style:
                              bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                  const SizedBox(
                    width: p10,
                  ),
                  Expanded(
                      flex: 3,
                      child: Text("Remarque",
                          textAlign: TextAlign.center,
                          style:
                              bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(p10),
              child: Row(
                children: [
                  SizedBox(width: 100.0, child: numeroOperationWidget()),
                  const SizedBox(
                    width: p10,
                  ),
                  Expanded(flex: 2, child: libeleWidget()),
                  const SizedBox(
                    width: p10,
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            classDebitWidget(),
                            compteDebitWidget(),
                            montantDebitWidget()
                          ],
                        )),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            classCreditWidget(),
                            compteCreditWidget(),
                            montantCreditWidget()
                          ],
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: p10,
                  ),
                  Expanded(flex: 1, child: tvaWidget()),
                  const SizedBox(
                    width: p10,
                  ),
                  Expanded(flex: 3, child: remarqueWidget()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(p10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        final form = _formKey.currentState!;
                        if (form.validate()) {
                          submit();
                          form.reset();
                        }
                      },
                      child: Text('Soumettre',
                          style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget numeroOperationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: numeroOperationController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'N°',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
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

  Widget libeleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: libeleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Libelé',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
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

  Widget classDebitWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Classe',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          // contentPadding: const EdgeInsets.only(left: 5.0),
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
          comptesDebitList.clear();
          if (value == "Classe_1_Comptes_de_ressources_durables") {
            comptesDebitList = class1Dropdown;
            comptesDebitController = comptesDebitList.first;
          } else if (value == "Classe_2_Comptes_Actif_immobilise") {
            comptesDebitList = class2Dropdown;
            comptesDebitController = comptesDebitList.first;
          } else if (value == "Classe_3_Comptes_de_stocks") {
            comptesDebitList = class3Dropdown;
            comptesDebitController = comptesDebitList.first;
          } else if (value == "Classe_4_Comptes_de_tiers") {
            comptesDebitList = class4Dropdown;
            comptesDebitController = comptesDebitList.first;
          } else if (value == "Classe_5_Comptes_de_tresorerie") {
            comptesDebitList = class5Dropdown;
            comptesDebitController = comptesDebitList.first;
          } else if (value ==
              "Classe_6_Comptes_de_charges_des_activites_ordinaires") {
            comptesDebitList = class6Dropdown;
            comptesDebitController = comptesDebitList.first;
          } else if (value ==
              "Classe_7_Comptes_de_produits_des_activites_ordinaires") {
            comptesDebitList = class7Dropdown;
            comptesDebitController = comptesDebitList.first;
          } else if (value ==
              "Classe_8_Comptes_des_autres_charges_et_des_autres_produits") {
            comptesDebitList = class8Dropdown;
            comptesDebitController = comptesDebitList.first;
          } else if (value ==
              "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion") {
            comptesDebitList = class9Dropdown;
            comptesDebitController = comptesDebitList.first;
          } else {
            comptesDebitList = [];
          }
          setState(() {});
        },
      ),
    );
  }

  Widget compteDebitWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Comptes Debit',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          // contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: comptesDebitController,
        isExpanded: true,
        items: comptesDebitList
            .map((String? value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value!),
              );
            })
            .toSet()
            .toList(),
        // validator: (value) => value == null ? "Select compte" : null,
        onChanged: (value) {
          setState(() {
            comptesDebitController = value!;
          });
        },
      ),
    );
  }

  Widget classCreditWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Classe',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          // contentPadding: const EdgeInsets.only(left: 5.0),
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
          comptesCreditList.clear();
          if (value == "Classe_1_Comptes_de_ressources_durables") {
            comptesCreditList = class1Dropdown;
            comptesCreditController = comptesCreditList.first;
          } else if (value == "Classe_2_Comptes_Actif_immobilise") {
            comptesCreditList = class2Dropdown;
            comptesCreditController = comptesCreditList.first;
          } else if (value == "Classe_3_Comptes_de_stocks") {
            comptesCreditList = class3Dropdown;
            comptesCreditController = comptesCreditList.first;
          } else if (value == "Classe_4_Comptes_de_tiers") {
            comptesCreditList = class4Dropdown;
            comptesCreditController = comptesCreditList.first;
          } else if (value == "Classe_5_Comptes_de_tresorerie") {
            comptesCreditList = class5Dropdown;
            comptesCreditController = comptesCreditList.first;
          } else if (value ==
              "Classe_6_Comptes_de_charges_des_activites_ordinaires") {
            comptesCreditList = class6Dropdown;
            comptesCreditController = comptesCreditList.first;
          } else if (value ==
              "Classe_7_Comptes_de_produits_des_activites_ordinaires") {
            comptesCreditList = class7Dropdown;
            comptesCreditController = comptesCreditList.first;
          } else if (value ==
              "Classe_8_Comptes_des_autres_charges_et_des_autres_produits") {
            comptesCreditList = class8Dropdown;
            comptesCreditController = comptesCreditList.first;
          } else if (value ==
              "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion") {
            comptesCreditList = class9Dropdown;
            comptesCreditController = comptesCreditList.first;
          } else {
            comptesCreditList = [];
          }
          setState(() {});
        },
      ),
    );
  }

  Widget compteCreditWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Comptes Crédit',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          // contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: comptesCreditController,
        isExpanded: true,
        items: comptesCreditList
            .map((String? value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value!),
              );
            })
            .toSet()
            .toList(),
        // validator: (value) => value == null ? "Select compte" : null,
        onChanged: (value) {
          setState(() {
            comptesCreditController = value!;
          });
        },
      ),
    );
  }

  Widget tvaWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: tvaController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'TVA en %',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          ),
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget montantDebitWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: montantDebitController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Montant débit',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          ),
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget montantCreditWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: montantCreditController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Montant crédit',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          ),
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget remarqueWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: remarqueController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Remarque',
          ),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 5,
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
    final journalModel = JournalModel(
        numeroOperation: numeroOperationController.text,
        libele: libeleController.text,
        compteDebit: comptesDebitController.toString(),
        montantDebit: montantDebitController.text,
        compteCredit: comptesCreditController.toString(),
        montantCredit: montantCreditController.text,
        tva: tvaController.text,
        remarque: remarqueController.text,
        signature: signature.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now(),
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await JournalApi().insertData(journalModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
