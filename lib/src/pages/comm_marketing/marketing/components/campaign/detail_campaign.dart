import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/components/table_agent_projet.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailCampaign extends StatefulWidget {
  const DetailCampaign({Key? key}) : super(key: key);

  @override
  State<DetailCampaign> createState() => _DetailCampaignState();
}

class _DetailCampaignState extends State<DetailCampaign> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;
  bool isChecked = false;

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

  String? ligneBudgtaire;
  String? resource;
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
    setState(() {
      user = userModel;
      ligneBudgetaireList = budgets;
      approbList = approbations;
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
                    child: FutureBuilder<CampaignModel>(
                        future: CampaignApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<CampaignModel> snapshot) {
                          if (snapshot.hasData) {
                            CampaignModel? data = snapshot.data;
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
                                          title: data!.typeProduit,
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
                            return Center(child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(CampaignModel data) {
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
              color: Colors.amber.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: data.typeProduit),
                  Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              editButton(data),
                              PrintWidget(
                                  tooltip: 'Imprimer le document',
                                  onPressed: () {})
                            ],
                          ),
                          SelectableText(
                              DateFormat("dd-MM-yyyy HH:mm")
                                  .format(data.created),
                              textAlign: TextAlign.start),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              SizedBox(
                  height: 500,
                  child: ListAgentProjet(createdRef: data.createdRef)),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget editButton(CampaignModel data) {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.red.shade700),
      tooltip: "Modification",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de modifier ceci?'),
          content:
              const Text('Cette action permet de supprimer définitivement.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pushNamed(
                    context, ComMarketingRoutes.comMarketingCampaignUpdate,
                    arguments: data);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataWidget(CampaignModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          const SizedBox(
            height: p20,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Type Produit :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.typeProduit,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Date Debut Et Fin :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.dateDebutEtFin,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Coût de la Campagne :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText("${data.coutCampaign} \$",
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Lieu Cible :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.lieuCible,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Promotion :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.promotion,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('objectifs :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.objectifs,
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

  checkboxRead(CampaignModel data) {
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

  Widget approbationForm(CampaignModel data) {
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
                                      // final form =
                                      //     _approbationKey.currentState!;
                                      // if (form.validate()) {
                                      //   submitApprobation(data);
                                      //   form.reset();
                                      // }
                                      submitApprobation(data);
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

  Future submitApprobation(CampaignModel data) async {
    final approbation = ApprobationModel(
        reference: data.created,
        title: data.typeProduit,
        departement: 'Commercial et Marketing',
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

  Future<void> submitobservation(CampaignModel data) async {
    final campaignModel = CampaignModel(
      id: data.id!,
        typeProduit: data.typeProduit,
        dateDebutEtFin: data.dateDebutEtFin,
        coutCampaign: data.coutCampaign,
        lieuCible: data.lieuCible,
        promotion: data.promotion,
        objectifs: data.objectifs,
        observation: 'true',
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now());
    await CampaignApi().updateData(campaignModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise à jour avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
