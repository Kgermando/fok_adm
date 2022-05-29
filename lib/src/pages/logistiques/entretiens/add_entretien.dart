import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/entretien_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/entretien_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';


class AddEntretienPage extends StatefulWidget {
  const AddEntretienPage({Key? key}) : super(key: key);

  @override
  State<AddEntretienPage> createState() => _AddEntretienPageState();
}

class _AddEntretienPageState extends State<AddEntretienPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final ScrollController _controllerEtatObjet = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late List<Map<String, dynamic>> _values;
  late String result;

  late int count;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController modeleController = TextEditingController();
  final TextEditingController marqueController = TextEditingController();
  final TextEditingController etatObjetController = TextEditingController();
  final TextEditingController dureeTravauxController = TextEditingController();

  List<TextEditingController> nomObjetControllerList = [];
  List<TextEditingController> coutControllerList = [];
  List<TextEditingController> caracteristiqueControllerList = [];
  List<TextEditingController> observationControllerList = [];

  @override
  void initState() {
    setState(() {
      data();
      count = 0;
      result = '';
      _values = [];
    });
    super.initState();
  }

  @override
  void dispose() {
    nomController.dispose();
    modeleController.dispose();
    marqueController.dispose();
    etatObjetController.dispose();
    dureeTravauxController.dispose();
    for (final controller in nomObjetControllerList) {
      controller.dispose();
    }
    for (final controller in coutControllerList) {
      controller.dispose();
    }
    for (final controller in caracteristiqueControllerList) {
      controller.dispose();
    }
    for (final controller in observationControllerList) {
      controller.dispose();
    }
    super.dispose();
  }

  String? signature;
  Future<void> data() async {
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
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Nouveau entretien',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addDataWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addDataWidget() {
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [PrintWidget(onPressed: () {})],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(child: nomWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: modeleWidget())
                      ],
                    ),
                    etatObjetWidget(),
                    Row(
                      children: [
                        Expanded(child: marqueWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: dureeTravauxWidget())
                      ],
                    ),
                    if (count == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Objets remplacé",
                              style: Theme.of(context).textTheme.bodyLarge),
                          IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  final nomObjet = TextEditingController();
                                  final cout = TextEditingController();
                                  final caracteristique =
                                      TextEditingController();
                                  final observation = TextEditingController();
                                  nomObjetControllerList.add(nomObjet);
                                  coutControllerList.add(cout);
                                  caracteristiqueControllerList
                                      .add(caracteristique);
                                  observationControllerList.add(observation);
                                  count++;
                                });
                              })
                        ],
                      ),
                    SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: objetRemplaceWidget()),
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

  Widget nomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom',
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

  Widget modeleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: modeleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Modèle',
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

  Widget marqueWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: marqueController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Marque',
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

  Widget dureeTravauxWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: dureeTravauxController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Durée Travaux',
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

  Widget etatObjetWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: etatObjetController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Etat Objet',
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

  Widget objetRemplaceWidget() {
    return Scrollbar(
      controller: _controllerEtatObjet,
      isAlwaysShown: true,
      child: ListView.builder(
          controller: _controllerEtatObjet,
          itemCount: count,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectableText('Objet Remplacé',
                        style: Theme.of(context).textTheme.bodyText2),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                final nomObjet = TextEditingController();
                                final cout = TextEditingController();
                                final caracteristique = TextEditingController();
                                final observation = TextEditingController();
                                nomObjetControllerList.add(nomObjet);
                                coutControllerList.add(cout);
                                caracteristiqueControllerList
                                    .add(caracteristique);
                                observationControllerList.add(observation);
                                count++;
                              });
                            },
                            icon: const Icon(Icons.add)),
                        if (count > 0)
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  final nomObjet = TextEditingController();
                                  final cout = TextEditingController();
                                  final caracteristique =
                                      TextEditingController();
                                  final observation = TextEditingController();
                                  nomObjetControllerList.remove(nomObjet);
                                  coutControllerList.remove(cout);
                                  caracteristiqueControllerList
                                      .remove(caracteristique);
                                  observationControllerList.remove(observation);
                                  count--;
                                });
                              },
                              icon: const Icon(Icons.close)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: nomObjetControllerList[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: '${index + 1}. Nom',
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(),
                            ))),
                    const SizedBox(width: p10),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: coutControllerList[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: '${index + 1}. Coût',
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(),
                            )))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: caracteristiqueControllerList[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: '${index + 1}. Caracteristique',
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(),
                            ))),
                    const SizedBox(width: p10),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: observationControllerList[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: '${index + 1}. Observation',
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(),
                            )))
                  ],
                ),
              ],
            );
          }),
    );
  }

  Future<void> submit() async {
    final jsonList = _values.map((item) => jsonEncode(item)).toList();
    final entretienModel = EntretienModel(
        nom: nomController.text,
        modele: modeleController.text,
        marque: marqueController.text,
        etatObjet: etatObjetController.text,
        objetRemplace: jsonList,
        dureeTravaux: dureeTravauxController.text,
        signature: signature.toString(),
        created: DateTime.now());
    await EntretienApi().insertData(entretienModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
