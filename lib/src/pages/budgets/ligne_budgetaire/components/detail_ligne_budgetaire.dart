import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/devis/devis_list_objets_api.dart';
import 'package:fokad_admin/src/api/exploitations/projets_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/api/rh/trans_rest_agents_api.dart';
import 'package:fokad_admin/src/api/rh/transport_restaurant_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/devis/devis_list_objets_model.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/exploitations/projet_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
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
    getData();
    super.initState();
  }

  List<CampaignModel> dataCampaignList = [];
  List<DevisModel> dataDevisList = [];
  List<DevisListObjetsModel> devisListObjetsList = []; // avec montant
  List<ProjetModel> dataProjetList = [];
  List<PaiementSalaireModel> dataSalaireList = [];
  List<TransportRestaurationModel> dataTransRestList = [];
  List<TransRestAgentsModel> tansRestList = []; // avec montant

  Future<void> getData() async { 
    var campaigns = await CampaignApi().getAllData();
    var devis = await DevisAPi().getAllData();
    var projets = await ProjetsApi().getAllData();
    var salaires = await PaiementSalaireApi().getAllData();
    var transRests = await TransportRestaurationApi().getAllData();
    var devisListObjets = await DevisListObjetsApi().getAllData();
    var transRestAgents = await TransRestAgentsApi().getAllData();
    if (!mounted) return;
    setState(() { 
      devisListObjetsList = devisListObjets;
      tansRestList = transRestAgents;
      dataCampaignList = campaigns
          .where((element) =>
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == '-')
          .toList();
      dataDevisList = devis
          .where((element) =>
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == '-')
          .toList();
      dataProjetList = projets
          .where((element) =>
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == '-')
          .toList();
      dataSalaireList = salaires
          .where((element) =>
              element.createdAt.month == DateTime.now().month &&
              element.createdAt.year == DateTime.now().year &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == '-')
          .toList();
      dataTransRestList = transRests
          .where((element) =>
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
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
                            // ligneBudgetaireModel = data;
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
                            return Center(child: loading());
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
                      // PrintWidget(
                      //     tooltip: 'Imprimer le document', onPressed: () {}),
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
                        .format(data.periodeBudget),
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
    // Total des lignes budgetaires
    double caisse = 0.0;
    double banque = 0.0;
    double finExterieur = 0.0;

    // Campaigns
    double caisseCampaign = 0.0;
    double banqueCampaign = 0.0;
    double finExterieurCampaign = 0.0;
    // Etat de besoins
    double caisseEtatBesion = 0.0;
    double banqueEtatBesion = 0.0;
    double finExterieurEtatBesion = 0.0;
    // Exploitations
    double caisseProjet = 0.0;
    double banqueProjet = 0.0;
    double finExterieurProjet = 0.0;
    // Salaires
    double caisseSalaire = 0.0;
    double banqueSalaire = 0.0;
    double finExterieursalaire = 0.0;
    // Transports & Restaurations
    double caisseTransRest = 0.0;
    double banqueTransRest = 0.0;
    double finExterieurTransRest = 0.0;

    // Campaigns
    List<CampaignModel> campaignCaisseList = [];
    List<CampaignModel> campaignBanqueList = [];
    List<CampaignModel> campaignfinExterieurList = [];

    // Etat de besoins
    List<DevisListObjetsModel> devisCaisseList = [];
    List<DevisListObjetsModel> devisBanqueList = [];
    List<DevisListObjetsModel> devisfinExterieurList = [];

    // Exploitations
    List<ProjetModel> projetCaisseList = [];
    List<ProjetModel> projetBanqueList = [];
    List<ProjetModel> projetfinExterieurList = [];

    // Salaires
    List<PaiementSalaireModel> salaireCaisseList = [];
    List<PaiementSalaireModel> salaireBanqueList = [];
    List<PaiementSalaireModel> salairefinExterieurList = [];

    // Transports & Restaurations
    List<TransRestAgentsModel> transRestCaisseList = [];
    List<TransRestAgentsModel> transRestBanqueList = [];
    List<TransRestAgentsModel> transRestFinExterieurList = [];

    // Campaigns
    campaignCaisseList = dataCampaignList
        .where((element) =>
            data.departement == "Commercial et Marketing" &&
            element.ligneBudgetaire == data.nomLigneBudgetaire &&
            element.created.isBefore(data.periodeBudget) &&
            element.ressource == "caisse")
        .toList();
    campaignBanqueList = dataCampaignList
        .where((element) =>
            data.departement == "Commercial et Marketing" &&
            element.ligneBudgetaire == data.nomLigneBudgetaire &&
            element.created.isBefore(data.periodeBudget) &&
            element.ressource == "banque")
        .toList();
    campaignfinExterieurList = dataCampaignList
        .where((element) =>
            data.departement == "Commercial et Marketing" &&
            "Commercial et Marketing" == data.departement &&
            element.ligneBudgetaire == data.nomLigneBudgetaire &&
            element.created.isBefore(data.periodeBudget) &&
            element.ressource == "finExterieur")
        .toList();

    // Etat de Besoins
    for (var item in dataDevisList) {
      devisCaisseList = devisListObjetsList
          .where((element) =>
              data.departement == item.departement &&
              element.referenceDate.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.ligneBudgetaire == data.nomLigneBudgetaire &&
              item.created.isBefore(data.periodeBudget) &&
              item.ressource == "caisse")
          .toList();
      devisBanqueList = devisListObjetsList
          .where((element) =>
              data.departement == item.departement &&
              element.referenceDate.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.ligneBudgetaire == data.nomLigneBudgetaire &&
              item.created.isBefore(data.periodeBudget) &&
              item.ressource == "banque")
          .toList();
      devisfinExterieurList = devisListObjetsList
          .where((element) =>
              data.departement == item.departement &&
              element.referenceDate.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.ligneBudgetaire == data.nomLigneBudgetaire &&
              item.created.isBefore(data.periodeBudget) &&
              item.ressource == "finExterieur")
          .toList();
    }

    // Exploitations
    projetCaisseList = dataProjetList
        .where((element) =>
            data.departement == "Exploitations" &&
            element.ligneBudgetaire == data.nomLigneBudgetaire &&
            element.created.isBefore(data.periodeBudget) &&
            element.ressource == "caisse")
        .toList();
    projetBanqueList = dataProjetList
        .where((element) =>
            data.departement == "Exploitations" &&
            element.ligneBudgetaire == data.nomLigneBudgetaire &&
            element.created.isBefore(data.periodeBudget) &&
            element.ressource == "banque")
        .toList();
    projetfinExterieurList = dataProjetList
        .where((element) =>
            data.departement == "Exploitations" &&
            element.ligneBudgetaire == data.nomLigneBudgetaire &&
            element.created.isBefore(data.periodeBudget) &&
            element.ressource == "finExterieur")
        .toList();

    // Salaires
    salaireCaisseList = dataSalaireList
        .where((element) =>
            data.departement == element.departement &&
            element.ligneBudgetaire == data.nomLigneBudgetaire &&
            element.createdAt.isBefore(data.periodeBudget) &&
            element.ressource == "caisse")
        .toList();
    salaireBanqueList = dataSalaireList
        .where((element) =>
            data.departement == element.departement &&
            element.ligneBudgetaire == data.nomLigneBudgetaire &&
            element.createdAt.isBefore(data.periodeBudget) &&
            element.ressource == "banque")
        .toList();
    salairefinExterieurList = dataSalaireList
        .where((element) =>
            data.departement == element.departement &&
            element.ligneBudgetaire == data.nomLigneBudgetaire &&
            element.createdAt.isBefore(data.periodeBudget) &&
            element.ressource == "finExterieur")
        .toList();

    // Transports & Restaurations
    for (var item in dataTransRestList) {
      transRestCaisseList = tansRestList
          .where((element) =>
              data.departement == "'Ressources Humaines'" &&
              element.reference.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.ligneBudgetaire == data.nomLigneBudgetaire &&
              item.created.isBefore(data.periodeBudget) &&
              item.ressource == "caisse")
          .toList();
      transRestBanqueList = tansRestList
          .where((element) =>
              data.departement == "'Ressources Humaines'" &&
              element.reference.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.ligneBudgetaire == data.nomLigneBudgetaire &&
              item.created.isBefore(data.periodeBudget) &&
              item.ressource == "banque")
          .toList();
      transRestFinExterieurList = tansRestList
          .where((element) =>
              data.departement == "'Ressources Humaines'" &&
              element.reference.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.ligneBudgetaire == data.nomLigneBudgetaire &&
              item.created.isBefore(data.periodeBudget) &&
              item.ressource == "finExterieur")
          .toList();
    }

    // Salaires
    for (var item in salaireCaisseList) {
      caisseSalaire += double.parse(item.salaire);
    }
    for (var item in salaireBanqueList) {
      banqueSalaire += double.parse(item.salaire);
    }
    for (var item in salairefinExterieurList) {
      finExterieursalaire += double.parse(item.salaire);
    }

    // Campaigns
    for (var item in campaignCaisseList) {
      caisseCampaign += double.parse(item.coutCampaign);
    }
    for (var item in campaignBanqueList) {
      banqueCampaign += double.parse(item.coutCampaign);
    }
    for (var item in campaignfinExterieurList) {
      finExterieurCampaign += double.parse(item.coutCampaign);
    }

    // Exploitations
    for (var item in projetCaisseList) {
      caisseProjet += double.parse(item.coutProjet);
    }
    for (var item in projetBanqueList) {
      banqueProjet += double.parse(item.coutProjet);
    }
    for (var item in projetfinExterieurList) {
      finExterieurProjet += double.parse(item.coutProjet);
    }

    // Etat de Besoins
    for (var item in devisCaisseList) {
      caisseEtatBesion += double.parse(item.montantGlobal);
    }
    for (var item in devisBanqueList) {
      banqueEtatBesion += double.parse(item.montantGlobal);
    }
    for (var item in devisfinExterieurList) {
      finExterieurEtatBesion += double.parse(item.montantGlobal);
    }

    // Transports & Restaurations
    for (var item in transRestCaisseList) {
      caisseTransRest += double.parse(item.montant);
    }
    for (var item in transRestBanqueList) {
      banqueTransRest += double.parse(item.montant);
    }
    for (var item in transRestFinExterieurList) {
      finExterieurTransRest += double.parse(item.montant);
    }

    // Total par ressources
    caisse = caisseEtatBesion +
        caisseSalaire +
        caisseCampaign +
        caisseProjet +
        caisseTransRest;

    banque = banqueEtatBesion +
        banqueSalaire +
        banqueCampaign +
        banqueProjet +
        banqueTransRest;
    finExterieur = finExterieurEtatBesion +
        finExterieursalaire +
        finExterieurCampaign +
        finExterieurProjet +
        finExterieurTransRest;

    // Differences entre les couts initial et les depenses
    double caisseSolde = double.parse(data.caisse) - caisse;
    double banqueSolde = double.parse(data.banque) - banque;
    double finExterieurSolde = double.parse(data.finExterieur) - finExterieur;

    double touxExecutions = (caisseSolde + banqueSolde + finExterieurSolde) *
        100 /
        double.parse(data.coutTotal);

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
            const Text("Solde Reste à trouver",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
                "${NumberFormat.decimalPattern('fr').format(finExterieurSolde)} \$",
                textAlign: TextAlign.center,
                style: headline6!.copyWith(color: Colors.orange.shade700)),
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
            const Text("Taux d'executions",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
                "${NumberFormat.decimalPattern('fr').format(double.parse(touxExecutions.toStringAsFixed(0)))} %",
                textAlign: TextAlign.center,
                style: headline6.copyWith(color: (touxExecutions >= 50) ? Colors.green.shade700 : Colors.red.shade700)),
          ],
        ),
      )),
    ]);
  }


}
