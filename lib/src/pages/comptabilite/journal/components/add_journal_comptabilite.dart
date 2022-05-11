import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/comptes_dropdown.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:routemaster/routemaster.dart';

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
    return addDataWidget();
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
                          style: bodyLarge
                              .copyWith(fontWeight: FontWeight.bold))),
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
                  SizedBox(
                    height: 50.0,
                    width: 100.0, child: numeroOperationWidget()),
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
                            SizedBox(
                              height: 50.0,
                              child: classDebitWidget()),
                            SizedBox(
                              height: 50.0,
                              child: compteDebitWidget()),
                            SizedBox(
                              height: 50.0,
                              child: montantDebitWidget())
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
                      child: const Text('Soumettre')),
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
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'N°',
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
            comptesDebitList = class1Dropdown;
          } else if (value == "Classe_2_Comptes_Actif_immobilise") {
            comptesDebitList = class2Dropdown;
          } else if (value == "Classe_3_Comptes_de_stocks") {
            comptesDebitList = class3Dropdown;
          } else if (value == "Classe_4_Comptes_de_tiers") {
            comptesDebitList = class4Dropdown;
          } else if (value == "Classe_5_Comptes_de_tresorerie") {
            comptesDebitList = class5Dropdown;
          } else if (value ==
              "Classe_6_Comptes_de_charges_des_activites_ordinaires") {
            comptesDebitList = class6Dropdown;
          } else if (value ==
              "Classe_7_Comptes_de_produits_des_activites_ordinaires") {
            comptesDebitList = class7Dropdown;
          } else if (value ==
              "Classe_8_Comptes_des_autres_charges_et_des_autres_produits") {
            comptesDebitList = class8Dropdown;
          } else if (value ==
              "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion") {
            comptesDebitList = class9Dropdown;
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
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        // value: comptesActifControllerList[index],
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
        validator: (value) => value == null ? "Select compte" : null,
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
            comptesCreditList = class1Dropdown;
          } else if (value == "Classe_2_Comptes_Actif_immobilise") {
            comptesCreditList = class2Dropdown;
          } else if (value == "Classe_3_Comptes_de_stocks") {
            comptesCreditList = class3Dropdown;
          } else if (value == "Classe_4_Comptes_de_tiers") {
            comptesCreditList = class4Dropdown;
          } else if (value == "Classe_5_Comptes_de_tresorerie") {
            comptesCreditList = class5Dropdown;
          } else if (value ==
              "Classe_6_Comptes_de_charges_des_activites_ordinaires") {
            comptesCreditList = class6Dropdown;
          } else if (value ==
              "Classe_7_Comptes_de_produits_des_activites_ordinaires") {
            comptesCreditList = class7Dropdown;
          } else if (value ==
              "Classe_8_Comptes_des_autres_charges_et_des_autres_produits") {
            comptesCreditList = class8Dropdown;
          } else if (value ==
              "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion") {
            comptesCreditList = class9Dropdown;
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
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        // value: comptesActifControllerList[index],
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
        validator: (value) => value == null ? "Select compte" : null,
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
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'TVA en %',
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

  Widget montantDebitWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: montantDebitController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Montant débit',
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

  Widget montantCreditWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: montantCreditController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Montant crédit',
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
      approbationDG: '-',
      signatureDG: '-',
      signatureJustificationDG: '-',
      approbationDD: '-',
      signatureDD: '-',
      signatureJustificationDD: '-',
      signature: signature.toString(),
      created: DateTime.now()
    );
    await JournalApi().insertData(journalModel);
    Routemaster.of(context).replace(ComptabiliteRoutes.comptabiliteJournal);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
