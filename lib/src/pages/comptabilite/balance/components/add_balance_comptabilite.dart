import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/balance_compte_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/balance_comptes_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/comptes_dropdown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddBalanceComptabilite extends StatefulWidget {
  const AddBalanceComptabilite({Key? key}) : super(key: key);

  @override
  State<AddBalanceComptabilite> createState() => _AddBalanceComptabiliteState();
}

class _AddBalanceComptabiliteState extends State<AddBalanceComptabilite> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); 
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  String? comptes;
  TextEditingController montantDebitController = TextEditingController();
  TextEditingController montantCreditController = TextEditingController();
  bool statut = false;

  List<String> comptesList = [];
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


  @override
  initState() {
    getData();
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
    titleController.dispose();
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
                                  title: 'Nouveau balance',
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
                        TitleWidget(title: "Ajout Balance"),
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    titleBilanWidget(),
                    const SizedBox(
                      width: p20,
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
          controller: titleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Titre de la balance',
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

  Widget comptesBalanceWidget() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: p20),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Classe des comptes',
              labelStyle: const TextStyle(),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
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
                comptesList = class1Dropdown;
              } else if (value == "Classe_2_Comptes_Actif_immobilise") {
                comptesList = class2Dropdown;
              } else if (value == "Classe_3_Comptes_de_stocks") {
                comptesList = class3Dropdown;
              } else if (value == "Classe_4_Comptes_de_tiers") {
                comptesList = class4Dropdown;
              } else if (value == "Classe_5_Comptes_de_tresorerie") {
                comptesList = class5Dropdown;
              } else if (value ==
                  "Classe_6_Comptes_de_charges_des_activites_ordinaires") {
                comptesList = class6Dropdown;
              } else if (value ==
                  "Classe_7_Comptes_de_produits_des_activites_ordinaires") {
                comptesList = class7Dropdown;
              } else if (value ==
                  "Classe_8_Comptes_des_autres_charges_et_des_autres_produits") {
                comptesList = class8Dropdown;
              } else if (value ==
                  "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion") {
                comptesList = class9Dropdown;
              } else {
                comptesList = [];
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
                    items: comptesList
                        .map((String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value!),
                          );
                        })
                        .toSet()
                        .toList(),
                    validator: (value) =>
                        value == null ? "Select accréditation" : null,
                    onChanged: (value) {
                      setState(() {
                        comptes = value!;
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
                            controller: montantDebitController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelText: 'Débit \$',
                            ),
                            style: const TextStyle(),
                            // validator: (value) {
                            //   if (value != null && value.isEmpty) {
                            //     return 'Ce champs est obligatoire';
                            //   } else {
                            //     return null;
                            //   }
                            // },
                          )),
                    ),
                    const SizedBox(width: p20),
                    Expanded(
                      flex: 3,
                      child: Container(
                          margin: const EdgeInsets.only(bottom: p20),
                          child: TextFormField(
                            controller: montantCreditController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            labelText: ' Crédit \$',
                            ),
                            style: const TextStyle(),
                            // validator: (value) {
                            //   if (value != null && value.isEmpty) {
                            //     return 'Ce champs est obligatoire';
                            //   } else {
                            //     return null;
                            //   }
                            // },
                          )),
                    ),
                  ],
                ))
          ],
        ), 
      ],
    );
  }

  Future<void> submit() async { 
    final balance = BalanceCompteModel(
        title: titleController.text,
        statut: 'false',
        signature: user!.matricule.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now());
    await BalanceCompteApi().insertData(balance);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
