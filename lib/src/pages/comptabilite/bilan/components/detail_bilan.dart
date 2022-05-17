import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/bilan_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/bilan_model.dart';
import 'package:fokad_admin/src/models/comptabilites/comptes.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailBilan extends StatefulWidget {
  const DetailBilan({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailBilan> createState() => _DetailBilanState();
}

class _DetailBilanState extends State<DetailBilan> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  String approbationDGController = '-';
  String approbationFinController = '-';
  String approbationBudgetController = '-';
  String approbationDDController = '-';
  TextEditingController signatureJustificationDGController =
      TextEditingController();
  TextEditingController signatureJustificationFinController =
      TextEditingController();
  TextEditingController signatureJustificationBudgetController =
      TextEditingController();
  TextEditingController signatureJustificationDDController =
      TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  UserModel? user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '-',
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    child: FutureBuilder<BilanModel>(
                        future: BilanApi().getOneData(widget.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<BilanModel> snapshot) {
                          if (snapshot.hasData) {
                            BilanModel? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: p20,
                                      child: IconButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
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
                                        child: pageDetail(data!)))
                              ],
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        })),
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
              totalMontant(data),
              Divider(
                color: Colors.amber.shade700,
              ),
              infosEditeurWidget(data)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget totalMontant(BilanModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    List<Comptes> dataList = [];
    double totalActif = 0.0;
    var actifList = data.comptesActif.toList();
    for (var item in actifList) {
      dataList.add(Comptes.fromJson(item));
    }

    for (var item in dataList) {
      totalActif += double.parse(item.montant);
    }

    double totalPassif = 0.0;
    List<Comptes> dataPassifList = [];
    var passifList = data.comptesPactif.toList();
    for (var item in passifList) {
      dataPassifList.add(Comptes.fromJson(item));
    }
    for (var item in dataPassifList) {
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                submitCorbeille(data);
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
                    actifWidget(data)
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
                      passifWidget(data)
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

  Widget actifWidget(BilanModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    List<Comptes> dataList = [];
    var actifList = data.comptesActif.toList();
    for (var item in actifList) {
      dataList.add(Comptes.fromJson(item));
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final actif = dataList[index];

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SelectableText(actif.compte,
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
                color: Colors.amber.shade700,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget passifWidget(BilanModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    List<Comptes> dataPassifList = [];
    var passifList = data.comptesPactif.toList();
    for (var item in passifList) {
      dataPassifList.add(Comptes.fromJson(item));
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: ListView.builder(
        itemCount: dataPassifList.length,
        itemBuilder: (context, index) {
          final passif = dataPassifList[index];

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SelectableText(passif.compte,
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
  }

  Widget infosEditeurWidget(BilanModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyLarge;
    final bodySmall = Theme.of(context).textTheme.bodyMedium;
    List<String> dataList = ['Approved', 'Unapproved', '-'];
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(p10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text('Directeur Générale',
                        style: bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700))),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text(
                                'Approbation',
                                style: bodySmall!
                                    .copyWith(color: Colors.red.shade700),
                              ),
                              // if (data.approbationDG != '-')
                              SelectableText(
                                data.approbationDG.toString(),
                                style: bodyMedium.copyWith(
                                    color: Colors.red.shade700),
                              ),
                              if (data.approbationDG == '-' &&
                                  user!.fonctionOccupe == 'Directeur générale')
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: p10, left: p5),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Approbation',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    ),
                                    value: approbationDGController,
                                    isExpanded: true,
                                    items: dataList.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        approbationDGController = value!;
                                        if (approbationDGController ==
                                            "Approved") {
                                          submitUpdateDG(data);
                                        }
                                      });
                                    },
                                  ),
                                )
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                'Signature',
                                style: bodySmall.copyWith(
                                    color: Colors.red.shade700),
                              ),
                              SelectableText(
                                data.signatureDG.toString(),
                                style: bodyMedium,
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                'Justification',
                                style: bodySmall.copyWith(
                                    color: Colors.red.shade700),
                              ),
                              if (data.approbationDG == 'Unapproved' &&
                                  data.signatureDG != '-')
                                SelectableText(
                                  data.signatureJustificationDG.toString(),
                                  style: bodyMedium,
                                ),
                              if (data.approbationDG == 'Unapproved' &&
                                  user!.fonctionOccupe == 'Directeur générale')
                                Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p10, left: p5),
                                    child: TextFormField(
                                      controller:
                                          signatureJustificationDGController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        labelText: 'Quelque chose à dire',
                                        hintText: 'Quelque chose à dire',
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(),
                                    )),
                              if (data.approbationDG == 'Unapproved')
                                IconButton(
                                    onPressed: () {
                                      submitUpdateDG(data);
                                    },
                                    icon: const Icon(Icons.send))
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.amber.shade700,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text('Directeur de departement',
                        style: bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700))),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text(
                                'Approbation',
                                style: bodySmall.copyWith(
                                    color: Colors.blue.shade700),
                              ),
                              if (data.approbationDD != '-' &&
                                  user!.fonctionOccupe ==
                                      'Directeur de departement')
                                SelectableText(
                                  data.approbationDD.toString(),
                                  style: bodyMedium.copyWith(
                                      color: Colors.blue.shade700),
                                ),
                              if (data.approbationDD == '-')
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: p10, left: p5),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      // labelText: 'Approbation',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    ),
                                    value: approbationDDController,
                                    isExpanded: true,
                                    items: dataList.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        approbationDDController = value!;
                                      });
                                    },
                                  ),
                                )
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                'Signature',
                                style: bodySmall.copyWith(
                                    color: Colors.blue.shade700),
                              ),
                              SelectableText(
                                data.signatureDD.toString(),
                                style: bodyMedium,
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                'Justification',
                                style: bodySmall.copyWith(
                                    color: Colors.blue.shade700),
                              ),
                              if (data.approbationDD == 'Unapproved' &&
                                  data.signatureDD != '-')
                                SelectableText(
                                  data.signatureJustificationDD.toString(),
                                  style: bodyMedium,
                                ),
                              if (approbationDDController == 'Unapproved' &&
                                  user!.fonctionOccupe ==
                                      'Directeur de departement')
                                Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p10, left: p5),
                                    child: TextFormField(
                                      controller:
                                          signatureJustificationDDController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        labelText: 'Quelque chose à dire',
                                        hintText: 'Quelque chose à dire',
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(),
                                    )),
                              if (approbationDDController == 'Unapproved')
                                IconButton(
                                    onPressed: () {
                                      submitUpdateDD(data);
                                    },
                                    icon: const Icon(Icons.send))
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitUpdateDG(BilanModel data) async {
    final bilanModel = BilanModel(
        titleBilan: data.titleBilan,
        comptesActif: data.comptesActif,
        comptesPactif: data.comptesPactif,
        statut: data.statut,
        approbationDG: approbationDGController.toString(),
        signatureDG: user!.matricule.toString(),
        signatureJustificationDG: signatureJustificationDGController.text,
        approbationDD: data.approbationDD.toString(),
        signatureDD: data.signatureDD.toString(),
        signatureJustificationDD: data.signatureJustificationDD.toString(),
        signature: data.signature,
        created: data.created);
    await BilanApi().updateData(data.id!, bilanModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise à jour avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateDD(BilanModel data) async {
    final bilanModel = BilanModel(
        titleBilan: data.titleBilan,
        comptesActif: data.comptesActif,
        comptesPactif: data.comptesPactif,
        statut: data.statut,
        approbationDG: data.approbationDG.toString(),
        signatureDG: data.signatureDG.toString(),
        signatureJustificationDG: data.signatureJustificationDG.toString(),
        approbationDD: approbationDDController.toString(),
        signatureDD: user!.matricule.toString(),
        signatureJustificationDD: signatureJustificationDDController.text,
        signature: data.signature.toString(),
        created: data.created);
    await BilanApi().updateData(data.id!, bilanModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise à jour avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitCorbeille(BilanModel data) async {
    final bilanModel = BilanModel(
      titleBilan: data.titleBilan,
      comptesActif: data.comptesActif,
      comptesPactif: data.comptesPactif,
      statut: true,
      approbationDG: data.approbationDG,
      signatureDG: data.signatureDG,
      signatureJustificationDG: data.signatureJustificationDG,
      approbationDD: data.approbationDD,
      signatureDD: data.signatureDD,
      signatureJustificationDD: data.signatureJustificationDD,
      signature: data.signature,
      created: data.created
    );
    await BilanApi().updateData(data.id!, bilanModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mis en corbeille avec succès!"),
      backgroundColor: Colors.red[700],
    ));
  }
}
