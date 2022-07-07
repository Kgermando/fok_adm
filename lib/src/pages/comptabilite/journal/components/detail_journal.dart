import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart'; 
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart'; 
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailJournal extends StatefulWidget {
  const DetailJournal({Key? key}) : super(key: key);

  @override
  State<DetailJournal> createState() => _DetailJournalState();
}

class _DetailJournalState extends State<DetailJournal> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  String approbationDGController = '-';
  TextEditingController signatureJustificationDGController =
      TextEditingController();

  bool statutCorbeille = false;

    // Approbations
  String approbationDG = '-';
  String approbationDD = '-';
  TextEditingController motifDGController = TextEditingController();
  TextEditingController motifDDController = TextEditingController();


  @override
  initState() {
    getData();
    super.initState();
  }

    @override
  void dispose() {
    motifDGController.dispose();
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
  // BilanModel? bilanModel;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
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
                    child: FutureBuilder<JournalModel>(
                        future: JournalApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<JournalModel> snapshot) {
                          if (snapshot.hasData) {
                            JournalModel? data = snapshot.data; 
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
                                          title: "Journal",
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
                                  ),
                                ))
                              ],
                            );
                          } else {
                            return Center(
                                child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(JournalModel data) {
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          deleteButton(data),
                          PrintWidget(
                              tooltip: 'Imprimer le document',
                              onPressed: () {}),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget deleteButton(JournalModel data) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade700),
      tooltip: "Supprimer",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de faire cette action ?'),
          content: const Text(
              'Cette action permet de permet de mettre ce fichier en corbeille.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                submitCorbeille(data);
                Navigator.of(context).pop();
                // await BilanApi().deleteData(data.id!);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataWidget(JournalModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Nomero opération :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.numeroOperation,
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
                child: Text('Libele :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.libele,
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
                child: Text('Débit :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded( 
                            child: Text('Compte',
                                textAlign: TextAlign.center,
                                style: bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: Text('Montant',
                                textAlign: TextAlign.center,
                                style: bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ), 
                    const SizedBox(height: p20),
                    Row(
                      children: [
                        Expanded( 
                          child: SelectableText(data.compteDebit,
                              textAlign: TextAlign.center, style: bodyMedium),
                        ),
                        Expanded( 
                          child: SelectableText("${NumberFormat.decimalPattern('fr').format(double.parse(data.montantDebit))} \$",
                              textAlign: TextAlign.center, style: bodyMedium),
                        ),
                      ],
                    ),
                    
                  ],
                )
              ), 
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Crédit:',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text('Compte',
                                textAlign: TextAlign.center,
                                style: bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: Text('Montant',
                                textAlign: TextAlign.center,
                                style: bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: p20),
                      Row(
                        children: [
                          Expanded(
                            child: SelectableText(data.compteCredit,
                                textAlign: TextAlign.center, style: bodyMedium),
                          ),
                          Expanded(
                            child: SelectableText("${NumberFormat.decimalPattern('fr').format(double.parse(data.montantCredit))} \$",
                                textAlign: TextAlign.center, style: bodyMedium),
                          ),
                        ],
                      )
                      
                    ],
                  )),
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('TVA :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText("${data.tva} %",
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
                child: Text('Remarque :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.remarque,
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
                child: Text('Signature :',
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
        ],
      ),
    );
  } 

  Future<void> submitCorbeille(JournalModel data) async {
    final journalModel = JournalModel(
      id: data.id!,
        numeroOperation: data.numeroOperation,
        libele: data.libele,
        compteDebit: data.compteDebit,
        montantDebit: data.montantDebit,
        compteCredit: data.compteCredit,
        montantCredit: data.montantCredit,
        tva: data.tva,
        remarque: data.remarque,
        signature: data.signature,
        createdRef: data.created,
        created: DateTime.now(),
        approbationDG: data.approbationDG,
        motifDG: data.motifDG,
        signatureDG: data.signatureDG,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
    );
    await JournalApi().updateData(journalModel);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise en corbeille avec succès!"),
      backgroundColor: Colors.red[700],
    ));
  }



  Widget approbationWidget(JournalModel data) {
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
            ],
          ),
        ),
      ),
    ]);
  }

  Widget approbationDGWidget(JournalModel data) {
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

  Widget motifDGWidget(JournalModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifDGController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
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

  Widget approbationDDWidget(JournalModel data) {
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

  Widget motifDDWidget(JournalModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifDDController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
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

  Future<void> submitDG(JournalModel data) async {
    final journalModel = JournalModel(
      id: data.id!,
      numeroOperation: data.numeroOperation,
      libele: data.libele,
      compteDebit: data.compteDebit,
      montantDebit: data.montantDebit,
      compteCredit: data.compteCredit,
      montantCredit: data.montantCredit,
      tva: data.tva,
      remarque: data.remarque,
      signature: data.signature,
      createdRef: data.created,
      created: DateTime.now(),
      approbationDG: approbationDG,
      motifDG: (motifDGController.text == '') ? '-' : motifDGController.text,
      signatureDG: user.matricule,
      approbationDD: data.approbationDD,
      motifDD: data.motifDD,
      signatureDD: data.signatureDD
    );
    await JournalApi().updateData(journalModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitDD(JournalModel data) async {
    final journalModel = JournalModel(
      id: data.id!,
      numeroOperation: data.numeroOperation,
      libele: data.libele,
      compteDebit: data.compteDebit,
      montantDebit: data.montantDebit,
      compteCredit: data.compteCredit,
      montantCredit: data.montantCredit,
      tva: data.tva,
      remarque: data.remarque,
      signature: data.signature,
      createdRef: data.created,
      created: DateTime.now(),
      approbationDG: '-',
      motifDG: '-',
      signatureDG: '-',
      approbationDD: approbationDD,
      motifDD: (motifDDController.text == '') ? '-' : motifDDController.text,
      signatureDD: user.matricule
    );
    await JournalApi().updateData(journalModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
