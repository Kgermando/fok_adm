import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/anguin_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/add_trajet_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/table_trajet_anguin.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class DetailAnguin extends StatefulWidget {
  const DetailAnguin({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<DetailAnguin> createState() => _DetailAnguinState();
}

class _DetailAnguinState extends State<DetailAnguin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
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

  String? nom;
  String? modele;
  String? marque;
  String? numeroChassie;
  String? couleur;
  String? genre; // somme d'affectation pour le budget
  String? qtyMaxReservoir;
  DateTime? dateFabrication;
  String? nomeroPLaque;
  String? nomeroEntreprise;
  String? kilometrageInitiale;
  String? provenance;
  DateTime? created;
  String? signature;

  @override
  initState() {
    getData();
    super.initState();
  }

  UserModel? user = UserModel(
      nom: '-',
      prenom: '-',
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
    AnguinModel data = await AnguinApi().getOneData(widget.id!);
    setState(() {
      user = userModel;
      nom = data.nom;
      modele = data.modele;
      marque = data.marque;
      numeroChassie = data.numeroChassie;
      couleur = data.couleur;
      genre = data.genre;
      qtyMaxReservoir = data.qtyMaxReservoir;
      dateFabrication = data.dateFabrication;
      nomeroPLaque = data.nomeroPLaque;
      nomeroEntreprise = data.nomeroEntreprise;
      kilometrageInitiale = data.kilometrageInitiale;
      provenance = data.provenance;
      created = data.created;
      signature = data.signature;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            child: Row(
              children: const [
                Icon(Icons.add),
                Icon(Icons.place),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddTrajetAuto(
                        numeroMatricule: nomeroEntreprise,
                      )));
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
                    child: FutureBuilder<AnguinModel>(
                        future: AnguinApi().getOneData(widget.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<AnguinModel> snapshot) {
                          if (snapshot.hasData) {
                            AnguinModel? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: p20,
                                      child: IconButton(
                                          onPressed: () =>
                                              Routemaster.of(context).pop(),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: data!.nom,
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: Scrollbar(
                                        controller: _controllerScroll,
                                        isAlwaysShown: true,
                                        child: pageDetail(data)))
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

  Widget pageDetail(AnguinModel data) {
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
          child: ListView(
            controller: _controllerScroll,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: data.modele),
                  Column(
                    children: [
                      PrintWidget(
                          tooltip: 'Imprimer le document', onPressed: () {}),
                      SelectableText(
                          DateFormat("dd-MM-yy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              SizedBox(
                  height: 500,
                  child: TableTrajetAnguin(
                    anguinModel: data,
                  )),
              infosEditeurWidget(data)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(AnguinModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Type anguin :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.nom,
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
                child: Text('Modèle :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.modele,
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
                child: Text('Marque :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.marque,
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
                child: Text('Numero chassie :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.numeroChassie,
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
                child: Text('Couleur :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.couleur,
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
                child: Text('Genre :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.genre,
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
                child: Text('Quantité max du reservoir :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.qtyMaxReservoir,
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
                child: Text('Date de fabrication :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(
                    DateFormat("dd-MM-yy").format(data.created),
                    textAlign: TextAlign.start,
                    style: bodyMedium),
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
                child: Text('numéro plaque :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.nomeroPLaque,
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
                child: Text('Numéro attribué :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.nomeroEntreprise,
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
                child: Text('kilometrage Initiale :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.kilometrageInitiale,
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
                child: Text('Provenance :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.provenance,
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
                child: Text('signature :',
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

  Widget infosEditeurWidget(AnguinModel data) {
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
                              if (data.approbationDG != '-')
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
                    child: Text('Directeur de Finance',
                        style: bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700))),
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
                                    color: Colors.green.shade700),
                              ),
                              if (data.approbationFin != '-')
                                SelectableText(
                                  data.approbationFin.toString(),
                                  style: bodyMedium.copyWith(
                                      color: Colors.green.shade700),
                                ),
                              if (data.approbationFin == '-' &&
                                  user!.fonctionOccupe ==
                                      'Directeur des finances')
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
                                    value: approbationFinController,
                                    isExpanded: true,
                                    items: dataList.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        approbationFinController = value!;
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
                                    color: Colors.green.shade700),
                              ),
                              SelectableText(
                                data.signatureFin.toString(),
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
                                    color: Colors.green.shade700),
                              ),
                              if (data.approbationFin == 'Unapproved' &&
                                  data.signatureFin != '-')
                                SelectableText(
                                  data.signatureJustificationFin.toString(),
                                  style: bodyMedium,
                                ),
                              if (data.approbationFin == 'Unapproved' &&
                                  user!.fonctionOccupe ==
                                      'Directeur des finances')
                                Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p10, left: p5),
                                    child: TextFormField(
                                      controller:
                                          signatureJustificationFinController,
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
                              if (data.approbationFin == 'Unapproved')
                                IconButton(
                                    onPressed: () {
                                      submitUpdateFIN(data);
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
                    child: Text('Budget',
                        style: bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700))),
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
                                    color: Colors.orange.shade700),
                              ),
                              if (data.approbationBudget != '-')
                                SelectableText(
                                  data.approbationBudget.toString(),
                                  style: bodyMedium.copyWith(
                                      color: Colors.orange.shade700),
                                ),
                              if (data.approbationBudget == '-' &&
                                  user!.fonctionOccupe == 'Directeur de budget')
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
                                    value: approbationBudgetController,
                                    isExpanded: true,
                                    items: dataList.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        approbationBudgetController = value!;
                                      });
                                    },
                                  ),
                                ),
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                'Signature',
                                style: bodySmall.copyWith(
                                    color: Colors.orange.shade700),
                              ),
                              SelectableText(
                                data.signatureBudget.toString(),
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
                                    color: Colors.orange.shade700),
                              ),
                              if (data.approbationBudget == 'Unapproved' &&
                                  data.signatureBudget != '-')
                                SelectableText(
                                  data.signatureJustificationBudget.toString(),
                                  style: bodyMedium,
                                ),
                              if (data.approbationBudget == 'Unapproved' &&
                                  user!.fonctionOccupe == 'Directeur de budget')
                                Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p10, left: p5),
                                    child: TextFormField(
                                      controller:
                                          signatureJustificationBudgetController,
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
                              if (data.approbationBudget == 'Unapproved')
                                IconButton(
                                    onPressed: () {
                                      submitUpdateBudget(data);
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
                    child: Text('Directeur de département',
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
                                      'Directeur de département')
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
                                      'Directeur de département')
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

  Future<void> submitUpdateDG(AnguinModel data) async {
    final anguinModel = AnguinModel(
        nom: data.nom,
        modele: data.modele,
        marque: data.marque,
        numeroChassie: data.numeroChassie,
        couleur: data.couleur,
        genre: data.genre,
        qtyMaxReservoir: data.qtyMaxReservoir,
        dateFabrication: data.dateFabrication,
        nomeroPLaque: data.nomeroPLaque,
        nomeroEntreprise: data.nomeroEntreprise,
        kilometrageInitiale: data.kilometrageInitiale,
        provenance: data.provenance,
        typeCaburant: data.typeCaburant,
        typeMoteur: data.typeMoteur,
        approbationDG: approbationDGController.toString(),
        signatureDG: user!.matricule.toString(),
        signatureJustificationDG: signatureJustificationDGController.text,
        approbationFin: data.approbationFin.toString(),
        signatureFin: data.signatureFin.toString(),
        signatureJustificationFin: data.signatureJustificationFin.toString(),
        approbationBudget: data.approbationBudget.toString(),
        signatureBudget: data.signatureBudget.toString(),
        signatureJustificationBudget:
            data.signatureJustificationBudget.toString(),
        approbationDD: data.approbationDD.toString(),
        signatureDD: data.signatureDD.toString(),
        signatureJustificationDD: data.signatureJustificationDD.toString(),
        signature: data.signature,
        created: data.created);
    await AnguinApi().updateData(data.id!, anguinModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateFIN(AnguinModel data) async {
    final anguinModel = AnguinModel(
      nom: data.nom,
      modele: data.modele,
      marque: data.marque,
      numeroChassie: data.numeroChassie,
      couleur: data.couleur,
      genre: data.genre,
      qtyMaxReservoir: data.qtyMaxReservoir,
      dateFabrication: data.dateFabrication,
      nomeroPLaque: data.nomeroPLaque,
      nomeroEntreprise: data.nomeroEntreprise,
      kilometrageInitiale: data.kilometrageInitiale,
      provenance: data.provenance,
      typeCaburant: data.typeCaburant,
      typeMoteur: data.typeMoteur,
       approbationDG: data.approbationDG.toString(),
      signatureDG: data.signatureDG.toString(),
      signatureJustificationDG: data.signatureJustificationDG.toString(),
      approbationFin: approbationFinController.toString(),
      signatureFin: user!.matricule.toString(),
      signatureJustificationFin: signatureJustificationFinController.text,
      approbationBudget: data.approbationBudget.toString(),
      signatureBudget: data.signatureBudget.toString(),
      signatureJustificationBudget:
          data.signatureJustificationBudget.toString(),
      approbationDD: data.approbationDD.toString(),
      signatureDD: data.signatureDD.toString(),
      signatureJustificationDD: data.signatureJustificationDD.toString(),
        signature: data.signature,
        created: data.created);
    
    await AnguinApi().updateData(data.id!, anguinModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateBudget(AnguinModel data) async {
    final anguinModel = AnguinModel(
        nom: data.nom,
        modele: data.modele,
        marque: data.marque,
        numeroChassie: data.numeroChassie,
        couleur: data.couleur,
        genre: data.genre,
        qtyMaxReservoir: data.qtyMaxReservoir,
        dateFabrication: data.dateFabrication,
        nomeroPLaque: data.nomeroPLaque,
        nomeroEntreprise: data.nomeroEntreprise,
        kilometrageInitiale: data.kilometrageInitiale,
        provenance: data.provenance,
        typeCaburant: data.typeCaburant,
        typeMoteur: data.typeMoteur,
        approbationDG: data.approbationDG.toString(),
        signatureDG: data.signatureDG.toString(),
        signatureJustificationDG: data.signatureJustificationDG.toString(),
        approbationFin: data.approbationFin.toString(),
        signatureFin: data.signatureFin.toString(),
        signatureJustificationFin: data.signatureJustificationFin.toString(),
        approbationBudget: approbationBudgetController.toString(),
        signatureBudget: user!.matricule.toString(),
        signatureJustificationBudget:
            signatureJustificationBudgetController.text,
        approbationDD: data.approbationDD.toString(),
        signatureDD: data.signatureDD.toString(),
        signatureJustificationDD: data.signatureJustificationDD.toString(),
        signature: data.signature,
        created: data.created);

    await AnguinApi().updateData(data.id!, anguinModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateDD(AnguinModel data) async {
    final anguinModel = AnguinModel(
        nom: data.nom,
        modele: data.modele,
        marque: data.marque,
        numeroChassie: data.numeroChassie,
        couleur: data.couleur,
        genre: data.genre,
        qtyMaxReservoir: data.qtyMaxReservoir,
        dateFabrication: data.dateFabrication,
        nomeroPLaque: data.nomeroPLaque,
        nomeroEntreprise: data.nomeroEntreprise,
        kilometrageInitiale: data.kilometrageInitiale,
        provenance: data.provenance,
        typeCaburant: data.typeCaburant,
        typeMoteur: data.typeMoteur,
        approbationDG: data.approbationDG.toString(),
        signatureDG: data.signatureDG.toString(),
        signatureJustificationDG: data.signatureJustificationDG.toString(),
        approbationFin: data.approbationFin.toString(),
        signatureFin: data.signatureFin.toString(),
        signatureJustificationFin: data.signatureJustificationFin.toString(),
        approbationBudget: data.approbationBudget.toString(),
        signatureBudget: data.signatureBudget.toString(),
        signatureJustificationBudget:
            data.signatureJustificationBudget.toString(),
        approbationDD: approbationDDController.toString(),
        signatureDD: user!.matricule.toString(),
        signatureJustificationDD: signatureJustificationDDController.text,
        signature: data.signature.toString(),
        created: data.created);
    await AnguinApi().updateData(data.id!, anguinModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
