import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/devis/devis_list_objets_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
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
  final GlobalKey<FormState> _approbationKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();
  bool isLoadingBtn = false;

  double quantity = 0.0;
  final TextEditingController designationController = TextEditingController();
  double montantUnitaire = 0.0;
  double montantGlobal = 0.0;

  String approbationDGController = '-';
  TextEditingController signatureJustificationDGController =
      TextEditingController();

  String? ligneBudgtaire;
  String? resource;

  @override
  initState() {
    getData();
    super.initState();
  }

  List<DevisListObjetsModel> devisObjetList = [];
  List<DevisListObjetsModel> devObjetList = [];
  List<LigneBudgetaireModel> ligneBudgetaireList = [];
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
      created: DateTime.now());
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
    var approbations = await ApprobationApi().getAllData();
    var devisObjetLists = await DevisListObjetsApi().getAllData();
    if (mounted) {
      setState(() {
        user = userModel;
        ligneBudgetaireList = budgets;
        approbList = approbations;
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
                            devisObjetList = devObjetList
                                .where((element) =>
                                    element
                                        .referenceDate.microsecondsSinceEpoch ==
                                    data!.createdRef.microsecondsSinceEpoch)
                                .toList();
                            approbationData = approbList
                                .where((element) =>
                                    element.reference.microsecondsSinceEpoch ==
                                    data!.created.microsecondsSinceEpoch)
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
                                    if (approbationData.isNotEmpty)
                                      infosEditeurWidget(),
                                    const SizedBox(height: p10),
                                    if (int.parse(user.role) <= 2)
                                      if (approb.fontctionOccupee !=
                                          user.fonctionOccupe)
                                        approbationForm(data),
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
              if (!data.observation && user.departement == "Finances")
                Expanded(child: checkboxRead(data)),
              Expanded(
                  child: (data.observation)
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
    isChecked = data.observation;
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

  Widget approbationForm(DevisModel data) {
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
                                                      final form =
                                                          _approbationKey
                                                              .currentState!;
                                                      if (form.validate()) {
                                                        submitApprobation(data);
                                                        form.reset();
                                                      }
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
                        if (user.departement == 'Budgets')
                          Row(
                            children: [
                              Expanded(flex: 3, child: ligneBudgtaireWidget()),
                              const SizedBox(width: p20),
                              Expanded(flex: 1, child: resourcesWidget()),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                    tooltip: 'Approuvé',
                                    onPressed: () {
                                      final form =
                                          _approbationKey.currentState!;
                                      if (form.validate()) {
                                        submitApprobation(data);
                                        form.reset();
                                      }
                                    },
                                    icon: Icon(Icons.send,
                                        color: Colors.red.shade700)),
                              )
                            ],
                          )
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
        value: resource,
        isExpanded: true,
        items: dataList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            resource = value!;
          });
        },
      ),
    );
  }

  Future submitApprobation(DevisModel data) async {
    final approbation = ApprobationModel(
        reference: data.createdRef,
        title: data.title,
        departement: data.departement,
        fontctionOccupee: user.fonctionOccupe,
        ligneBudgtaire:
            (ligneBudgtaire == null) ? '-' : ligneBudgtaire.toString(),
        resources: (resource == null) ? '-' : resource.toString(),
        approbation: approbationDGController,
        justification: signatureJustificationDGController.text,
        signature: user.matricule,
        created: DateTime.now());
    await ApprobationApi().insertData(approbation);
    Navigator.of(context).pop();
  }

  Future<void> submitobservation(DevisModel data) async {
    final devisModel = DevisModel(
        title: data.title,
        priority: data.priority,
        departement: data.departement,
        observation: isChecked,
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        isSubmit: false);
    await DevisAPi().updateData(data.id!, devisModel);
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
        observation: isChecked,
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        isSubmit: true);
    await DevisAPi().updateData(data.id!, devisModel);
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
}
