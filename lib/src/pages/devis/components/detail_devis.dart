import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DetailDevis extends StatefulWidget {
  const DetailDevis({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailDevis> createState() => _DetailDevisState();
}

class _DetailDevisState extends State<DetailDevis> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _approbationKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isChecked = false;

  List<UserModel> userList = [];

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

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

  String? ligneBudgtaire;
  String? resource;
  List<dynamic> listObjets = [];

  @override
  initState() {
    getData();
    agentsColumn();
    agentsRow();
    super.initState();
  }

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
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    final dataUser = await UserApi().getAllData();
    UserModel userModel = await AuthApi().getUserId();
    var budgets = await LIgneBudgetaireApi().getAllData();
    if (mounted) {
      setState(() {
        userList = dataUser;
        user = userModel;
        ligneBudgetaireList = budgets;
      });
    }
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
                    child: FutureBuilder<DevisModel>(
                        future: DevisAPi().getOneData(widget.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<DevisModel> snapshot) {
                          if (snapshot.hasData) {
                            DevisModel? data = snapshot.data;
                            listObjets = data!.list!;
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
                                          title: data.title,
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

  Widget pageDetail(DevisModel data) {
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
                  TitleWidget(title: data.title),
                  Column(
                    children: [
                      Row(
                        children: [
                          deleteButton(data),
                          PrintWidget(
                              tooltip: 'Imprimer le document', onPressed: () {})
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yy").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              SizedBox(
                height: 300,
                width: double.infinity,
                child: tableauList(),
              ),
              infosEditeurWidget(data)
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
              onPressed: () => Navigator.of(context).pop(),
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

  Widget tableauList() {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager!.notifyListeners();
      },
      createHeader: (PlutoGridStateManager header) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            TitleWidget(title: "Devis"),
          ],
        );
      },
    );
  }

  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'N°',
        field: 'id',
        type: PlutoColumnType.number(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 100,
        minWidth: 80,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Nombre',
        field: 'nombre',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Description',
        field: 'description',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 300,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Frais',
        field: 'frais',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
    ];
  }

  Future agentsRow() async {
    List<DevisListObjetModel> dataList = [];
    for (var item in listObjets) {
      dataList.add(DevisListObjetModel.fromJson(item));
    }
    if (mounted) {
      setState(() {
        for (var item in dataList) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'nombre': PlutoCell(value: item.nombre),
            'description': PlutoCell(value: item.description),
            'frais': PlutoCell(value: item.frais)
          }));
          stateManager!.resetCurrentState();
          stateManager!.notifyListeners();
        }
      });
    }
  }

  Widget infosEditeurWidget(DevisModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyLarge;
    List<String> approbationList = ['Approved', 'Unapproved', '-'];

    return SizedBox(
      height: 500,
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
                                  child: Form(
                                    key: _approbationKey,
                                    child: Column(
                                      children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      item
                                                          .fontctionOccupee, // user fonctionOccupe qui a approuve
                                                      textAlign: TextAlign.center,
                                                      style: bodyMedium!.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color:
                                                              Colors.red.shade700))),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'Approbation',
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: bodyMedium
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                ),
                                                                const SizedBox(
                                                                    height: p20),
                                                                SelectableText(
                                                                  item.approbation,
                                                                  style: bodyMedium
                                                                      .copyWith(
                                                                          color: Colors
                                                                              .red
                                                                              .shade700),
                                                                ),
                                                              ],
                                                            )),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'Signature',
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: bodyMedium
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                ),
                                                                const SizedBox(
                                                                    height: p20),
                                                                SelectableText(
                                                                  item.signatureApprobation,
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: bodyMedium,
                                                                ),
                                                              ],
                                                            )),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'Justification',
                                                                  style: bodyMedium
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                ),
                                                                const SizedBox(
                                                                    height: p20),
                                                                SelectableText(
                                                                  item.justification,
                                                                  textAlign: TextAlign
                                                                      .justify,
                                                                  style: bodyMedium,
                                                                ),
                                                              ],
                                                            ))
                                                      ],
                                                    ),
                                                    const SizedBox(height: p20),
                                                    if (item.departement == 'Budgets')
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              flex: 3,
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Ligne budgetaire',
                                                                    style: bodyMedium.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                  ),
                                                                  SelectableText(
                                                                    item.ligneBudgtaire,
                                                                    style: bodyMedium,
                                                                  ),
                                                                ],
                                                              )),
                                                          Expanded(
                                                              flex: 1,
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Resource',
                                                                    style: bodyMedium.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                  ),
                                                                  SelectableText(
                                                                    item.resources,
                                                                    style: bodyMedium,
                                                                  ),
                                                                ],
                                                              ))
                                                        ],
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        Divider(color: Colors.amber.shade700),
                                        const SizedBox(height: p50),
                                        if (int.parse(user.role) == 1 &&
                                            int.parse(user.role) < 2)
                                            if (item.fontctionOccupee.isNotEmpty)
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(user.fonctionOccupe,
                                                          style: bodyMedium.copyWith(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors
                                                                  .blue.shade700))),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                                flex: 3,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      'Approbation',
                                                                      style: bodyMedium.copyWith(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                    ),
                                                                    const SizedBox(
                                                                        height: p20),
                                                                    Container(
                                                                      margin:
                                                                          const EdgeInsets
                                                                                  .only(
                                                                              bottom:
                                                                                  p10,
                                                                              left:
                                                                                  p5),
                                                                      child: Row(
                                                                        children: [
                                                                          Expanded(
                                                                            flex: 1,
                                                                            child: DropdownButtonFormField<
                                                                                String>(
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                labelText:
                                                                                    'Approbation',
                                                                                border:
                                                                                    OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                              ),
                                                                              value:
                                                                                  approbationDGController,
                                                                              isExpanded:
                                                                                  true,
                                                                              items: approbationList.map((String
                                                                                  value) {
                                                                                return DropdownMenuItem<
                                                                                    String>(
                                                                                  value:
                                                                                      value,
                                                                                  child:
                                                                                      Text(value),
                                                                                );
                                                                              }).toList(),
                                                                              onChanged:
                                                                                  (value) {
                                                                                setState(
                                                                                    () {
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
                                                                                  onPressed: () {
                                                                                    submitApprobation(data);
                                                                                  },
                                                                                  icon: Icon(Icons.send, color: Colors.red.shade700)),
                                                                            )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                            if (approbationDGController ==
                                                                'Unapproved')
                                                              Expanded(
                                                                  flex: 3,
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        'Motif',
                                                                        style: bodyMedium.copyWith(
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .bold),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              p20),
                                                                      Container(
                                                                          margin: const EdgeInsets
                                                                                  .only(
                                                                              bottom:
                                                                                  p10,
                                                                              left:
                                                                                  p5),
                                                                          child: Row(
                                                                            children: [
                                                                              Expanded(
                                                                                flex:
                                                                                    3,
                                                                                child:
                                                                                    TextFormField(
                                                                                  controller:
                                                                                      signatureJustificationDGController,
                                                                                  decoration:
                                                                                      InputDecoration(
                                                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                                                    labelText: 'Ecrivez votre motif...',
                                                                                  ),
                                                                                  keyboardType:
                                                                                      TextInputType.multiline,
                                                                                  minLines:
                                                                                      2,
                                                                                  maxLines:
                                                                                      3,
                                                                                  style:
                                                                                      const TextStyle(),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                flex:
                                                                                    1,
                                                                                child: IconButton(
                                                                                    onPressed: () {
                                                                                      final form = _approbationKey.currentState!;
                                                                                      if (form.validate()) {
                                                                                        submitApprobation(data);
                                                                                        form.reset();
                                                                                      }
                                                                                    },
                                                                                    icon: Icon(Icons.send, color: Colors.red.shade700)),
                                                                              )
                                                                            ],
                                                                          )),
                                                                    ],
                                                                  ))
                                                          ],
                                                        ),
                                                        if (data.departement ==
                                                            'Budgets')
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                  flex: 3,
                                                                  child:
                                                                      ligneBudgtaireWidget()),
                                                              const SizedBox(
                                                                  width: p20),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      resourcesWidget()),
                                                              Expanded(
                                                              flex: 1,
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    final form =
                                                                        _approbationKey
                                                                            .currentState!;
                                                                    if (form
                                                                        .validate()) {
                                                                      submitApprobation(
                                                                          data);
                                                                      form.reset();
                                                                    }
                                                                  },
                                                                  icon: Icon(
                                                                      Icons
                                                                          .send,
                                                                      color: Colors
                                                                          .red
                                                                          .shade700)),
                                                            )
                                                            ],
                                                          )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ],
        ));
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
        reference: data.id!,
        title: data.title,
        departement: data.departement,
        fontctionOccupee: user.fonctionOccupe,
        ligneBudgtaire:
            (ligneBudgtaire == null) ? '-' : ligneBudgtaire.toString(),
        resources: (resource == null) ? '-' : resource.toString(),
        approbation: approbationDGController,
        signatureApprobation: user.matricule,
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
        // list: data.list,
        ligneBudgtaire: data.ligneBudgtaire,
        resources: data.resources,
        observation: isChecked,
        approbationDG: data.approbationDG,
        signatureDG: data.signatureDG,
        signatureJustificationDG: data.signatureJustificationDG,
        approbationFin: data.approbationFin,
        signatureFin: data.signatureFin,
        signatureJustificationFin: data.signatureJustificationFin,
        approbationBudget: data.approbationBudget,
        signatureBudget: data.signatureBudget,
        signatureJustificationBudget: data.signatureJustificationBudget,
        approbationDD: data.approbationDD,
        signatureDD: data.signatureDD,
        signatureJustificationDD: data.signatureJustificationDD,
        signature: data.signature,
        created: DateTime.now());
    await DevisAPi().updateData(data.id!, devisModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise à jour avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }


}
