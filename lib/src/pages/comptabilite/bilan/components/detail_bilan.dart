import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/bilan_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_actif_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_passif_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
import 'package:fokad_admin/src/models/comptabilites/bilan_model.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_actif_model.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_passif_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailBilan extends StatefulWidget {
  const DetailBilan({Key? key}) : super(key: key);

  @override
  State<DetailBilan> createState() => _DetailBilanState();
}

class _DetailBilanState extends State<DetailBilan> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  String approbationDGController = '-';
  TextEditingController signatureJustificationDGController =
    TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  List<CompteActifModel> compteActifList = [];
  List<ComptePassifModel> comptePassifList = [];
  List<ApprobationModel> approbList = [];
  List<ApprobationModel> approbationData = [];
  ApprobationModel approb = ApprobationModel(
    reference: DateTime.now(),
    title: '-',
    departement: '-',
    fontctionOccupee: '-',
    ligneBudgtaire: '-',
    resources: '-',
    approbation: '-',
    justification: '-',
    signature: '-',
    created: DateTime.now()
  );

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
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var compteActif = await CompteActifApi().getAllData();
    var compatePassif = await ComptePassifApi().getAllData();
    var approbations = await ApprobationApi().getAllData();
    if(mounted) {
      setState(() {
        user = userModel;
        compteActifList = compteActif;
        comptePassifList = compatePassif;
        approbList = approbations;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<BilanModel>(
            future: BilanApi().getOneData(id),
            builder:
                (BuildContext context, AsyncSnapshot<BilanModel> snapshot) {
              if (snapshot.hasData) {
                BilanModel? data = snapshot.data;
                return FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, ComptabiliteRoutes.comptabiliteBilanAdd,
                      arguments: data);
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
                  child: FutureBuilder<BilanModel>(
                    future: BilanApi().getOneData(id),
                    builder: (BuildContext context,
                        AsyncSnapshot<BilanModel> snapshot) {
                      if (snapshot.hasData) {
                        BilanModel? data = snapshot.data;
                        approbationData = approbList
                            .where((element) =>
                              element.reference.microsecondsSinceEpoch ==
                              data!.createdRef.microsecondsSinceEpoch)
                            .toList();

                        if (approbationData.isNotEmpty) {
                          approb = approbationData.first;
                        }
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
                                      title: "Bilan",
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
                                  if (approbationData.isNotEmpty)
                                    infosEditeurWidget(),
                                  const SizedBox(height: p10),
                                  if (int.parse(user.role) == 1 ||
                                      int.parse(user.role) < 2)
                                    if (approb.fontctionOccupee !=
                                        user.fonctionOccupe)
                                      approbationForm(data),
                                ],
                              ),
                            ))
                          ],
                        );
                      } else {
                        return Center(
                          child: loading()
                        );
                      }
                    }
                  )
                ),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(BilanModel data) {
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
                  TitleWidget(title: data.titleBilan),
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
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              totalMontant(data)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget totalMontant(BilanModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    double totalActif = 0.0;
    var actifList = compteActifList
        .where((element) =>
            element.reference.microsecondsSinceEpoch ==
            data.createdRef.microsecondsSinceEpoch)
        .toList();
    for (var item in actifList) {
      totalActif += double.parse(item.montant);
    }

    double totalPassif = 0.0;
    var passifList = comptePassifList
        .where((element) =>
            element.reference.microsecondsSinceEpoch ==
            data.createdRef.microsecondsSinceEpoch)
        .toList();
    for (var item in passifList) {
      totalPassif += double.parse(item.montant);
    }
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('TOTAL :',
                      textAlign: TextAlign.start,
                      style: headline6!.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: SelectableText(
                      "${NumberFormat.decimalPattern('fr').format(totalActif)} \$",
                      textAlign: TextAlign.start,
                      style: headline6.copyWith(color: Colors.red.shade700)),
                )
              ],
            ),
          ),
          const SizedBox(width: p20),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('TOTAL :',
                      textAlign: TextAlign.start,
                      style: headline6.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: SelectableText(
                      "${NumberFormat.decimalPattern('fr').format(totalPassif)} \$",
                      textAlign: TextAlign.start,
                      style: headline6.copyWith(color: Colors.red.shade700)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget deleteButton(BilanModel data) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.blue.shade700),
      tooltip: "Modification",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de faire cette action ?'),
          content: const Text('Cette action permet de modifier ce document.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                updateSubmit(data);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataWidget(BilanModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('ACTIF',
                        textAlign: TextAlign.start,
                        style:
                            headline6!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: p20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: SelectableText("Comptes",
                              textAlign: TextAlign.start,
                              style: bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1,
                          child: SelectableText("Montant",
                              textAlign: TextAlign.center,
                              style: bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: p30),
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                      child: compteActifWidget(data))
                  ],
                ),
              ),
              Container(
                  color: Colors.amber.shade700,
                  width: 2,
                  height: MediaQuery.of(context).size.height / 1.5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(p8),
                  child: Column(
                    children: [
                      Text('PASSIF',
                          textAlign: TextAlign.start,
                          style:
                              headline6.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: p20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: SelectableText("Comptes",
                                textAlign: TextAlign.start,
                                style: bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 1,
                            child: SelectableText("Montant",
                                textAlign: TextAlign.center,
                                style: bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      const SizedBox(height: p30),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: comptePassifWidget(data))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget compteActifWidget(BilanModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return FutureBuilder<List<CompteActifModel>>(
      future: CompteActifApi().getAllData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CompteActifModel>> snapshot) {
        if (snapshot.hasData) {
          List<CompteActifModel>? dataList = snapshot.data!
            .where((element) =>
              element.reference.microsecondsSinceEpoch ==
              data.createdRef.microsecondsSinceEpoch)
            .toList();
          return ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final actif = dataList[index];
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SelectableText(actif.comptes,
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
                              "${NumberFormat.decimalPattern('fr').format(double.parse(actif.montant))} \$",
                              textAlign: TextAlign.center,
                              style: bodyMedium),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.amber.shade700
                  ),
                ],
              );
            },
          );
        } else {
          return Center(child: loading());
        }
      }
    );
  }

  Widget comptePassifWidget(BilanModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    return FutureBuilder<List<ComptePassifModel>>(
        future: ComptePassifApi().getAllData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ComptePassifModel>> snapshot) {
          if (snapshot.hasData) {
            List<ComptePassifModel>? dataList = snapshot.data!
                .where((element) =>
                    element.reference.microsecondsSinceEpoch ==
                    data.createdRef.microsecondsSinceEpoch)
                .toList();
            return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final passif = dataList[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SelectableText(passif.comptes,
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
                              "${NumberFormat.decimalPattern('fr').format(double.parse(passif.montant))} \$",
                              textAlign: TextAlign.center,
                              style: bodyMedium
                            ),
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
            );
          } else {
            return Center(child: loading());
          }
        });
  }


  Future<void> updateSubmit(BilanModel data) async {
    final bilanModel = BilanModel(
        titleBilan: data.titleBilan,
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now());
    await BilanApi().updateData(data.id!, bilanModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mis à jour effectué avec succès!"),
      backgroundColor: Colors.blue[700],
    ));
  }

  Widget infosEditeurWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

    return SizedBox(
      height: 500,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                    color: Colors.red.shade700,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    const TitleWidget(title: 'Approbation'),
                    Expanded(
                      child: FutureBuilder<List<ApprobationModel>>(
                          future: ApprobationApi().getAllData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ApprobationModel>> snapshot) {
                            if (snapshot.hasData) {
                              List<ApprobationModel>? dataList = snapshot.data;
                              return dataList!.isEmpty
                                  ? Center(
                                      child: Text(
                                      "Pas encore d'approbation",
                                      style: Responsive.isDesktop(context)
                                          ? const TextStyle(fontSize: 24)
                                          : const TextStyle(fontSize: 16),
                                    ))
                                  : ListView.builder(
                                      itemCount: dataList.length,
                                      itemBuilder: (context, index) {
                                        final item = dataList[index];
                                        return Padding(
                                            padding: const EdgeInsets.all(p10),
                                            child: Table(
                                              children: [
                                                TableRow(children: [
                                                  TableCell(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: p20),
                                                    child: Text(
                                                        "Responsable"
                                                            .toUpperCase(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: bodyLarge!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  )),
                                                  TableCell(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: p20),
                                                    child: Text(
                                                        "Approbation"
                                                            .toUpperCase(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            bodyLarge.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  )),
                                                  TableCell(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: p20),
                                                    child: Text(
                                                        "Motif".toUpperCase(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            bodyLarge.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  )),
                                                  TableCell(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: p20),
                                                    child: Text(
                                                        "Signature"
                                                            .toUpperCase(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            bodyLarge.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  )),
                                                ]),
                                                TableRow(children: [
                                                  TableCell(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: p10),
                                                    child: Text(
                                                        item.fontctionOccupee,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            bodyLarge.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  )),
                                                  TableCell(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: p10),
                                                    child: Text(
                                                        item.approbation,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: bodyLarge.copyWith(
                                                            color: (item.approbation ==
                                                                    'Approuved')
                                                                ? Colors.green
                                                                    .shade700
                                                                : Colors.red
                                                                    .shade700)),
                                                  )),
                                                  TableCell(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: p10),
                                                    child: AutoSizeText(
                                                        item.justification,
                                                        maxLines: 10,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: bodyLarge),
                                                  )),
                                                  TableCell(
                                                      child: Text(
                                                          item.signature,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: bodyLarge)),
                                                ]),
                                                if (item.fontctionOccupee ==
                                                    'Directeur de budget')
                                                  TableRow(children: [
                                                    TableCell(
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        p20),
                                                            child:
                                                                Container())),
                                                    TableCell(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: p20),
                                                      child: Text(
                                                          "Ligne budgetaire"
                                                              .toUpperCase(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: bodyLarge
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    )),
                                                    TableCell(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: p20),
                                                      child: Text(
                                                          "Ressources"
                                                              .toUpperCase(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: bodyLarge
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    )),
                                                    TableCell(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: p20),
                                                      child: Container(),
                                                    )),
                                                  ]),
                                                if (item.fontctionOccupee ==
                                                    'Directeur de budget')
                                                  TableRow(children: [
                                                    TableCell(
                                                        child: Container()),
                                                    TableCell(
                                                        child: Text(
                                                            item.ligneBudgtaire,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: bodyLarge)),
                                                    TableCell(
                                                        child: Text(
                                                            item.resources,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: bodyLarge)),
                                                    TableCell(
                                                        child: Container()),
                                                  ])
                                              ],
                                            ));
                                      });
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget approbationForm(BilanModel data) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return SizedBox(
      height: 200,
      child: Card(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(p10),
            child: Form(
              // key: _approbationKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(user.fonctionOccupe,
                          style: bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700))),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Text(
                                      'Approbation',
                                      style: bodyLarge.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: p20),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          bottom: p10, left: p5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child:
                                                DropdownButtonFormField<String>(
                                              decoration: InputDecoration(
                                                labelText: 'Approbation',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                              ),
                                              value: approbationDGController,
                                              isExpanded: true,
                                              items: approbationList
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  approbationDGController =
                                                      value!;
                                                });
                                              },
                                            ),
                                          ),
                                          if (approbationDGController ==
                                              'Approved')
                                            Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                  tooltip: 'Approuvé',
                                                  onPressed: () {
                                                    submitApprobation(data);
                                                  },
                                                  icon: Icon(Icons.send,
                                                      color:
                                                          Colors.red.shade700)),
                                            )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                            if (approbationDGController == 'Unapproved')
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Motif',
                                        style: bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: p20),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p10, left: p5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: TextFormField(
                                                  controller:
                                                      signatureJustificationDGController,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.0)),
                                                    labelText:
                                                        'Ecrivez votre motif...',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  minLines: 2,
                                                  maxLines: 3,
                                                  style: const TextStyle(),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                    tooltip: 'Approuvé',
                                                    onPressed: () {
                                                      // final form =
                                                      //     _approbationKey
                                                      //         .currentState!;
                                                      // if (form.validate()) {

                                                      //   form.reset();
                                                      // }
                                                      submitApprobation(data);
                                                    },
                                                    icon: Icon(Icons.send,
                                                        color: Colors
                                                            .red.shade700)),
                                              )
                                            ],
                                          )),
                                    ],
                                  ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future submitApprobation(BilanModel data) async {
    final approbation = ApprobationModel(
        reference: data.created,
        title: data.titleBilan,
        departement: 'Comptabilites',
        fontctionOccupee: user.fonctionOccupe,
        ligneBudgtaire: '-',
        resources: '-',
        approbation: approbationDGController,
        justification: signatureJustificationDGController.text,
        signature: user.matricule,
        created: DateTime.now());
    await ApprobationApi().insertData(approbation);
    Navigator.of(context).pop();
  }
}
