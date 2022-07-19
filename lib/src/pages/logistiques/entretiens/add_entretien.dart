import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/entretien_api.dart';
import 'package:fokad_admin/src/api/logistiques/objet_remplace_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/entretien_model.dart';
import 'package:fokad_admin/src/models/logistiques/objet_remplace_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class AddEntretienPage extends StatefulWidget {
  const AddEntretienPage({Key? key}) : super(key: key);

  @override
  State<AddEntretienPage> createState() => _AddEntretienPageState();
}

class _AddEntretienPageState extends State<AddEntretienPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); 
  final _formKey = GlobalKey<FormState>();
  final _formObjetKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isLoadingObjet = false;

  TextEditingController nomController = TextEditingController();
  TextEditingController modeleController = TextEditingController();
  TextEditingController marqueController = TextEditingController();
  String? typeMaintenance;
  TextEditingController dureeTravauxController = TextEditingController();

  TextEditingController nomObjetController = TextEditingController();
  TextEditingController coutController = TextEditingController();
  TextEditingController caracteristiqueController = TextEditingController();
  TextEditingController observationController = TextEditingController();

  Timer? timer;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getDate();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    nomController.dispose();
    modeleController.dispose();
    marqueController.dispose();
    dureeTravauxController.dispose();
    nomObjetController.dispose();
    coutController.dispose();
    caracteristiqueController.dispose();
    observationController.dispose();

    super.dispose();
  }

  int entretiensCount = 0;
  List<ObjetRemplaceModel> objetRemplaceList = [];

  String? signature;
  Future<void> getDate() async {
    UserModel userModel = await AuthApi().getUserId();
    var entretiens = await EntretienApi().getAllData();
    var objetRemplace = await ObjetRemplaceApi().getAllData();
    if (!mounted) return;
    setState(() {
      signature = userModel.matricule;
      entretiensCount = entretiens.length + 1;
      objetRemplaceList = objetRemplace
          .where((element) => element.reference == entretiensCount)
          .toList();
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
                                  title: 'Nouveau entretien / Maintenance',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleWidget(title: "Entretiens & Maintenance"),
                        PrintWidget(onPressed: () {})
                      ],
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
                    // SizedBox(
                    //     height: 400,
                    //     width: double.infinity,
                    //     child: objetRemplaceWidget()),
                    objetRemplaceWidget(),
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
              hintText: 'Samsung G 22, Benz 208'),
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
              hintText: 'Samsung, Mercedes, ...'),
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
    List<String> typeMaintenanceList = [
      'Maintenance curative',
      'Maintenance préventive',
      'Maintenance corrective',
      'Maintenance améliorative'
    ];
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Type de maintenance',
            labelStyle: const TextStyle(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: const EdgeInsets.only(left: 5.0),
          ),
          value: typeMaintenance,
          isExpanded: true,
          items: typeMaintenanceList
              .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toSet()
              .toList(),
          validator: (value) => value == null ? "Select maintenance" : null,
          onChanged: (value) {
            setState(() {
              typeMaintenance = value;
            });
          },
        ));
  }

  Widget objetRemplaceWidget() {
    return Container(
      padding: const EdgeInsets.all(p20),
      color: Colors.blue[100],
      child: Column(
        children: [
          const TitleWidget(title: "Ajouter les objets remplacés"),
          const SizedBox(height: p20),
          tableWidget(),
          Form(
            key: _formObjetKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: nomObjetController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: 'Nom',
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(),
                            ))),
                    const SizedBox(width: p10),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                              margin: const EdgeInsets.only(bottom: p20),
                              child: TextFormField(
                                controller: coutController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  labelText: 'Coût',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
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
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: caracteristiqueController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: 'Caracteristique',
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(),
                            ))),
                    const SizedBox(width: p10),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: observationController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  labelText: 'Observation',
                                  hintText:
                                      'En etat de marche, pause probleme de compatibilité'),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(),
                            )))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isLoadingObjet = true;
                          });
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submitObjetRemplace().then((value) {
                              setState(() {
                                isLoadingObjet = true;
                              });
                            });
                            form.reset();
                          }
                        },
                        icon: const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text("Ajout l'objet",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white))),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tableWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: p20),
      child: Table(
        border: TableBorder.all(color: Colors.amber.shade700),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(4),
          3: FlexColumnWidth(4),
        },
        children: [
          TableRow(children: [
            Container(
              padding: const EdgeInsets.all(p10),
              child: Text("Nom", textAlign: TextAlign.start, style: bodyMedium),
            ),
            Container(
              padding: const EdgeInsets.all(p10),
              child:
                  Text("Coût", textAlign: TextAlign.center, style: bodyMedium),
            ),
            Container(
              padding: const EdgeInsets.all(p10),
              child: Text("Caracteristique",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Container(
              padding: const EdgeInsets.all(p10),
              child: Text("Observation",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
          ]),
          for (var item in objetRemplaceList.where((element) => element.reference == entretiensCount))
            tableDataWidget(
                item.nom, item.cout, item.caracteristique, item.observation)
        ],
      ),
    );
  }

  TableRow tableDataWidget(
      String nom, String cout, String caraterique, String observation) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child:
            SelectableText(nom, textAlign: TextAlign.start, style: bodyMedium),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: SelectableText(
            "${NumberFormat.decimalPattern('fr').format(double.parse(cout))} \$",
            textAlign: TextAlign.center,
            style: bodyMedium),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: SelectableText(caraterique,
            textAlign: TextAlign.start, style: bodyMedium),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: SelectableText(observation,
            textAlign: TextAlign.start, style: bodyMedium),
      ),
    ]);
  }

  Future<void> submit() async {
    final entretienModel = EntretienModel(
        nom: nomController.text,
        modele: modeleController.text,
        marque: marqueController.text,
        etatObjet: typeMaintenance.toString(),
        dureeTravaux: dureeTravauxController.text,
        signature: signature.toString(),
        createdRef: entretiensCount,
        created: DateTime.now(), 
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await EntretienApi().insertData(entretienModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitObjetRemplace() async {
    final objetRemplace = ObjetRemplaceModel(
        reference: entretiensCount,
        nom: nomObjetController.text,
        cout: coutController.text,
        caracteristique: caracteristiqueController.text,
        observation: observationController.text);
    await ObjetRemplaceApi().insertData(objetRemplace);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Ajouté avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
