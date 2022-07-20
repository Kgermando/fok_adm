import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/balance_compte_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_balance_ref_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/balance_comptes_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/components/balance_pdf.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailBalance extends StatefulWidget {
  const DetailBalance({Key? key}) : super(key: key);

  @override
  State<DetailBalance> createState() => _DetailBalanceState();
}

class _DetailBalanceState extends State<DetailBalance> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;
  bool isLoadingDelete = false;
  bool isLoadingSend = false;

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

  List<CompteBalanceRefModel> compteBalanceRefList = [];

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
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var compteBalanceRef = await CompteBalanceRefApi().getAllData();
    setState(() {
      user = userModel;
      compteBalanceRefList = compteBalanceRef;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<BalanceCompteModel>(
            future: BalanceCompteApi().getOneData(id),
            builder: (BuildContext context,
                AsyncSnapshot<BalanceCompteModel> snapshot) {
              if (snapshot.hasData) {
                BalanceCompteModel? data = snapshot.data;
                return (data!.isSubmit == 'false' &&
                        data.approbationDD == '-' &&
                        data.approbationDG == '-')
                    ? FloatingActionButton(
                        child: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.pushNamed(context,
                              ComptabiliteRoutes.comptabiliteBalanceAdd,
                              arguments: data);
                        })
                    : Container();
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
                    child: FutureBuilder<BalanceCompteModel>(
                        future: BalanceCompteApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<BalanceCompteModel> snapshot) {
                          if (snapshot.hasData) {
                            BalanceCompteModel? data = snapshot.data;
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
                                          title: "Balance",
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
                            return Center(child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(BalanceCompteModel data) {
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
                          if (data.signature ==
                              user.matricule) // Uniqyement celui a remplit le document
                            sendButton(data),
                          if (data.approbationDG == "Unapproved" ||
                              data.approbationDD == "Unapproved")
                            deleteButton(data),
                          PrintWidget(
                              tooltip: 'Imprimer le document',
                              onPressed: () async {
                                var compteBalanceRefPdf = compteBalanceRefList
                                    .where((element) =>
                                        element
                                            .reference.microsecondsSinceEpoch ==
                                        data.createdRef.microsecondsSinceEpoch)
                                    .toList();
                                await BalancePdf.generate(
                                    data, compteBalanceRefPdf);
                              }),
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
              Divider(
                color: Colors.amber.shade700,
              ),
              totalMontant(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget totalMontant(BalanceCompteModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;

    return FutureBuilder<List<CompteBalanceRefModel>>(
        future: CompteBalanceRefApi().getAllData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CompteBalanceRefModel>> snapshot) {
          if (snapshot.hasData) {
            List<CompteBalanceRefModel>? dataList = snapshot.data!
                .where((element) =>
                    element.reference.microsecondsSinceEpoch ==
                    data.createdRef.microsecondsSinceEpoch)
                .toList();
            double totalDebit = 0.0;
            double totalCredit = 0.0;
            double totalSolde = 0.0;

            for (var item in dataList) {
              totalDebit += double.parse(item.debit);
              totalCredit += double.parse(item.credit);
              totalSolde += item.solde;

              // print("item.debit ${item.debit} ");
            }

            return Padding(
              padding: const EdgeInsets.all(p10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text("TOTAL :",
                            textAlign: TextAlign.start,
                            style: headline6!
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: Colors.amber.shade700,
                              width: 2,
                            ),
                          )),
                          child: SelectableText(
                              "${NumberFormat.decimalPattern('fr').format(totalDebit)} \$",
                              textAlign: TextAlign.center,
                              style: headline6.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: Colors.amber.shade700,
                              width: 2,
                            ),
                          )),
                          child: SelectableText(
                              "${NumberFormat.decimalPattern('fr').format(totalCredit)} \$",
                              textAlign: TextAlign.center,
                              style: headline6.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: Colors.amber.shade700,
                              width: 2,
                            ),
                          )),
                          child: SelectableText(
                              "${NumberFormat.decimalPattern('fr').format(totalSolde)} \$",
                              textAlign: TextAlign.center,
                              style: headline6.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          } else {
            return loadingMini();
          }
        });
  }

  Widget dataWidget(BalanceCompteModel data) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: p20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: SelectableText("Comptes",
                                textAlign: TextAlign.start,
                                style: bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              left: BorderSide(
                                color: Colors.amber.shade700,
                                width: 2,
                              ),
                            )),
                            child: SelectableText("Débit",
                                textAlign: TextAlign.center,
                                style: bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              left: BorderSide(
                                color: Colors.amber.shade700,
                                width: 2,
                              ),
                            )),
                            child: SelectableText("Crédit",
                                textAlign: TextAlign.center,
                                style: bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              left: BorderSide(
                                color: Colors.amber.shade700,
                                width: 2,
                              ),
                            )),
                            child: SelectableText("Solde débit/crédit",
                                textAlign: TextAlign.center,
                                style: bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                    Divider(color: Colors.amber.shade700),
                    const SizedBox(height: p30),
                    compteWidget(data)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget compteWidget(BalanceCompteModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return FutureBuilder<List<CompteBalanceRefModel>>(
        future: CompteBalanceRefApi().getAllData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CompteBalanceRefModel>> snapshot) {
          if (snapshot.hasData) {
            List<CompteBalanceRefModel>? dataList = snapshot.data!
                .where((element) =>
                    element.reference.microsecondsSinceEpoch ==
                    data.createdRef.microsecondsSinceEpoch)
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final compte = dataList[index];
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: SelectableText(compte.comptes,
                                textAlign: TextAlign.start, style: bodyMedium),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                left: BorderSide(
                                  color: Colors.amber.shade700,
                                  width: 2,
                                ),
                              )),
                              child: SelectableText(
                                  "${NumberFormat.decimalPattern('fr').format(double.parse(compte.debit))} \$",
                                  textAlign: TextAlign.center,
                                  style: bodyMedium),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                left: BorderSide(
                                  color: Colors.amber.shade700,
                                  width: 2,
                                ),
                              )),
                              child: SelectableText(
                                  "${NumberFormat.decimalPattern('fr').format(double.parse(compte.credit))} \$",
                                  textAlign: TextAlign.center,
                                  style: bodyMedium),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                left: BorderSide(
                                  color: Colors.amber.shade700,
                                  width: 2,
                                ),
                              )),
                              child: SelectableText(
                                  "${NumberFormat.decimalPattern('fr').format(compte.solde)} \$",
                                  textAlign: TextAlign.center,
                                  style: bodyMedium),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.amber.shade700,
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            return loading();
          }
        });
  }

  Widget deleteButton(BalanceCompteModel data) {
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
                await BalanceCompteApi().deleteData(data.id!).then((value) {
                  setState(() {
                    isLoadingDelete = false;
                  });
                });
                // Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget sendButton(BalanceCompteModel data) {
    return IconButton(
      icon: Icon(Icons.send, color: Colors.green.shade700),
      tooltip: "Soumettre chez le directeur de departement",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous pour soumettre ce document ?'),
          content: (isLoadingSend)
              ? loading()
              : const Text(
                  'Cette action permet de soumettre ce document chez le directeur de departement.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                sendDD(data).then((value) {
                  setState(() {
                    isLoadingSend = false;
                  });
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendDD(BalanceCompteModel data) async {
    final balanceCompteModel = BalanceCompteModel(
        id: data.id!,
        title: data.title,
        statut: 'true',
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        isSubmit: 'true',
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await BalanceCompteApi().updateData(balanceCompteModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Document envoyé avec succès!"),
      backgroundColor: Colors.red[700],
    ));
  }

  Widget approbationWidget(BalanceCompteModel data) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        color: Colors.red[50],
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.red.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TitleWidget(title: 'Approbations'),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add_task, color: Colors.green.shade700)),
                ],
              ),
              const SizedBox(height: p20),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text("Directeur générale", style: bodyLarge)),
                    const SizedBox(width: p20),
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
                                      Text(data.approbationDG,
                                          style: bodyLarge!.copyWith(
                                              color: (data.approbationDG ==
                                                      "Unapproved")
                                                  ? Colors.red.shade700
                                                  : Colors.green.shade700)),
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
                            ]),
                            if (data.approbationDG == '-' &&
                                user.fonctionOccupe == "Directeur générale")
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Row(children: [
                                  Expanded(child: approbationDGWidget(data)),
                                  const SizedBox(width: p20),
                                  if (approbationDG == "Unapproved")
                                    Expanded(child: motifDGWidget(data))
                                ]),
                              ),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(height: p20),
              Divider(color: Colors.red[10]),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                            Text("Directeur de departement", style: bodyLarge)),
                    const SizedBox(width: p20),
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
                                      Text(data.approbationDD,
                                          style: bodyLarge.copyWith(
                                              color: (data.approbationDD ==
                                                      "Unapproved")
                                                  ? Colors.red.shade700
                                                  : Colors.green.shade700)),
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
                            ]),
                            if (data.approbationDD == '-' &&
                                user.fonctionOccupe ==
                                    "Directeur de departement")
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Row(children: [
                                  Expanded(child: approbationDDWidget(data)),
                                  const SizedBox(width: p20),
                                  if (approbationDD == "Unapproved")
                                    Expanded(child: motifDDWidget(data))
                                ]),
                              ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget approbationDGWidget(BalanceCompteModel data) {
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

  Widget motifDGWidget(BalanceCompteModel data) {
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

  Widget approbationDDWidget(BalanceCompteModel data) {
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

  Widget motifDDWidget(BalanceCompteModel data) {
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

  Future<void> submitDG(BalanceCompteModel data) async {
    final balanceCompteModel = BalanceCompteModel(
        id: data.id!,
        title: data.title,
        statut: data.statut,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        isSubmit: data.isSubmit,
        approbationDG: approbationDG,
        motifDG: (motifDGController.text == '') ? '-' : motifDGController.text,
        signatureDG: user.matricule,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD);

    await BalanceCompteApi().updateData(balanceCompteModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitDD(BalanceCompteModel data) async {
    final balanceCompteModel = BalanceCompteModel(
        id: data.id!,
        title: data.title,
        statut: data.statut,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        isSubmit: data.isSubmit,
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: approbationDD,
        motifDD: (motifDDController.text == '') ? '-' : motifDDController.text,
        signatureDD: user.matricule);
    await BalanceCompteApi().updateData(balanceCompteModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
