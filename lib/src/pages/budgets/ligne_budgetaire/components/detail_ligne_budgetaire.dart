import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/exploitations/projets_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/exploitations/projet_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DetailLigneBudgetaire extends StatefulWidget {
  const DetailLigneBudgetaire({Key? key}) : super(key: key);

  @override
  State<DetailLigneBudgetaire> createState() => _DetailLigneBudgetaireState();
}

class _DetailLigneBudgetaireState extends State<DetailLigneBudgetaire> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  List<PlutoColumn> columns = [];
  List<PlutoRow> rowSalaires = [];
  List<PlutoRow> rowCampaigns = [];
  List<PlutoRow> rowProjets = [];
  List<PlutoRow> rowEtatBesion = [];
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

  @override
  initState() {
    agentsColumn();
    getData();
    salaireRow();
    campaignRow();
    projetRow();
    etatBesionRow();
    super.initState();
  }

  String? ligneBudgtaire;
  String? resource;
  List<LigneBudgetaireModel> ligneBudgetaireList = [];
  List<CampaignModel> dataCampaignList = [];
  List<DevisModel> dataDevisList = [];
  List<ProjetModel> dataProjetList = [];
  List<PaiementSalaireModel> dataSalaireList = [];

  LigneBudgetaireModel? ligneBudgetaireModel;
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
    var campaigns = await CampaignApi().getAllData();
    var devis = await DevisAPi().getAllData();
    var projets = await ProjetsApi().getAllData();
    var salaires = await PaiementSalaireApi().getAllData();
    if (!mounted) return;
    setState(() {
      user = userModel;
      ligneBudgetaireList = budgets;
      dataCampaignList = campaigns
          .where((element) =>
              element.approbationDG == 'Approuved' &&
              element.approbationDD == 'Approuved' &&
              element.approbationBudget == '-')
          .toList();
      dataDevisList = devis
          .where((element) =>
              element.approbationDG == 'Approuved' &&
              element.approbationDD == 'Approuved' &&
              element.approbationBudget == '-')
          .toList();
      dataProjetList = projets
          .where((element) =>
              element.approbationDG == 'Approuved' &&
              element.approbationDD == 'Approuved' &&
              element.approbationBudget == '-')
          .toList();
      dataSalaireList = salaires
          .where((element) =>
              element.createdAt.month == DateTime.now().month &&
              element.createdAt.year == DateTime.now().year &&
              element.approbationDG == 'Approuved' &&
              element.approbationDD == 'Approuved' &&
              element.approbationBudget == '-')
          .toList();
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
                    child: FutureBuilder<LigneBudgetaireModel>(
                        future: LIgneBudgetaireApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<LigneBudgetaireModel> snapshot) {
                          if (snapshot.hasData) {
                            LigneBudgetaireModel? data = snapshot.data;
                            ligneBudgetaireModel = data;
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
                                          title: data!.nomLigneBudgetaire,
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: Scrollbar(
                                        controller: _controllerScroll,
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

  Widget pageDetail(LigneBudgetaireModel data) {
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
                  TitleWidget(title: data.nomLigneBudgetaire),
                  Column(
                    children: [
                      PrintWidget(
                          tooltip: 'Imprimer le document', onPressed: () {}),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: p30,
              ),
              dataWidget(data),
              soldeBudgets(data),
              const SizedBox(
                height: p20,
              ),
              if (dataSalaireList.isNotEmpty)
                Text("Salaire", style: Theme.of(context).textTheme.headline6),
              if (dataSalaireList.isNotEmpty) tableSalaires(data),
              if (dataSalaireList.isNotEmpty)
                const SizedBox(
                  height: p20,
                ),
              if (dataDevisList.isNotEmpty)
                Text("Etat de besoins",
                    style: Theme.of(context).textTheme.headline6),
              if (dataDevisList.isNotEmpty) tableEtatBesions(data),
              if (dataDevisList.isNotEmpty)
                const SizedBox(
                  height: p20,
                ),
              if (dataProjetList.isNotEmpty)
                Text("Exploitation",
                    style: Theme.of(context).textTheme.headline6),
              if (dataProjetList.isNotEmpty) tableProjets(data),
              if (dataProjetList.isNotEmpty)
                const SizedBox(
                  height: p20,
                ),
              if (dataCampaignList.isNotEmpty)
                Text("Marketing", style: Theme.of(context).textTheme.headline6),
              if (dataCampaignList.isNotEmpty) tableCampaigns(data),
              if (dataCampaignList.isNotEmpty)
                const SizedBox(
                  height: p20,
                ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(LigneBudgetaireModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Ligne Budgetaire :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.nomLigneBudgetaire,
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
                child: Text('Periode Budgetaire :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(
                    DateFormat("dd-MM-yyyy")
                        .format(DateTime.parse(data.periodeBudget)),
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Unité Choisie :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.uniteChoisie,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Nombre d\'unité :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.nombreUnite,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Coût Unitaire :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.coutUnitaire))} \$",
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          const SizedBox(height: p20),
          Row(
            children: [
              Expanded(
                child: Text('Coût Total :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.coutTotal))} \$",
                    textAlign: TextAlign.start,
                    style: headline6),
              )
            ],
          ),
          const SizedBox(height: p20),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Caisse :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.caisse))} \$",
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Banque :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.banque))} \$",
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Financement Propre :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.finPropre))} \$",
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Reste à trouver :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.finExterieur))} \$",
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(color: Colors.red.shade700)),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
        ],
      ),
    );
  }

  Widget soldeBudgets(LigneBudgetaireModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    // List<String> dataList = ['caisse', 'banque', 'finPropre', 'finExterieur'];
    double caisse = 0.0;
    double banque = 0.0;
    double finPropre = 0.0;
    double finExterieur = 0.0;

    double caisseetatBesion = 0.0;
    double banqueetatBesion = 0.0;
    double finPropreetatBesion = 0.0;
    double finExterieuretatBesion = 0.0;

    double caissesalaire = 0.0;
    double banquesalaire = 0.0;
    double finPropresalaire = 0.0;
    double finExterieursalaire = 0.0;

    double caisseCampaign = 0.0;
    double banqueCampaign = 0.0;
    double finPropreCampaign = 0.0;
    double finExterieurCampaign = 0.0;

    double caisseProjet = 0.0;
    double banqueProjet = 0.0;
    double finPropreProjet = 0.0;
    double finExterieurProjet = 0.0;

    List<PaiementSalaireModel> salairecaisseList = [];
    List<PaiementSalaireModel> salairebanqueList = [];
    List<PaiementSalaireModel> salairefinPropreList = [];
    List<PaiementSalaireModel> salairefinExterieurList = [];

    salairecaisseList = dataSalaireList
        .where((element) =>
            element.departement == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.createdAt.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "caisse")
        .toList();
    salairebanqueList = dataSalaireList
        .where((element) =>
            element.departement == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.createdAt.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "banque")
        .toList();
    salairefinPropreList = dataSalaireList
        .where((element) =>
            element.departement == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.createdAt.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "finPropre")
        .toList();
    salairefinExterieurList = dataSalaireList
        .where((element) =>
            element.departement == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.createdAt.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "finExterieur")
        .toList();

    for (var item in salairecaisseList) {
      caissesalaire += double.parse(item.salaire);
    }
    for (var item in salairebanqueList) {
      banquesalaire += double.parse(item.salaire);
    }
    for (var item in salairefinPropreList) {
      finPropresalaire += double.parse(item.salaire);
    }
    for (var item in salairefinExterieurList) {
      finExterieursalaire += double.parse(item.salaire);
    }

    List<CampaignModel> campaigncaisseList = [];
    List<CampaignModel> campaignbanqueList = [];
    List<CampaignModel> campaignfinPropreList = [];
    List<CampaignModel> campaignfinExterieurList = [];
    campaigncaisseList = dataCampaignList
        .where((element) =>
            "Commercial et Marketing" == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.created.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "caisse")
        .toList();
    campaignbanqueList = dataCampaignList
        .where((element) =>
            "Commercial et Marketing" == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.created.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "banque")
        .toList();
    campaignfinPropreList = dataCampaignList
        .where((element) =>
            "Commercial et Marketing" == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.created.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "finPropre")
        .toList();
    campaignfinExterieurList = dataCampaignList
        .where((element) =>
            "Commercial et Marketing" == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.created.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "finExterieur")
        .toList();

    for (var item in campaigncaisseList) {
      caisseCampaign += double.parse(item.coutCampaign);
    }
    for (var item in campaignbanqueList) {
      banqueCampaign += double.parse(item.coutCampaign);
    }
    for (var item in campaignfinPropreList) {
      finPropreCampaign += double.parse(item.coutCampaign);
    }
    for (var item in campaignfinExterieurList) {
      finExterieurCampaign += double.parse(item.coutCampaign);
    }

    List<ProjetModel> projetcaisseList = [];
    List<ProjetModel> projetbanqueList = [];
    List<ProjetModel> projetfinPropreList = [];
    List<ProjetModel> projetfinExterieurList = [];
    projetcaisseList = dataProjetList
        .where((element) =>
            "Exploitations" == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.created.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "caisse")
        .toList();
    projetbanqueList = dataProjetList
        .where((element) =>
            "Exploitations" == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.created.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "banque")
        .toList();
    projetfinPropreList = dataProjetList
        .where((element) =>
            "Exploitations" == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.created.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "finPropre")
        .toList();
    projetfinExterieurList = dataProjetList
        .where((element) =>
            "Exploitations" == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.created.isBefore(
                DateTime.parse(ligneBudgetaireModel!.periodeBudget)) &&
            element.ressource == "finExterieur")
        .toList();

    for (var item in projetcaisseList) {
      caisseProjet += double.parse(item.coutProjet);
    }
    for (var item in projetbanqueList) {
      banqueProjet += double.parse(item.coutProjet);
    }
    for (var item in projetfinPropreList) {
      finPropreProjet += double.parse(item.coutProjet);
    }
    for (var item in projetfinExterieurList) {
      finExterieurProjet += double.parse(item.coutProjet);
    }

    // Total par ressources
    caisse = caisseetatBesion + caissesalaire + caisseCampaign + caisseProjet;
    banque = banqueetatBesion + banquesalaire + banqueCampaign + banqueProjet;
    finPropre = finPropreetatBesion +
        finPropresalaire +
        finPropreCampaign +
        finPropreProjet;
    finExterieur = finExterieuretatBesion +
        finExterieursalaire +
        finExterieurCampaign +
        finExterieurProjet;

    double caisseSolde = double.parse(data.caisse) - caisse;
    double banqueSolde = double.parse(data.banque) - banque;
    double finPropreSolde = double.parse(data.finPropre) - finPropre;
    double finExterieurSolde = double.parse(data.finExterieur) - finExterieur;

    return Row(children: [
      Expanded(
          child: Column(
        children: [
          const Text("Solde Caisse",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(
              "${NumberFormat.decimalPattern('fr').format(caisseSolde)} \$",
              textAlign: TextAlign.center,
              style: headline6),
        ],
      )),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(
            color: Colors.amber.shade700,
            width: 2,
          ),
        )),
        child: Column(
          children: [
            const Text("Solde Banque",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
                "${NumberFormat.decimalPattern('fr').format(banqueSolde)} \$",
                textAlign: TextAlign.center,
                style: headline6),
          ],
        ),
      )),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(
            color: Colors.amber.shade700,
            width: 2,
          ),
        )),
        child: Column(
          children: [
            const Text("Solde Fonds Propres",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
                "${NumberFormat.decimalPattern('fr').format(finPropreSolde)} \$",
                textAlign: TextAlign.center,
                style: headline6),
          ],
        ),
      )),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(
            color: Colors.amber.shade700,
            width: 2,
          ),
        )),
        child: Column(
          children: [
            const Text("Solde Reste à trouver",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
                "${NumberFormat.decimalPattern('fr').format(finExterieurSolde)} \$",
                textAlign: TextAlign.center,
                style: headline6!.copyWith(color: Colors.red.shade700)),
          ],
        ),
      )),
    ]);
  }

  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'Id',
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
        title: 'Designation',
        field: 'designation',
        type: PlutoColumnType.number(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 80,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Département',
        field: 'departement',
        type: PlutoColumnType.number(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 80,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Date',
        field: 'created',
        type: PlutoColumnType.date(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
    ];
  }

  Future salaireRow() async {
    List<PaiementSalaireModel> dataList = [];

    dataList = dataSalaireList
        .where((element) =>
            element.departement == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.createdAt
                .isBefore(DateTime.parse(ligneBudgetaireModel!.periodeBudget)))
        .toList();

    if (mounted) {
      setState(() {
        for (var item in dataList) {
          rowSalaires.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'designation': PlutoCell(value: "${item.prenom} ${item.nom}"),
            'departement': PlutoCell(value: item.departement),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy HH:mm").format(item.createdAt))
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }

  Future campaignRow() async {
    List<CampaignModel> dataList = [];
    dataList = dataCampaignList
        .where((element) =>
            "Commercial et Marketing" == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.created
                .isBefore(DateTime.parse(ligneBudgetaireModel!.periodeBudget)))
        .toList();

    if (mounted) {
      setState(() {
        for (var item in dataList) {
          rowCampaigns.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'designation': PlutoCell(value: item.typeProduit),
            'departement': PlutoCell(value: "Commercial et Marketing"),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy HH:mm").format(item.created))
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }

  Future projetRow() async {
    List<ProjetModel> dataList = [];
     dataList = dataProjetList
        .where((element) =>
            "Exploitations" == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.created
                .isBefore(DateTime.parse(ligneBudgetaireModel!.periodeBudget)))
        .toList();

    if (mounted) {
      setState(() {
        for (var item in dataList) {
          rowProjets.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'designation': PlutoCell(value: item.nomProjet),
            'departement': PlutoCell(value: "Exploitations"),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy HH:mm").format(item.created))
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }

  Future etatBesionRow() async {
    List<DevisModel> dataList = [];
    dataList = dataDevisList
        .where((element) =>
            element.departement == ligneBudgetaireModel!.departement &&
            element.ligneBudgetaire == ligneBudgetaireModel!.nomLigneBudgetaire &&
            element.created
                .isBefore(DateTime.parse(ligneBudgetaireModel!.periodeBudget)))
        .toList();
    if (mounted) {
      setState(() {
        for (var item in dataList) {
          rowEtatBesion.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'designation': PlutoCell(value: item.title),
            'departement': PlutoCell(value: item.departement),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy HH:mm").format(item.created))
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }

  Widget tableSalaires(LigneBudgetaireModel data) {
    return SizedBox(
      height: 400,
      child: PlutoGrid(
        columns: columns,
        rows: rowSalaires,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager!.setShowColumnFilter(true);
          stateManager!.notifyListeners();
        },
        createHeader: (PlutoGridStateManager header) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [PrintWidget(onPressed: () {})],
          );
        },
        configuration: PlutoGridConfiguration(
          columnFilterConfig: PlutoGridColumnFilterConfig(
            filters: const [
              ...FilterHelper.defaultFilters,
              // custom filter
              ClassFilterImplemented(),
            ],
            resolveDefaultColumnFilter: (column, resolver) {
              if (column.field == 'id') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'designation') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'departement') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'created') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              }
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            },
          ),
        ),
      ),
    );
  }

  Widget tableEtatBesions(LigneBudgetaireModel data) {
    return SizedBox(
      height: 400,
      child: PlutoGrid(
        columns: columns,
        rows: rowEtatBesion,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager!.setShowColumnFilter(true);
          stateManager!.notifyListeners();
        },
        createHeader: (PlutoGridStateManager header) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [PrintWidget(onPressed: () {})],
          );
        },
        configuration: PlutoGridConfiguration(
          columnFilterConfig: PlutoGridColumnFilterConfig(
            filters: const [
              ...FilterHelper.defaultFilters,
              // custom filter
              ClassFilterImplemented(),
            ],
            resolveDefaultColumnFilter: (column, resolver) {
              if (column.field == 'id') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'designation') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'departement') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'created') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              }
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            },
          ),
        ),
      ),
    );
  }

  Widget tableCampaigns(LigneBudgetaireModel data) {
    return SizedBox(
      height: 400,
      child: PlutoGrid(
        columns: columns,
        rows: rowCampaigns,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager!.setShowColumnFilter(true);
          stateManager!.notifyListeners();
        },
        createHeader: (PlutoGridStateManager header) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [PrintWidget(onPressed: () {})],
          );
        },
        configuration: PlutoGridConfiguration(
          columnFilterConfig: PlutoGridColumnFilterConfig(
            filters: const [
              ...FilterHelper.defaultFilters,
              // custom filter
              ClassFilterImplemented(),
            ],
            resolveDefaultColumnFilter: (column, resolver) {
              if (column.field == 'id') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'designation') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'departement') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'created') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              }
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            },
          ),
        ),
      ),
    );
  }

  Widget tableProjets(LigneBudgetaireModel data) {
    return SizedBox(
      height: 400,
      child: PlutoGrid(
        columns: columns,
        rows: rowProjets,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager!.setShowColumnFilter(true);
          stateManager!.notifyListeners();
        },
        createHeader: (PlutoGridStateManager header) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [PrintWidget(onPressed: () {})],
          );
        },
        configuration: PlutoGridConfiguration(
          columnFilterConfig: PlutoGridColumnFilterConfig(
            filters: const [
              ...FilterHelper.defaultFilters,
              // custom filter
              ClassFilterImplemented(),
            ],
            resolveDefaultColumnFilter: (column, resolver) {
              if (column.field == 'id') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'designation') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'departement') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'created') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              }
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            },
          ),
        ),
      ),
    );
  }
}
