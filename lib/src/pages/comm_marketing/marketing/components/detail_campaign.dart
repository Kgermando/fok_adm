import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class DetailCampaign extends StatefulWidget {
  const DetailCampaign({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<DetailCampaign> createState() => _DetailCampaignState();
}

class _DetailCampaignState extends State<DetailCampaign> {
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

  @override
  initState() {
    getData();
    super.initState();
  }

  CampaignModel? projetModel;
  String? ligneBudgtaire;
  String? resource;
  List<LigneBudgetaireModel> ligneBudgetaireList = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    CampaignModel data = await CampaignApi().getOneData(widget.id!);
    var budgets = await LIgneBudgetaireApi().getAllData();
    setState(() {
      projetModel = data;
      user = userModel;
      ligneBudgetaireList = budgets;
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
                    child: FutureBuilder<CampaignModel>(
                        future: CampaignApi().getOneData(widget.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<CampaignModel> snapshot) {
                          if (snapshot.hasData) {
                            CampaignModel? data = snapshot.data;
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
                                          title: data!.typeProduit,
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
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: ListView(
            controller: _controllerScroll,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              tooltip: 'Modifier',
                              onPressed: () {},
                              icon: const Icon(Icons.edit)),
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
              infosEditeurWidget(data)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(CampaignModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
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
          Row(
            children: [
              Expanded(
                child: Text('Agent Affectés :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Column(
                  children: [
                    SelectableText('${data.agentAffectes.length} agents',
                        textAlign: TextAlign.start, style: bodyMedium),
                    SizedBox(
                        height: 200,
                        child: Wrap(
                          children:
                              List.generate(data.agentAffectes.length, (index) {
                            var agent = data.agentAffectes[index];
                            return SelectableText(agent,
                                textAlign: TextAlign.start, style: bodyMedium);
                          }),
                        )),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Coût de la Campagne :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.coutCampaign,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
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
          Row(
            children: [
              Expanded(
                child: Text('Objetctifs :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.objetctifs,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget infosEditeurWidget(CampaignModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    List<String> dataList = ['Approved', 'Unapproved'];
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Directeur Générale',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
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
                              style: bodySmall,
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
                              style: bodySmall,
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
                              style: bodySmall,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Directeur de Finance',
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold))),
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
                              style: bodySmall,
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
                              style: bodySmall,
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
                              style: bodySmall,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Budget',
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold))),
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
                              style: bodySmall,
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
                            if (data.approbationBudget == '-' &&
                                user!.fonctionOccupe == 'Directeur de budget')
                              Row(
                                children: [
                                  Expanded(child: ligneBudgtaireWidget()),
                                  Expanded(child: ligneBudgtaireWidget())
                                ],
                              )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'Signature',
                              style: bodySmall,
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
                              style: bodySmall,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Directeur de département',
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold))),
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
                              style: bodySmall,
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
                                    labelText: 'Approbation',
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
                              style: bodySmall,
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
                              style: bodySmall,
                            ),
                            if (data.approbationDD == 'Unapproved' &&
                                data.signatureDD != '-')
                              SelectableText(
                                data.signatureJustificationDD.toString(),
                                style: bodyMedium,
                              ),
                            if (data.approbationDD == 'Unapproved' &&
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
                            if (data.approbationDD == 'Unapproved')
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

  Future<void> submitUpdateDG(CampaignModel data) async {
    final campaignModel = CampaignModel(
        typeProduit: data.typeProduit,
        dateDebutEtFin: data.dateDebutEtFin,
        agentAffectes: data.agentAffectes,
        coutCampaign: data.coutCampaign,
        lieuCible: data.lieuCible,
        promotion: data.promotion,
        objetctifs: data.objetctifs,
        ligneBudgtaire: data.ligneBudgtaire,
        resources: data.resources,
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
    await CampaignApi().updateData(data.id!, campaignModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateFIN(CampaignModel data) async {
    final campaignModel = CampaignModel(
       typeProduit: data.typeProduit,
      dateDebutEtFin: data.dateDebutEtFin,
      agentAffectes: data.agentAffectes,
      coutCampaign: data.coutCampaign,
      lieuCible: data.lieuCible,
      promotion: data.promotion,
      objetctifs: data.objetctifs,
      ligneBudgtaire: data.ligneBudgtaire,
      resources: data.resources,
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
    await CampaignApi().updateData(data.id!, campaignModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateBudget(CampaignModel data) async {
    final campaignModel = CampaignModel(
        typeProduit: data.typeProduit,
        dateDebutEtFin: data.dateDebutEtFin,
        agentAffectes: data.agentAffectes,
        coutCampaign: data.coutCampaign,
        lieuCible: data.lieuCible,
        promotion: data.promotion,
        objetctifs: data.objetctifs,
        ligneBudgtaire: data.ligneBudgtaire,
        resources: data.resources,
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
    await CampaignApi().updateData(data.id!, campaignModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateDD(CampaignModel data) async {
    final campaignModel = CampaignModel(
        typeProduit: data.typeProduit,
        dateDebutEtFin: data.dateDebutEtFin,
        agentAffectes: data.agentAffectes,
        coutCampaign: data.coutCampaign,
        lieuCible: data.lieuCible,
        promotion: data.promotion,
        objetctifs: data.objetctifs,
        ligneBudgtaire: data.ligneBudgtaire,
        resources: data.resources,
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
    
    await CampaignApi().updateData(data.id!, campaignModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}