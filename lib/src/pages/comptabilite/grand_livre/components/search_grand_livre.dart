import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/grand_livre_model.dart';
import 'package:fokad_admin/src/pages/comptabilite/grand_livre/components/table_grand_livre.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/comptes_dropdown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class SearchGrandLivre extends StatefulWidget {
  const SearchGrandLivre({Key? key}) : super(key: key);

  @override
  State<SearchGrandLivre> createState() => _SearchGrandLivreState();
}

class _SearchGrandLivreState extends State<SearchGrandLivre> {
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
  String? comptesDebitController;
  String? comptesCreditController;
  final TextEditingController dateStartController = TextEditingController();
  final TextEditingController dateEndController = TextEditingController();

  @override
  void dispose() {
    dateStartController.dispose();
    dateEndController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Card(
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.all(p16),
            width: (Responsive.isDesktop(context))
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: p50),
                  const TitleWidget(
                      title: "Trouvrez le compte plus rapidement ..."),
                  const SizedBox(height: p30),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [classDebitWidget(), compteDebitWidget()],
                        ),
                      ),
                      const SizedBox(width: p20),
                      Expanded(
                        child: Column(
                          children: [
                            dateStartWidget(),
                            dateEndWidget(),
                          ],
                        ),
                      )
                    ],
                  ),
                  BtnWidget(
                      title: "Recherche",
                      press: () {
                        setState(() {
                          isLoading = true;
                        });
                        final form = _formKey.currentState!;
                        // if (form.validate()) {
                        // search();
                        // form.reset();
                        // }
                        search().then((value) {
                          setState(() {
                            isLoading = false;
                          });
                        });
                        form.reset();
                      },
                      isLoading: isLoading)
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget classDebitWidget() {
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
          labelText: 'Comptes',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          // contentPadding: const EdgeInsets.only(left: 5.0),
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

  
  Widget dateStartWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'De ...',
          ),
          controller: dateStartController,
          firstDate: DateTime(1930),
          lastDate: DateTime(2100),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget dateEndWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'A ...',
          ),
          controller: dateEndController,
          firstDate: DateTime(1930),
          lastDate: DateTime(2100),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Future<void> search() async {
    final grandLivreModel = GrandLivreModel(
        comptedebit: (comptesDebitController == "")
            ? ""
            : comptesDebitController.toString(), 
        dateStart: DateTime.parse((dateStartController.text == "")
            ? "2021-12-31 00:00:00"
            : dateStartController.text),
        dateEnd: DateTime.parse((dateEndController.text == "")
            ? "2099-12-31 00:00:00"
            : dateEndController.text));
    Navigator.of(context).pushNamed(
        ComptabiliteRoutes.comptabiliteGrandLivreSearch,
        arguments: grandLivreModel);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            TableGrandLivre(grandLivreModel: grandLivreModel)));
  }
}
