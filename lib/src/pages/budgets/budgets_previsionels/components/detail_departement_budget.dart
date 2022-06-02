import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/exploitations/projets_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/exploitations/projet_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/budgets/ligne_budgetaire/components/ajout_ligne_budgetaire.dart';
import 'package:fokad_admin/src/pages/budgets/ligne_budgetaire/components/ligne_budgetaire.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailDepartmentBudget extends StatefulWidget {
  const DetailDepartmentBudget({Key? key}) : super(key: key);

  @override
  State<DetailDepartmentBudget> createState() => _DetailDepartmentBudgetState();
}

class _DetailDepartmentBudgetState extends State<DetailDepartmentBudget> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

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
  void initState() {
    getData();
    super.initState();
  }

  String? ligneBudgtaire;
  String? resource;
  List<LigneBudgetaireModel> ligneBudgetaireList = [];
  List<CampaignModel> dataCampaignList = [];
  List<DevisModel> dataDevisList = [];
  List<ProjetModel> dataProjetList = [];
  List<PaiementSalaireModel> dataSalaireList = [];
  List<ApprobationModel> approbList = [];
  List<ApprobationModel> approbationData = [];
  ApprobationModel approb = ApprobationModel(
      reference: 1,
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
      isOnline: false,
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
    var approbations = await ApprobationApi().getAllData();

    setState(() {
      user = userModel;
      ligneBudgetaireList = budgets;
      approbList = approbations;

      for (var i in approbations) {
        dataCampaignList = campaigns
            .where((element) =>
                element.id == i.reference &&
                i.fontctionOccupee == 'Directeur générale')
            .toList();
        dataDevisList = devis
            .where((element) =>
                element.id == i.reference &&
                i.fontctionOccupee == 'Directeur générale')
            .toList();
        dataProjetList = projets
            .where((element) =>
                element.id == i.reference &&
                i.fontctionOccupee == 'Directeur générale')
            .toList();
        dataSalaireList = salaires
            .where((element) =>
                element.id == i.reference &&
                i.fontctionOccupee == 'Directeur générale')
            .toList();
      }

      // dataCampaignList = campaigns.toList();
      // dataDevisList = devis.toList();
      // dataProjetList = projets.toList();
      // dataSalaireList = salaires.toList();
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AjoutLigneBudgetaire(
                              departementBudgetModel: data!)));
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
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
                            approbationData = approbList
                                .where(
                                    (element) => element.reference == data!.id!)
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
                                          title: "Budget",
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
                            return const Center(
                                child: CircularProgressIndicator());
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
                      PrintWidget(
                          tooltip: 'Imprimer le document', onPressed: () {}),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                      if (panding)
                        Row(
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
                                style: TextStyle(color: Colors.orange.shade700))
                          ],
                        ),
                      if (biginLigneBudget)
                        Row(
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
                                style: TextStyle(color: Colors.green.shade700))
                          ],
                        ),
                      if (expiredLigneBudget)
                        Row(
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
                                style: TextStyle(color: Colors.red.shade700))
                          ],
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

    var etatBesionCaisseList = dataDevisList
        .where((element) =>
            element.departement == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "caisse")
        .toList();
    var etatBesionBanqueList = dataDevisList
        .where((element) =>
            element.departement == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "banque")
        .toList();
    var etatBesionFinPropreList = dataDevisList
        .where((element) =>
            element.departement == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "finPropre")
        .toList();
    var etatBesionFinExterieurList = dataDevisList
        .where((element) =>
            element.departement == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "finExterieur")
        .toList();

    for (var item in etatBesionCaisseList) {
      caisseetatBesion += double.parse(item.resources);
    }
    for (var item in etatBesionBanqueList) {
      banqueetatBesion += double.parse(item.resources);
    }
    for (var item in etatBesionFinPropreList) {
      finPropreetatBesion += double.parse(item.resources);
    }
    for (var item in etatBesionFinExterieurList) {
      finExterieuretatBesion += double.parse(item.resources);
    }

    var salairecaisseList = dataSalaireList
        .where((element) =>
            element.departement == data.departement &&
            element.createdAt.isBefore(data.periodeFin) &&
            element.resources == "caisse")
        .toList();
    var salairebanqueList = dataSalaireList
        .where((element) =>
            element.departement == data.departement &&
            element.createdAt.isBefore(data.periodeFin) &&
            element.resources == "banque")
        .toList();
    var salairefinPropreList = dataSalaireList
        .where((element) =>
            element.departement == data.departement &&
            element.createdAt.isBefore(data.periodeFin) &&
            element.resources == "finPropre")
        .toList();
    var salairefinExterieurList = dataSalaireList
        .where((element) =>
            element.departement == data.departement &&
            element.createdAt.isBefore(data.periodeFin) &&
            element.resources == "finExterieur")
        .toList();
    for (var item in salairecaisseList) {
      caissesalaire += double.parse(item.resources);
    }
    for (var item in salairebanqueList) {
      banquesalaire += double.parse(item.resources);
    }
    for (var item in salairefinPropreList) {
      finPropresalaire += double.parse(item.resources);
    }
    for (var item in salairefinExterieurList) {
      finExterieursalaire += double.parse(item.resources);
    }

    var campaigncaisseList = dataCampaignList
        .where((element) =>
            "Commercial et Marketing" == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "caisse")
        .toList();
    var campaignbanqueList = dataCampaignList
        .where((element) =>
            "Commercial et Marketing" == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "banque")
        .toList();
    var campaignfinPropreList = dataCampaignList
        .where((element) =>
            "Commercial et Marketing" == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "finPropre")
        .toList();
    var campaignfinExterieurList = dataCampaignList
        .where((element) =>
            "Commercial et Marketing" == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "finExterieur")
        .toList();
    for (var item in campaigncaisseList) {
      caisseCampaign += double.parse(item.resources);
    }
    for (var item in campaignbanqueList) {
      banqueCampaign += double.parse(item.resources);
    }
    for (var item in campaignfinPropreList) {
      finPropreCampaign += double.parse(item.resources);
    }
    for (var item in campaignfinExterieurList) {
      finExterieurCampaign += double.parse(item.resources);
    }

    var projetcaisseList = dataProjetList
        .where((element) =>
            "Exploitations" == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "caisse")
        .toList();
    var projetbanqueList = dataProjetList
        .where((element) =>
            "Exploitations" == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "banque")
        .toList();
    var projetfinPropreList = dataProjetList
        .where((element) =>
            "Exploitations" == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "finPropre")
        .toList();
    var projetfinExterieurList = dataProjetList
        .where((element) =>
            "Exploitations" == data.departement &&
            element.created.isBefore(data.periodeFin) &&
            element.resources == "finExterieur")
        .toList();

    for (var item in projetcaisseList) {
      caisseProjet += double.parse(item.resources);
    }
    for (var item in projetbanqueList) {
      banqueProjet += double.parse(item.resources);
    }
    for (var item in projetfinPropreList) {
      finPropreProjet += double.parse(item.resources);
    }
    for (var item in projetfinExterieurList) {
      finExterieurProjet += double.parse(item.resources);
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

    var coutTotalLigne = ligneBudgetaireList
        .where((element) =>
            element.departement == data.departement &&
            element.created.isBefore(data.periodeFin))
        .toList();
    var caisseLigne = ligneBudgetaireList
        .where((element) =>
            element.departement == data.departement &&
            element.created.isBefore(data.periodeFin))
        .toList();
    var banqueLigne = ligneBudgetaireList
        .where((element) =>
            element.departement == data.departement &&
            element.created.isBefore(data.periodeFin))
        .toList();
    var finPropreLigne = ligneBudgetaireList
        .where((element) =>
            element.departement == data.departement &&
            element.created.isBefore(data.periodeFin))
        .toList();
    var finExterieurLigne = ligneBudgetaireList
        .where((element) =>
            element.departement == data.departement &&
            element.created.isBefore(data.periodeFin))
        .toList();

    double coutTotalSolde = 0.0;
    double caisseSolde = 0.0;
    double banqueSolde = 0.0;
    double finPropreSolde = 0.0;
    double finExterieurSolde = 0.0;

    for (var item in coutTotalLigne) {
      coutTotalSolde += double.parse(item.coutTotal);
    }
    for (var item in caisseLigne) {
      caisseSolde += double.parse(item.caisse) - caisse;
    }
    for (var item in banqueLigne) {
      banqueSolde += double.parse(item.banque) - banque;
    }
    for (var item in finPropreLigne) {
      finPropreSolde += double.parse(item.finPropre) - finPropre;
    }
    for (var item in finExterieurLigne) {
      finExterieurSolde += double.parse(item.finExterieur) - finExterieur;
    }

    return Row(children: [
      Expanded(
          child: Column(
        children: [
          const Text("Coût total",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(
              "${NumberFormat.decimalPattern('fr').format(coutTotalSolde)} \$",
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
            SelectableText(
                "${NumberFormat.decimalPattern('fr').format(caisseSolde)} \$",
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
            const Text("Banque", style: TextStyle(fontWeight: FontWeight.bold)),
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
            const Text("Fonds Propres",
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
            const Text("Reste à trouver",
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

  Widget approbationForm(DepartementBudgetModel data) {
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

  Future submitApprobation(DepartementBudgetModel data) async {
    final approbation = ApprobationModel(
        reference: data.created.microsecondsSinceEpoch,
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
}
