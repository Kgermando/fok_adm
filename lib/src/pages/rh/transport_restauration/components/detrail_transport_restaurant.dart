import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/rh/trans_rest_agents_api.dart';
import 'package:fokad_admin/src/api/rh/transport_restaurant_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailTransportRestaurant extends StatefulWidget {
  const DetailTransportRestaurant({Key? key}) : super(key: key);

  @override
  State<DetailTransportRestaurant> createState() =>
      _DetailTransportRestaurantState();
}

class _DetailTransportRestaurantState extends State<DetailTransportRestaurant> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isChecked = false;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController montantController = TextEditingController();

  // Approbations
  String approbationDG = '-';
  String approbationBudget = '-';
  String approbationFin = '-';
  String approbationDD = '-';
  TextEditingController motifDGController = TextEditingController();
  TextEditingController motifBudgetController = TextEditingController();
  TextEditingController motifFinController = TextEditingController();
  TextEditingController motifDDController = TextEditingController();
  String? ligneBudgtaire;
  String? ressource;

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    matriculeController.dispose();
    montantController.dispose();
    motifDGController.dispose();
    motifBudgetController.dispose();
    motifFinController.dispose();
    motifDDController.dispose();
    super.dispose();
  }

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: 'false',
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  List<TransRestAgentsModel> transRestAgentsList = [];
  List<TransRestAgentsModel> transRestAgentsFilter = [];
  List<LigneBudgetaireModel> ligneBudgetaireList = [];
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var transRestAgents = await TransRestAgentsApi().getAllData();
    var budgets = await LIgneBudgetaireApi().getAllData();
    setState(() {
      user = userModel;
      transRestAgentsFilter = transRestAgents;
      ligneBudgetaireList = budgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<TransportRestaurationModel>(
            future: TransportRestaurationApi().getOneData(id),
            builder: (BuildContext context,
                AsyncSnapshot<TransportRestaurationModel> snapshot) {
              if (snapshot.hasData) {
                TransportRestaurationModel? data = snapshot.data;
                return FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      detailAgentDialog(data!);
                    });
              } else {
                return loadingMini();
              }
            }),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                    padding: const EdgeInsets.all(p10),
                    child: FutureBuilder<TransportRestaurationModel>(
                        future: TransportRestaurationApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<TransportRestaurationModel>
                                snapshot) {
                          if (snapshot.hasData) {
                            TransportRestaurationModel? data = snapshot.data;
                            transRestAgentsList = transRestAgentsFilter
                                .where((element) =>
                                    element.reference.microsecondsSinceEpoch ==
                                    data!.createdRef.microsecondsSinceEpoch)
                                .toList();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: p20,
                                      child: IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: "Liste des payements",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: Column(
                                  children: [
                                    pageDetail(data!),
                                    const SizedBox(height: p10),
                                    approbationWidget(data)
                                  ],
                                )))
                              ],
                            );
                          } else {
                            return Center(child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(TransportRestaurationModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: data.title),
                  Column(
                    children: [
                      Row(
                        children: [
                          // IconButton(
                          //     onPressed: () {
                          //       Navigator.pushNamed(
                          //           context, RhRoutes.rhTransportRest);
                          //     },
                          //     icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                          PrintWidget(
                              tooltip: 'Imprimer le document',
                              onPressed: () {}),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              tableListAgents(data)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(TransportRestaurationModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Intitlé :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.title,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Observation',
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: p10,
              ),
              if (data.observation == 'false' && user.departement == "Finances")
                Expanded(flex: 3, child: checkboxRead(data)),
              Expanded(
                  flex: 3,
                  child: (data.observation == 'true')
                      ? SelectableText(
                          'Payé',
                          style: bodyMedium.copyWith(
                              color: Colors.greenAccent.shade700),
                        )
                      : SelectableText(
                          'Non payé',
                          style: bodyMedium.copyWith(
                              color: Colors.redAccent.shade700),
                        ))
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Signature:',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
        ],
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.green;
  }

  checkboxRead(TransportRestaurationModel data) {
    isChecked = data.observation == 'true';
    return ListTile(
      leading: Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isLoading = true;
          });
          setState(() {
            isChecked = value!;
            submitObservation(data);
          });
          setState(() {
            isLoading = false;
          });
        },
      ),
      title: const Text("Confirmation de payement"),
    );
  }

  Widget tableListAgents(TransportRestaurationModel data) {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Table(
        border: TableBorder.all(),
        children: [
          tableRowHeader(),
          for (var item in transRestAgentsList) tableRow(item)
        ],
      ),
    );
  }

  TableRow tableRowHeader() {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Nom"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Prenom"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Matricule"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Montant"),
      ),
    ]);
  }

  TableRow tableRow(TransRestAgentsModel item) {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText(item.nom),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText(item.prenom),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText(item.matricule),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(double.parse(item.montant))} \$"),
      ),
    ]);
  }

  detailAgentDialog(TransportRestaurationModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Infos detail'),
              content: SizedBox(
                  height: 200,
                  width: 500,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: nomWidget()),
                            const SizedBox(
                              width: p10,
                            ),
                            Expanded(child: prenomWidget())
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: matriculeWidget()),
                            const SizedBox(
                              width: p10,
                            ),
                            Expanded(child: montantWidget())
                          ],
                        ),
                      ],
                    ),
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      submitTransRestAgents(data);
                      form.reset();
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
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
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget prenomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: prenomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Prenom',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget matriculeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: matriculeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Matricule',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget montantWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: montantController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Montant',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Future<void> submitObservation(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        id: data.id!,
        title: data.title,
        observation: 'true',
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        approbationDG: data.approbationDG,
        motifDG: data.motifDG,
        signatureDG: data.signatureDG,
        approbationBudget: data.approbationBudget,
        motifBudget: data.motifBudget,
        signatureBudget: data.signatureBudget,
        approbationFin: data.approbationFin,
        motifFin: data.motifFin,
        signatureFin: data.signatureFin,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
        ligneBudgetaire: data.ligneBudgetaire,
        ressource: data.ressource);
    await TransportRestaurationApi().updateData(transRest);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitTransRestAgents(TransportRestaurationModel data) async {
    final transRest = TransRestAgentsModel(
        reference: data.createdRef,
        nom: nomController.text,
        prenom: prenomController.text,
        matricule: matriculeController.text,
        montant: montantController.text);
    await TransRestAgentsApi().insertData(transRest);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Ajouté avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Widget approbationWidget(TransportRestaurationModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          height: 200,
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add_task, color: Colors.green.shade700)),
                ],
              ),
              const SizedBox(height: p20),
              Row(
                children: [
                  const Expanded(flex: 1, child: Text("Directeur générale")),
                  const SizedBox(width: p20),
                  if (data.approbationDG != '-')
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Approbation"),
                                  const SizedBox(height: p20),
                                  Text(data.approbationDG),
                                ],
                              )),
                          if (data.approbationDG == "Unapproved")
                            Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    const Text("Motif"),
                                    const SizedBox(height: p20),
                                    Text(data.motifDG),
                                  ],
                                )),
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Signature"),
                                  const SizedBox(height: p20),
                                  Text(data.signatureDG),
                                ],
                              )),
                        ])),
                  if (data.approbationDG == '-' &&
                      user.fonctionOccupe == "Directeur générale")
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(child: approbationDGWidget(data)),
                          Expanded(child: motifDGWidget(data))
                        ])),
                ],
              ),
              const SizedBox(height: p20),
              Row(
                children: [
                  const Expanded(
                      flex: 1, child: Text("Directeur de departement")),
                  const SizedBox(width: p20),
                  if (data.approbationDD != '-')
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Approbation"),
                                  const SizedBox(height: p20),
                                  Text(data.approbationDD),
                                ],
                              )),
                          if (data.approbationDD == "Unapproved")
                            Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    const Text("Motif"),
                                    const SizedBox(height: p20),
                                    Text(data.motifDD),
                                  ],
                                )),
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Signature"),
                                  const SizedBox(height: p20),
                                  Text(data.signatureDD),
                                ],
                              )),
                        ])),
                  if (data.approbationDD == '-' &&
                      user.fonctionOccupe == "Directeur de departement")
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(child: approbationDDWidget(data)),
                          Expanded(child: motifDDWidget(data))
                        ])),
                ],
              ),
              const SizedBox(height: p20),
              Row(
                children: [
                  const Expanded(flex: 1, child: Text("Budget")),
                  const SizedBox(width: p20),
                  if (data.approbationBudget != '-')
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Approbation"),
                                      const SizedBox(height: p20),
                                      Text(data.approbationBudget),
                                    ],
                                  )),
                              if (data.approbationBudget == "Unapproved")
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        const Text("Motif"),
                                        const SizedBox(height: p20),
                                        Text(data.motifBudget),
                                      ],
                                    )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Signature"),
                                      const SizedBox(height: p20),
                                      Text(data.signatureBudget),
                                    ],
                                  )),
                            ]),
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Ligne Budgetaire"),
                                      const SizedBox(height: p20),
                                      Text(data.ligneBudgetaire),
                                    ],
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Ressource"),
                                      const SizedBox(height: p20),
                                      Text(data.ressource),
                                    ],
                                  )),
                            ]),
                          ],
                        )),
                  if (data.approbationBudget == '-' &&
                      user.fonctionOccupe == "Directeur de budget")
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(child: approbationBudgetWidget(data)),
                              Expanded(child: motifBudgetWidget(data))
                            ]),
                            Row(children: [
                              Expanded(child: ligneBudgtaireWidget()),
                              Expanded(child: resourcesWidget())
                            ]),
                          ],
                        )),
                ],
              ),
              const SizedBox(height: p20),
              Row(
                children: [
                  const Expanded(flex: 1, child: Text("Finance")),
                  const SizedBox(width: p20),
                  if (data.approbationFin != '-')
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Approbation"),
                                  const SizedBox(height: p20),
                                  Text(data.approbationFin),
                                ],
                              )),
                          if (data.approbationFin == "Unapproved")
                            Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    const Text("Motif"),
                                    const SizedBox(height: p20),
                                    Text(data.motifFin),
                                  ],
                                )),
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Signature"),
                                  const SizedBox(height: p20),
                                  Text(data.signatureFin),
                                ],
                              )),
                        ])),
                  if (data.approbationFin == '-' &&
                      user.fonctionOccupe == "Directeur de finance")
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(child: approbationFinWidget(data)),
                          Expanded(child: motifFinWidget(data))
                        ])),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget approbationDGWidget(TransportRestaurationModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Approbation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: approbationDG,
        isExpanded: true,
        items: approbationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            approbationDG = value!;
            if (approbationDG == "Approved") {
              submitDG(data);
            }
          });
        },
      ),
    );
  }

  Widget motifDGWidget(TransportRestaurationModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifDGController,
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ecrivez le motif...',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: 'Soumettre le Motif',
                  onPressed: () { 
                    submitDG(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  Widget approbationDDWidget(TransportRestaurationModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Approbation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: approbationDD,
        isExpanded: true,
        items: approbationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            approbationDD = value!;
             if (approbationDD == "Approved") {
              submitDD(data);
            }
          });
        },
      ),
    );
  }

  Widget motifDDWidget(TransportRestaurationModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifDDController,
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ecrivez le motif...',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: 'Soumettre le Motif',
                  onPressed: () {
                    submitDD(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  Widget approbationBudgetWidget(TransportRestaurationModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Approbation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: approbationBudget,
        isExpanded: true,
        items: approbationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            approbationBudget = value!;
            if (approbationBudget == "Approved") {
              submitBudget(data);
            }
          });
        },
      ),
    );
  }

  Widget motifBudgetWidget(TransportRestaurationModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifBudgetController,
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ecrivez le motif...',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: 'Soumettre le Motif',
                  onPressed: () {
                    submitBudget(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  Widget approbationFinWidget(TransportRestaurationModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Approbation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: approbationFin,
        isExpanded: true,
        items: approbationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            approbationFin = value!;
            if (approbationFin == "Approved") {
              submitFin(data);
            }
          });
        },
      ),
    );
  }

  Widget motifFinWidget(TransportRestaurationModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifFinController,
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ecrivez le motif...',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: 'Soumettre le Motif',
                  onPressed: () {
                    submitFin(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  // Soumettre une ligne budgetaire
  Widget ligneBudgtaireWidget() {
    var dataList =
        ligneBudgetaireList.map((e) => e.nomLigneBudgetaire).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Ligne Budgetaire',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: ligneBudgtaire,
        isExpanded: true,
        items: dataList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            ligneBudgtaire = value!;
          });
        },
      ),
    );
  }

  Widget resourcesWidget() {
    List<String> dataList = ['caisse', 'banque', 'finPropre', 'finExterieur'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Ligne Budgetaire',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: ressource,
        isExpanded: true,
        items: dataList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            ressource = value!;
          });
        },
      ),
    );
  }

  Future<void> submitDG(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        id: data.id!,
        title: data.title,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
 
        approbationDG: approbationDG,
        motifDG: (motifDGController.text == '') ? '-' : motifDGController.text,
        signatureDG: user.matricule,
        approbationBudget: '-',
        motifBudget: '-',
        signatureBudget: '-',
        approbationFin: '-',
        motifFin: '-',
        signatureFin: '-',
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
        ligneBudgetaire: '-',
        ressource: '-'
    );
    await TransportRestaurationApi().updateData(transRest);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitDD(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        id: data.id!,
        title: data.title,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,

        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationBudget: '-',
        motifBudget: '-',
        signatureBudget: '-',
        approbationFin: '-',
        motifFin: '-',
        signatureFin: '-',
        approbationDD: approbationDD,
        motifDD: (motifDDController.text == '') ? '-' : motifDDController.text,
        signatureDD: user.matricule,
        ligneBudgetaire: '-',
        ressource: '-'
    );
    await TransportRestaurationApi().updateData(transRest);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitBudget(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        id: data.id!,
        title: data.title,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,

        approbationDG: approbationDG,
        motifDG: data.motifDG,
        signatureDG: data.signatureDG,
        approbationBudget: approbationBudget,
        motifBudget: (motifBudgetController.text == '')
            ? '-'
            : motifBudgetController.text,
        signatureBudget: user.matricule,
        approbationFin: '-',
        motifFin: '-',
        signatureFin: '-',
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
        ligneBudgetaire:
            (ligneBudgtaire.toString() == '') ? '-' : ligneBudgtaire.toString(),
        ressource: (ressource.toString() == '') ? '-' : ressource.toString()
    );
    await TransportRestaurationApi().updateData(transRest);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitFin(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        id: data.id!,
        title: data.title,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,

        approbationDG: approbationDG,
        motifDG: data.motifDG,
        signatureDG: data.signatureDG,
        approbationBudget: data.approbationBudget,
        motifBudget: data.motifBudget,
        signatureBudget: data.signatureBudget,
        approbationFin: approbationFin,
        motifFin:
            (motifFinController.text == '') ? '-' : motifFinController.text,
        signatureFin: user.matricule,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
        ligneBudgetaire: data.ligneBudgetaire,
        ressource: data.ressource
    );
    await TransportRestaurationApi().updateData(transRest);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
