import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
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
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/devis/devis_list_objets_model.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/exploitations/projet_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/budgets/ligne_budgetaire/components/ligne_budgetaire.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailDepartmentBudget extends StatefulWidget {
  const DetailDepartmentBudget({Key? key}) : super(key: key);

  @override
  State<DetailDepartmentBudget> createState() => _DetailDepartmentBudgetState();
}

class _DetailDepartmentBudgetState extends State<DetailDepartmentBudget> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isLoadingSend = false;

// Approbations
  String approbationDG = '-';
  String approbationDD = '-';
  TextEditingController motifDGController = TextEditingController();
  TextEditingController motifDDController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<LigneBudgetaireModel> ligneBudgetaireList = [];
  List<CampaignModel> dataCampaignList = [];
  List<DevisModel> dataDevisList = [];
  List<DevisListObjetsModel> devisListObjetsList = []; // avec montant
  List<ProjetModel> dataProjetList = [];
  List<PaiementSalaireModel> dataSalaireList = [];
  List<TransportRestaurationModel> dataTransRestList = [];
  List<TransRestAgentsModel> tansRestList = []; // avec montant

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
    var transRests = await TransportRestaurationApi().getAllData();
    var devisListObjets = await DevisListObjetsApi().getAllData();
    var transRestAgents = await TransRestAgentsApi().getAllData();

    if (!mounted) return;
    setState(() {
      user = userModel;
      ligneBudgetaireList = budgets;
      devisListObjetsList = devisListObjets;
      tansRestList = transRestAgents;
      dataCampaignList = campaigns
          .where((element) =>
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == '-' &&
              element.observation == 'true')
          .toList();
      dataDevisList = devis
          .where((element) =>
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == '-' &&
              element.observation == 'true')
          .toList();
      dataProjetList = projets
          .where((element) =>
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == '-' &&
              element.observation == 'true')
          .toList();
      dataSalaireList = salaires
          .where((element) =>
              element.createdAt.month == DateTime.now().month &&
              element.createdAt.year == DateTime.now().year &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == '-' &&
              element.observation == 'true')
          .toList();
      dataTransRestList = transRests
          .where((element) =>
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == '-' &&
              element.observation == 'true')
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<DepartementBudgetModel>(
            future: DepeartementBudgetApi().getOneData(id),
            builder: (BuildContext context,
                AsyncSnapshot<DepartementBudgetModel> snapshot) {
              if (snapshot.hasData) {
                DepartementBudgetModel? data = snapshot.data;
                return FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, BudgetRoutes.budgetLignebudgetaireAdd,
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
                    child: FutureBuilder<DepartementBudgetModel>(
                        future: DepeartementBudgetApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<DepartementBudgetModel> snapshot) {
                          if (snapshot.hasData) {
                            DepartementBudgetModel? data = snapshot.data;
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
                                          title: "Budgets",
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
                                      approbationWidget(data)
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

  Widget pageDetail(DepartementBudgetModel data) {
    final now = DateTime.now();
    final debut = data.periodeDebut;
    final fin = data.periodeFin;

    final panding = now.compareTo(debut) < 0;
    final biginLigneBudget = now.isAfter(debut); // now.compareTo(debut) > 0;
    final expiredLigneBudget = now.isAfter(fin); //now.compareTo(fin) > 0;

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
                  TitleWidget(title: data.title),
                  Column(
                    children: [
                      Row(
                        children: [
                          if (data.isSubmit == 'false')
                            IconButton(
                                tooltip:
                                    'Soumettre chez le directeur du budget',
                                onPressed: () {
                                  setState(() {
                                    isLoadingSend = true;
                                  });
                                  alertDialog(data);
                                },
                                icon: const Icon(Icons.send),
                                color: Colors.green.shade700),
                          if (data.isSubmit == 'false')
                            IconButton(
                                tooltip: 'Supprimer',
                                onPressed: () async {
                                  setState(() {
                                    isLoadingSend = true;
                                  });
                                  alertDeleteDialog(data);
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.red.shade700),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                      if (data.isSubmit == 'true')
                        Column(
                          children: [
                            if (panding)
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade700,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: p10),
                                    Text("En attente...",
                                        style: TextStyle(
                                            color: Colors.orange.shade700))
                                  ],
                                ),
                              ),
                            if (biginLigneBudget)
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade700,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: p10),
                                    Text("En cours...",
                                        style: TextStyle(
                                            color: Colors.green.shade700))
                                  ],
                                ),
                              ),
                            if (expiredLigneBudget)
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade700,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: p10),
                                    Text("Obsolète!",
                                        style: TextStyle(
                                            color: Colors.red.shade700))
                                  ],
                                ),
                              ),
                          ],
                        ),
                      if (data.isSubmit == 'false')
                        Padding(
                          padding: const EdgeInsets.all(p10),
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade700,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: p10),
                              Text("En constitution...",
                                  style:
                                      TextStyle(color: Colors.purple.shade700))
                            ],
                          ),
                        )
                    ],
                  )
                ],
              ),
              dataWidget(data),
              Divider(color: Colors.red.shade700),
              soldeBudgets(data),
              Divider(color: Colors.red.shade700),
              const SizedBox(height: p20),
              LigneBudgetaire(departementBudgetModel: data),
              const SizedBox(
                height: p20,
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(DepartementBudgetModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Département :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
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
                child: Text('Date de début :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(
                    DateFormat("dd-MM-yyyy").format(data.periodeDebut),
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Date de Fin :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(
                    DateFormat("dd-MM-yyyy").format(data.periodeFin),
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget soldeBudgets(DepartementBudgetModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    // Total des lignes budgetaires
    double coutTotal = 0.0;
    double caisseLigneBud = 0.0;
    double banqueLigneBud = 0.0;
    double finExterieurLigneBud = 0.0;

    // Total depenses
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

    // Ligne budgetaires
    List<LigneBudgetaireModel> ligneBudgetaireCoutTotalList = [];

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

    // Cout total ligne budgetaires
    ligneBudgetaireCoutTotalList = ligneBudgetaireList
        .where((element) =>
            element.departement == data.departement &&
            element.periodeBudgetDebut.microsecondsSinceEpoch ==
                data.periodeDebut.microsecondsSinceEpoch)
        .toList();

    // Filtre ligne budgetaire pour ce budgets
    // Recuperer les données qui sont identique aux lignes budgetaires
    List<CampaignModel> campaignList = [];
    List<DevisModel> devisList = [];
    List<ProjetModel> projetList = [];
    List<PaiementSalaireModel> salaireList = [];
    List<TransportRestaurationModel> transRestList = [];

    for (var item in ligneBudgetaireCoutTotalList) {
      campaignList = dataCampaignList
          .where(
              (element) => element.ligneBudgetaire == item.nomLigneBudgetaire)
          .toSet()
          .toList();
      devisList = dataDevisList
          .where(
              (element) => element.ligneBudgetaire == item.nomLigneBudgetaire)
          .toSet()
          .toList();
      projetList = dataProjetList
          .where(
              (element) => element.ligneBudgetaire == item.nomLigneBudgetaire)
          .toSet()
          .toList();
      salaireList = dataSalaireList
          .where(
              (element) => element.ligneBudgetaire == item.nomLigneBudgetaire)
          .toSet()
          .toList();
      transRestList = dataTransRestList
          .where(
              (element) => element.ligneBudgetaire == item.nomLigneBudgetaire)
          .toSet()
          .toList();
    }

    // Campaigns
    campaignCaisseList = campaignList
        .where((element) =>
            data.departement == "Commercial et Marketing" &&
            element.created.isBefore(data.periodeFin) &&
            element.ressource == "caisse")
        .toList();
    campaignBanqueList = campaignList
        .where((element) =>
            data.departement == "Commercial et Marketing" &&
            element.created.isBefore(data.periodeFin) &&
            element.ressource == "banque")
        .toList();
    campaignfinExterieurList = campaignList
        .where((element) =>
            data.departement == "Commercial et Marketing" &&
            "Commercial et Marketing" == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.ressource == "finExterieur")
        .toList();

    // Etat de Besoins
    for (var item in devisList) {
      devisCaisseList = devisListObjetsList
          .where((element) =>
              data.departement == item.departement &&
              element.referenceDate.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.created.isBefore(data.periodeFin) &&
              item.ressource == "caisse")
          .toList();
      devisBanqueList = devisListObjetsList
          .where((element) =>
              data.departement == item.departement &&
              element.referenceDate.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.created.isBefore(data.periodeFin) &&
              item.ressource == "banque")
          .toList();
      devisfinExterieurList = devisListObjetsList
          .where((element) =>
              data.departement == item.departement &&
              element.referenceDate.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.created.isBefore(data.periodeFin) &&
              item.ressource == "finExterieur")
          .toList();
    }

    // Exploitations
    projetCaisseList = projetList
        .where((element) =>
            data.departement == "Exploitations" &&
            element.created.isBefore(data.periodeFin) &&
            element.ressource == "caisse")
        .toList();
    projetBanqueList = projetList
        .where((element) =>
            data.departement == "Exploitations" &&
            element.created.isBefore(data.periodeFin) &&
            element.ressource == "banque")
        .toList();
    projetfinExterieurList = projetList
        .where((element) =>
            data.departement == "Exploitations" &&
            element.created.isBefore(data.periodeFin) &&
            element.ressource == "finExterieur")
        .toList();

    // Salaires
    salaireCaisseList = salaireList
        .where((element) =>
            data.departement == element.departement &&
            element.createdAt.isBefore(data.periodeFin) &&
            element.ressource == "caisse")
        .toList();
    salaireBanqueList = salaireList
        .where((element) =>
            data.departement == element.departement &&
            element.createdAt.isBefore(data.periodeFin) &&
            element.ressource == "banque")
        .toList();
    salairefinExterieurList = salaireList
        .where((element) =>
            data.departement == element.departement &&
            element.createdAt.isBefore(data.periodeFin) &&
            element.ressource == "finExterieur")
        .toList();

    // Transports & Restaurations
    for (var item in transRestList) {
      transRestCaisseList = tansRestList
          .where((element) =>
              data.departement == "'Ressources Humaines'" &&
              element.reference.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.created.isBefore(data.periodeFin) &&
              item.ressource == "caisse")
          .toList();
      transRestBanqueList = tansRestList
          .where((element) =>
              data.departement == "'Ressources Humaines'" &&
              element.reference.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.created.isBefore(data.periodeFin) &&
              item.ressource == "banque")
          .toList();
      transRestFinExterieurList = tansRestList
          .where((element) =>
              data.departement == "'Ressources Humaines'" &&
              element.reference.microsecondsSinceEpoch ==
                  item.createdRef.microsecondsSinceEpoch &&
              item.created.isBefore(data.periodeFin) &&
              item.ressource == "finExterieur")
          .toList();
    }

    // Sommes des Lignes Budgetaires
    for (var item in ligneBudgetaireCoutTotalList) {
      coutTotal += double.parse(item.coutTotal);
    }
    for (var item in ligneBudgetaireCoutTotalList) {
      caisseLigneBud += double.parse(item.caisse);
    }
    for (var item in ligneBudgetaireCoutTotalList) {
      banqueLigneBud += double.parse(item.banque);
    }
    for (var item in ligneBudgetaireCoutTotalList) {
      finExterieurLigneBud += double.parse(item.finExterieur);
    }

    // Somme des Salaires
    for (var item in salaireCaisseList) {
      caisseSalaire += double.parse(item.salaire);
    }
    for (var item in salaireBanqueList) {
      banqueSalaire += double.parse(item.salaire);
    }
    for (var item in salairefinExterieurList) {
      finExterieursalaire += double.parse(item.salaire);
    }

    // Somme Campaigns
    for (var item in campaignCaisseList) {
      caisseCampaign += double.parse(item.coutCampaign);
    }
    for (var item in campaignBanqueList) {
      banqueCampaign += double.parse(item.coutCampaign);
    }
    for (var item in campaignfinExterieurList) {
      finExterieurCampaign += double.parse(item.coutCampaign);
    }

    // Somme Exploitations
    for (var item in projetCaisseList) {
      caisseProjet += double.parse(item.coutProjet);
    }
    for (var item in projetBanqueList) {
      banqueProjet += double.parse(item.coutProjet);
    }
    for (var item in projetfinExterieurList) {
      finExterieurProjet += double.parse(item.coutProjet);
    }

    // Somme Etat de Besoins
    for (var item in devisCaisseList) {
      caisseEtatBesion += double.parse(item.montantGlobal);
    }
    for (var item in devisBanqueList) {
      banqueEtatBesion += double.parse(item.montantGlobal);
    }
    for (var item in devisfinExterieurList) {
      finExterieurEtatBesion += double.parse(item.montantGlobal);
    }

    // Somme Transports & Restaurations
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
    double caisseSolde = caisseLigneBud - caisse;
    double banqueSolde = banqueLigneBud - banque;
    double finExterieurSolde = finExterieurLigneBud - finExterieur;

    double touxExecutions =
        (caisseSolde + banqueSolde + finExterieurSolde) * 100 / coutTotal;

    return Row(children: [
      Expanded(
          child: Column(
        children: [
          const Text("Coût total",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(
              "${NumberFormat.decimalPattern('fr').format(coutTotal)} \$",
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
            const Text("Caisse", style: TextStyle(fontWeight: FontWeight.bold)),
            AutoSizeText(
                "${NumberFormat.decimalPattern('fr').format(caisseSolde)} \$",
                textAlign: TextAlign.center,
                maxLines: 1,
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
            const Text("Banque", style: TextStyle(fontWeight: FontWeight.bold)),
            AutoSizeText(
                "${NumberFormat.decimalPattern('fr').format(banqueSolde)} \$",
                textAlign: TextAlign.center,
                maxLines: 1,
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
            const Text("Reste à trouver",
                style: TextStyle(fontWeight: FontWeight.bold)),
            AutoSizeText(
                "${NumberFormat.decimalPattern('fr').format(finExterieurSolde)} \$",
                textAlign: TextAlign.center,
                maxLines: 1,
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
                style: headline6.copyWith(
                    color: (touxExecutions >= 50)
                        ? Colors.green.shade700
                        : Colors.red.shade700)),
          ],
        ),
      )),
    ]);
  }

  alertDialog(DepartementBudgetModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Etes-vous sûr de vouloir faire ceci ?'),
              content: const SizedBox(
                  height: 100,
                  width: 100,
                  child: Text(
                      "Cette action permet de soumettre le document sur le bureau du direteur du budget previsionnel")),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    submitToDD(data);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  alertDeleteDialog(DepartementBudgetModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Etes-vous sûr de vouloir faire ceci ?'),
              content: const SizedBox(
                  height: 100,
                  width: 100,
                  child: Text("Cette action permet de supprimer le budget")),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () async {
                    await DepeartementBudgetApi().deleteData(data.id!);
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Future<void> submitToDD(DepartementBudgetModel data) async {
    final departementBudgetModel = DepartementBudgetModel(
        id: data.id,
        title: data.title,
        departement: data.departement,
        periodeDebut: data.periodeDebut,
        periodeFin: data.periodeFin,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        isSubmit: 'true',
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await DepeartementBudgetApi().updateData(departementBudgetModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Widget approbationWidget(DepartementBudgetModel data) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TitleWidget(title: 'Approbations'),
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
                                              color: (data.approbationDG ==
                                                      "Unapproved")
                                                  ? Colors.red.shade700
                                                  : Colors.green.shade700)),
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
                                user.fonctionOccupe == "Directeur de budget")
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
            ],
          ),
        ),
      ),
    ]);
  }

  Widget approbationDGWidget(DepartementBudgetModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
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

  Widget motifDGWidget(DepartementBudgetModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
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

  Widget approbationDDWidget(DepartementBudgetModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
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

  Widget motifDDWidget(DepartementBudgetModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
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

  Future<void> submitDG(DepartementBudgetModel data) async {
    final departementBudgetModel = DepartementBudgetModel(
        id: data.id!,
        title: data.title,
        departement: data.departement,
        periodeDebut: data.periodeDebut,
        periodeFin: data.periodeFin,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        isSubmit: data.isSubmit,
        approbationDG: approbationDG,
        motifDG: (motifDGController.text == '') ? '-' : motifDGController.text,
        signatureDG: user.matricule,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD);
    await DepeartementBudgetApi().updateData(departementBudgetModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitDD(DepartementBudgetModel data) async {
    final departementBudgetModel = DepartementBudgetModel(
        id: data.id!,
        title: data.title,
        departement: data.departement,
        periodeDebut: data.periodeDebut,
        periodeFin: data.periodeFin,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        isSubmit: data.isSubmit,
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: approbationDD,
        motifDD: (motifDDController.text == '') ? '-' : motifDDController.text,
        signatureDD: user.matricule);
    await DepeartementBudgetApi().updateData(departementBudgetModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
