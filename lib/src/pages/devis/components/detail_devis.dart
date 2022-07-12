import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/devis/devis_list_objets_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/devis/devis_list_objets_model.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailDevis extends StatefulWidget {
  const DetailDevis({Key? key}) : super(key: key);

  @override
  State<DetailDevis> createState() => _DetailDevisState();
}

class _DetailDevisState extends State<DetailDevis> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>(); 
  bool isLoading = false;
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();
  bool isLoadingBtn = false;

  double quantity = 0.0;
  final TextEditingController designationController = TextEditingController();
  double montantUnitaire = 0.0;
  double montantGlobal = 0.0;

 
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
    motifDGController.dispose();
    motifBudgetController.dispose();
    motifFinController.dispose();
    motifDDController.dispose();
    super.dispose();
  }

  List<DevisListObjetsModel> devisObjetList = [];
  List<DevisListObjetsModel> devObjetList = [];
  List<LigneBudgetaireModel> ligneBudgetaireList = []; 
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
    var budgets = await LIgneBudgetaireApi().getAllData(); 
    var devisObjetLists = await DevisListObjetsApi().getAllData();
    if (mounted) {
      setState(() {
        user = userModel;
        ligneBudgetaireList = budgets; 
        devObjetList = devisObjetLists;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<DevisModel>(
            future: DevisAPi().getOneData(id),
            builder:
                (BuildContext context, AsyncSnapshot<DevisModel> snapshot) {
              if (snapshot.hasData) {
                DevisModel? data = snapshot.data;
                return addObjetDevisButton(data!);
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
                    child: FutureBuilder<DevisModel>(
                        future: DevisAPi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<DevisModel> snapshot) {
                          if (snapshot.hasData) {
                            DevisModel? data = snapshot.data; 
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
                                          title: "Ticket n° ${data!.id}",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: Column(
                                  children: [
                                    pageDetail(data),
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

  Widget pageDetail(DevisModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        // elevation: 10,
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
                  TitleWidget(title: "Ticket n° ${data.id}"),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              color: Colors.green.shade700,
                              onPressed: () {
                                submitToDG(data);
                              },
                              icon: const Icon(Icons.send)),
                          deleteButton(data),
                          PrintWidget(
                              tooltip: 'Imprimer le document', onPressed: () {})
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              SizedBox(
                height: 300,
                width: double.infinity,
                child: SingleChildScrollView(child: tableDevisListObjet()),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(DevisModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Titre :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.title,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Priorité :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.priority,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Département :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.departement,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Observation',
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: p10,
              ),
              if (data.observation == 'false' && user.departement == "Finances")
                Expanded(child: checkboxRead(data)),
              Expanded(
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
          Divider(color: Colors.amber.shade700),
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

  checkboxRead(DevisModel data) {
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
            submitobservation(data);
          });
          setState(() {
            isLoading = false;
          });
        },
      ),
      title: const Text("Confirmation de payement"),
    );
  }

  Widget deleteButton(DevisModel data) {
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
                await DevisAPi().deleteData(data.id!);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton addObjetDevisButton(DevisModel data) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      tooltip: "Ajout objet",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Ajout votre devis'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            montantGlobal = quantity * montantUnitaire;
            return SizedBox(
              height: 200,
              width: 500,
              child: isLoadingBtn
                  ? loading()
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p20, left: p20),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        labelText: 'Quantité',
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          quantity = (value == "")
                                              ? 1
                                              : double.parse(value);
                                        });
                                      },
                                    )),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p20, left: p20),
                                    child: TextFormField(
                                      controller: designationController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        labelText: 'Désignation',
                                      ),
                                      keyboardType: TextInputType.text,
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p20, left: p20),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        labelText: 'Montant unitaire',
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          montantUnitaire = (value == "")
                                              ? 1
                                              : double.parse(value);
                                        });
                                      },
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p20, left: p20),
                                    child: Column(
                                      children: [
                                        Text("Montant global",
                                            style: TextStyle(
                                                color: Colors.red.shade700)),
                                        Text(
                                            "${NumberFormat.decimalPattern('fr').format(double.parse(montantGlobal.toStringAsFixed(2)))} \$",
                                            style: TextStyle(
                                                color: Colors.red.shade700)),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            );
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() => isLoadingBtn = true);
                submitObjet(data);
              },
              child: isLoadingBtn ? loadingMini() : const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableDevisListObjet() {
    return Table(
      border: TableBorder.all(color: Colors.amber.shade700),
      columnWidths: const {
        0: FixedColumnWidth(50.0), // fixed to 100 width
        1: FlexColumnWidth(300.0),
        2: FixedColumnWidth(150.0), //fixed to 100 width
        3: FixedColumnWidth(150.0),
      },
      children: [
        tableDevisHeader(),
        for (var item in devisObjetList) tableDevisBody(item)
      ],
    );
  }

  TableRow tableDevisBody(DevisListObjetsModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0 * 0.75),
          // decoration:
          //     BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: AutoSizeText(
            double.parse(data.quantity).toStringAsFixed(0),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: bodyMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0 * 0.75),
          // decoration:
          //     BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: AutoSizeText(
            data.designation,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: bodyMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0 * 0.75),
          // decoration:
          //     BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.montantUnitaire).toStringAsFixed(2)))} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: bodyMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0 * 0.75),
          // decoration:
          //     BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.montantGlobal).toStringAsFixed(2)))} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: bodyMedium,
          ),
        ),
      ],
    );
  }

  TableRow tableDevisHeader() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(16.0 * 0.75),
        // decoration:
        //     BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
        child: AutoSizeText(
          "Qty".toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0 * 0.75),
        // decoration:
        //     BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
        child: AutoSizeText(
          "Désignation".toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0 * 0.75),
        // decoration:
        //     BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
        child: AutoSizeText(
          "Montant unitaire".toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0 * 0.75),
        // decoration:
        //     BoxDecoration(border: Border.all(color: Colors.amber.shade700)),
        child: AutoSizeText(
          "Montant global".toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }

  

  Future<void> submitobservation(DevisModel data) async {
    final devisModel = DevisModel(
      id: data.id!,
        title: data.title,
        priority: data.priority,
        departement: data.departement,
        observation: 'true',
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        isSubmit: data.isSubmit,
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
    await DevisAPi().updateData(devisModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Payement effectué avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitToDG(DevisModel data) async {
    final devisModel = DevisModel(
        title: data.title,
        priority: data.priority,
        departement: data.departement,
        observation: 'false',
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        isSubmit: 'true',
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
    await DevisAPi().updateData(devisModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis chez le DG avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitObjet(DevisModel data) async {
    montantGlobal = quantity * montantUnitaire;
    final devisListObjetsModel = DevisListObjetsModel(
      referenceDate: data.createdRef,
      title: data.title,
      quantity: quantity.toString(),
      designation: designationController.text,
      montantUnitaire: montantUnitaire.toString(),
      montantGlobal: montantGlobal.toString(),
    );
    await DevisListObjetsApi().insertData(devisListObjetsModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistré avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }





  Widget approbationWidget(DevisModel data) {
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                                              color: Colors.red.shade700)),
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
                                              color: Colors.green.shade700)),
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
              const SizedBox(height: p20),
              Divider(color: Colors.red[10]),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text("Budget", style: bodyLarge)),
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
                                      Text(data.approbationBudget,
                                          style: bodyLarge.copyWith(
                                              color: Colors.grey.shade700)),
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
                            const SizedBox(height: p20),
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Ligne Budgetaire"),
                                      const SizedBox(height: p20),
                                      Text(data.ligneBudgetaire,
                                          style: bodyLarge.copyWith(
                                              color: Colors.purple.shade700)),
                                    ],
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Ressource"),
                                      const SizedBox(height: p20),
                                      Text(data.ressource,
                                          style: bodyLarge.copyWith(
                                              color: Colors.purple.shade700)),
                                    ],
                                  )),
                            ]),
                            if (data.approbationBudget == '-' &&
                                user.fonctionOccupe == "Directeur de budget")
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Expanded(child: ligneBudgtaireWidget()),
                                      const SizedBox(width: p20),
                                      Expanded(child: resourcesWidget())
                                    ]),
                                    Row(children: [
                                      Expanded(
                                          child: approbationBudgetWidget(data)),
                                      const SizedBox(width: p20),
                                      if (approbationDD == "Unapproved")
                                        Expanded(child: motifBudgetWidget(data))
                                    ]),
                                  ],
                                ),
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
                    Expanded(flex: 1, child: Text("Finance", style: bodyLarge)),
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
                                      Text(data.approbationFin,
                                          style: bodyLarge.copyWith(
                                              color: Colors.blue.shade700)),
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
                            ]),
                            if (data.approbationFin == '-' &&
                                user.fonctionOccupe == "Directeur de finance")
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Row(children: [
                                  Expanded(child: approbationFinWidget(data)),
                                  const SizedBox(width: p20),
                                  if (approbationDD == "Unapproved")
                                    Expanded(child: motifFinWidget(data))
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

  Widget approbationDGWidget(DevisModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p10),
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

  Widget motifDGWidget(DevisModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p10),
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

  Widget approbationDDWidget(DevisModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p10),
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

  Widget motifDDWidget(DevisModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p10),
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

  Widget approbationBudgetWidget(DevisModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p10),
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

  Widget motifBudgetWidget(DevisModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifBudgetController,
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
                    submitBudget(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  Widget approbationFinWidget(DevisModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p10),
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

  Widget motifFinWidget(DevisModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifFinController,
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
      margin: const EdgeInsets.only(bottom: p10),
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
      margin: const EdgeInsets.only(bottom: p10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Ressource',
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

  Future<void> submitDG(DevisModel data) async {
    final devisModel = DevisModel(
        id: data.id!,
        title: data.title,
        priority: data.priority,
        departement: data.departement,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        isSubmit: data.isSubmit,

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
        ressource: '-');
    await DevisAPi().updateData(devisModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitDD(DevisModel data) async {
    final devisModel = DevisModel(
        id: data.id!,
        title: data.title,
        priority: data.priority,
        departement: data.departement,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        isSubmit: data.isSubmit,

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
        ressource: '-');
    await DevisAPi().updateData(devisModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitBudget(DevisModel data) async {
    final devisModel = DevisModel(
        id: data.id!,
        title: data.title,
        priority: data.priority,
        departement: data.departement,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        isSubmit: data.isSubmit,

        approbationDG: data.approbationDG,
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
        ressource: (ressource.toString() == '') ? '-' : ressource.toString());
    await DevisAPi().updateData(devisModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitFin(DevisModel data) async {
    final devisModel = DevisModel(
        id: data.id!,
        title: data.title,
        priority: data.priority,
        departement: data.departement,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        isSubmit: data.isSubmit,

        approbationDG: data.approbationDG,
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
        ressource: data.ressource);
    await DevisAPi().updateData(devisModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
