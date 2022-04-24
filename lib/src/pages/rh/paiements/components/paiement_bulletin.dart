import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class PaiementBulletin extends StatefulWidget {
  const PaiementBulletin({Key? key, this.id}) : super(key: key);

  final int? id;

  @override
  State<PaiementBulletin> createState() => _PaiementBulletinState();
}

class _PaiementBulletinState extends State<PaiementBulletin> {
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
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
  void initState() {
    getData();
    super.initState();
  }

  int? id;
  String? nom;
  String? postNom;
  String? prenom;
  String? telephone;
  String? adresse;
  String? departement;
  String? numeroSecuriteSociale;
  String? matricule;
  String? servicesAffectation;
  String? salaireField;
  bool observation = false; // Payé ou non Payé  // pour Finance
  String? modePaiement; // mode depayement
  DateTime createdAt = DateTime.now();
  String? ligneBudgtaire;
  String? resources;
  String? tauxJourHeureMoisSalaire;
  String? joursHeuresPayeA100PourecentSalaire;
  String? totalDuSalaire;
  String? nombreHeureSupplementaires;
  String? tauxHeureSupplementaires;
  String? totalDuHeureSupplementaires;
  String? supplementTravailSamediDimancheJoursFerie;
  String? prime;
  String? divers;
  String? joursCongesPaye;
  String? tauxCongesPaye;
  String? totalDuCongePaye;
  String? jourPayeMaladieAccident;
  String? tauxJournalierMaladieAccident;
  String? totalDuMaladieAccident;
  String? pensionDeduction;
  String? indemniteCompensatricesDeduction;
  String? avancesDeduction;
  String? diversDeduction;
  String? retenuesFiscalesDeduction;
  String? nombreEnfantBeneficaireAllocationsFamiliales;
  String? nombreDeJoursAllocationsFamiliales;
  String? tauxJoursAllocationsFamiliales;
  String? totalAPayerAllocationsFamiliales;
  String? netAPayer;
  String? montantPrisConsiderationCalculCotisationsINSS;
  String? totalDuBrut;

  String? approbationDG;
  String? signatureDG;
  String? signatureJustificationDG;
  String? approbationFin;
  String? signatureFin;
  String? signatureJustificationFin;
  String? approbationBudget;
  String? signatureBudget;
  String? signatureJustificationBudget;
  String? approbationDD;
  String? signatureDD;
  String? signatureJustificationDD;
  String? signature;

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    PaiementSalaireModel data =
        await PaiementSalaireApi().getOneData(widget.id!);
    if (!mounted) return;
    setState(() {
      user = userModel;
      id = data.id;
      nom = data.nom;
      postNom = data.postNom;
      prenom = data.prenom;
      telephone = data.telephone;
      adresse = data.adresse;
      departement = data.departement;
      numeroSecuriteSociale = data.numeroSecuriteSociale;
      matricule = data.matricule;
      servicesAffectation = data.servicesAffectation;
      salaireField = data.salaire;
      observation = data.observation;
      modePaiement = data.modePaiement;
      createdAt = data.createdAt;
      ligneBudgtaire = data.ligneBudgtaire;
      resources = data.resources;
      tauxJourHeureMoisSalaire = data.tauxJourHeureMoisSalaire;
      joursHeuresPayeA100PourecentSalaire =
          data.joursHeuresPayeA100PourecentSalaire;
      totalDuSalaire = data.totalDuSalaire;
      nombreHeureSupplementaires = data.nombreHeureSupplementaires;
      tauxHeureSupplementaires = data.tauxHeureSupplementaires;
      totalDuHeureSupplementaires = data.totalDuHeureSupplementaires;
      supplementTravailSamediDimancheJoursFerie =
          data.supplementTravailSamediDimancheJoursFerie;
      prime = data.prime;
      divers = data.divers;
      joursCongesPaye = data.joursCongesPaye;
      tauxCongesPaye = data.tauxCongesPaye;
      totalDuCongePaye = data.totalDuCongePaye;
      jourPayeMaladieAccident = data.jourPayeMaladieAccident;
      tauxJournalierMaladieAccident = data.tauxJournalierMaladieAccident;
      totalDuMaladieAccident = data.totalDuMaladieAccident;
      pensionDeduction = data.pensionDeduction;
      indemniteCompensatricesDeduction = data.indemniteCompensatricesDeduction;
      avancesDeduction = data.avancesDeduction;
      diversDeduction = data.diversDeduction;
      diversDeduction = data.diversDeduction;
      retenuesFiscalesDeduction = data.retenuesFiscalesDeduction;
      nombreEnfantBeneficaireAllocationsFamiliales =
          data.nombreEnfantBeneficaireAllocationsFamiliales;
      nombreDeJoursAllocationsFamiliales =
          data.nombreDeJoursAllocationsFamiliales;
      tauxJoursAllocationsFamiliales = data.tauxJoursAllocationsFamiliales;
      totalAPayerAllocationsFamiliales = data.totalAPayerAllocationsFamiliales;
      netAPayer = data.netAPayer;
      montantPrisConsiderationCalculCotisationsINSS =
          data.montantPrisConsiderationCalculCotisationsINSS;
      totalDuBrut = data.totalDuBrut;

      approbationDG = data.approbationDG;
      signatureDG = data.signatureDG;
      signatureJustificationDG = data.signatureJustificationDG;
      approbationFin = data.approbationFin;
      signatureFin = data.signatureFin;
      signatureJustificationFin = data.signatureJustificationFin;
      approbationBudget = data.approbationBudget;
      signatureBudget = data.signatureBudget;
      signatureJustificationBudget = data.signatureJustificationBudget;
      approbationDD = data.approbationDD;
      signatureDD = data.signatureDD;
      signatureJustificationDD = data.signatureJustificationDD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: DrawerMenu(),
            ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(p10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: p20,
                        child: IconButton(
                            onPressed: () => Routemaster.of(context).pop(),
                            icon: const Icon(Icons.arrow_back)),
                      ),
                      const SizedBox(width: p10),
                      const Expanded(
                          child: CustomAppbar(title: 'Bulletin de paie')),
                    ],
                  ),
                  Expanded(
                      child: Scrollbar(
                    controller: _controllerScroll,
                    child: bulletinPaieWidget(),
                  ))
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget bulletinPaieWidget() {
    return Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 10,
              child: Container(
                margin: const EdgeInsets.all(p16),
                padding: const EdgeInsets.all(p16),
                width: (Responsive.isDesktop(context))
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width / 1.5,
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
                        TitleWidget(
                            title:
                                'Bulletin de paie du ${DateFormat("MM-yy").format(createdAt)}'),
                        Row(
                          children: [PrintWidget(onPressed: () {})],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    agentWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    salaireWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    heureSupplementaireWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    supplementTravailSamediDimancheJoursFerieWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    primeWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    diversWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    congesPayeWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    maladieAccidentWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    totalDuBrutWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    deductionWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    allocationsFamilialesWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    netAPayerWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    montantPrisConsiderationCalculCotisationsINSSWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    infosEditeurWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget agentWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Matricule',
                style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              matricule.toString(),
              style: bodyMedium,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Numéro de securité sociale',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              numeroSecuriteSociale.toString(),
              style: bodyMedium,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Nom',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              nom.toString(),
              style: bodyMedium,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Prénom',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              prenom.toString(),
              style: bodyMedium,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Téléphone',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              telephone.toString(),
              style: bodyMedium,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Adresse',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              adresse.toString(),
              style: bodyMedium,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Département',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              departement.toString(),
              style: bodyMedium,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Services d\'affectation',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              servicesAffectation.toString(),
              style: bodyMedium,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Salaire',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              '$salaireField USD',
              style: bodyMedium.copyWith(color: Colors.blueGrey),
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Ligne Budgtaire',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              ligneBudgtaire.toString(),
              style: bodyMedium,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Resources',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              resources.toString(),
              style: bodyMedium,
            ))
          ],
        ),
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
            Expanded(
                child: (observation)
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
        Row(
          children: [
            Expanded(
              child: Text(
                'Mode de paiement',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              modePaiement.toString(),
              style: bodyMedium,
            ))
          ],
        ),
      ],
    );
  }

  Widget salaireWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Salaires',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
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
                          'Durée',
                          style: bodySmall,
                        ),
                        SelectableText(
                          tauxJourHeureMoisSalaire.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('%', style: bodySmall),
                        SelectableText(
                          joursHeuresPayeA100PourecentSalaire.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Total dû', style: bodySmall),
                        SelectableText(
                          totalDuSalaire.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget heureSupplementaireWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Heure supplementaire',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
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
                          'Nombre Heure',
                          style: bodySmall,
                        ),
                        SelectableText(
                          nombreHeureSupplementaires.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Taux',
                          style: bodySmall,
                        ),
                        SelectableText(
                          tauxHeureSupplementaires.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Total dû',
                          style: bodySmall,
                        ),
                        SelectableText(
                          totalDuHeureSupplementaires.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget supplementTravailSamediDimancheJoursFerieWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text(
                  'Supplement dû travail du samedi, du dimanche et jours ferié',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    'Supplement dû travail',
                    style: bodySmall,
                  ),
                  SelectableText(
                    supplementTravailSamediDimancheJoursFerie.toString(),
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget primeWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Prime',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    'Prime',
                    style: bodySmall,
                  ),
                  SelectableText(
                    prime.toString(),
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget diversWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Divers',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    'Divers',
                    style: bodySmall,
                  ),
                  SelectableText(
                    divers.toString(),
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget congesPayeWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Congés Payé',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
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
                          'Jours',
                          style: bodySmall,
                        ),
                        SelectableText(
                          joursCongesPaye.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Taux',
                          style: bodySmall,
                        ),
                        SelectableText(
                          tauxCongesPaye.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Total dû',
                          style: bodySmall,
                        ),
                        SelectableText(
                          totalDuHeureSupplementaires.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget maladieAccidentWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Maladie ou Accident',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
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
                          'Jours Payé',
                          style: bodySmall,
                        ),
                        SelectableText(
                          jourPayeMaladieAccident.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Taux',
                          style: bodySmall,
                        ),
                        SelectableText(
                          tauxJournalierMaladieAccident.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Total dû',
                          style: bodySmall,
                        ),
                        SelectableText(
                          totalDuMaladieAccident.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget totalDuBrutWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Total brut dû',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    'Total',
                    style: bodySmall,
                  ),
                  SelectableText(
                    totalDuBrut.toString(),
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget deductionWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Deduction',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Pension',
                          style: bodySmall,
                        ),
                        SelectableText(
                          pensionDeduction.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Indemnité compensatrices',
                          style: bodySmall,
                        ),
                        SelectableText(
                          indemniteCompensatricesDeduction.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Avances',
                          style: bodySmall,
                        ),
                        SelectableText(
                          avancesDeduction.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Divers',
                          style: bodySmall,
                        ),
                        SelectableText(
                          diversDeduction.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Retenues fiscales',
                          style: bodySmall,
                        ),
                        SelectableText(
                          retenuesFiscalesDeduction.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget allocationsFamilialesWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Allocations familiales',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Nombre des enfants béneficaire',
                          style: bodySmall,
                        ),
                        SelectableText(
                          nombreEnfantBeneficaireAllocationsFamiliales
                              .toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Nombre des Jours',
                          style: bodySmall,
                        ),
                        SelectableText(
                          nombreDeJoursAllocationsFamiliales.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Taux journalier',
                          style: bodySmall,
                        ),
                        SelectableText(
                          tauxJoursAllocationsFamiliales.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Total à payer',
                          style: bodySmall,
                        ),
                        SelectableText(
                          totalAPayerAllocationsFamiliales.toString(),
                          style: bodyMedium,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget netAPayerWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Net à payer',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    'Total à payer',
                    style: bodySmall,
                  ),
                  SelectableText(
                    netAPayer.toString(),
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget montantPrisConsiderationCalculCotisationsINSSWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text(
                  'Montant pris en consideration pour le calcul des cotisations INSS',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    'Montant pris pour la Cotisations INSS',
                    style: bodySmall,
                  ),
                  SelectableText(
                    montantPrisConsiderationCalculCotisationsINSS.toString(),
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget infosEditeurWidget() {
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
                            if (approbationDG != '-')
                              SelectableText(
                                approbationDG.toString(),
                                style: bodyMedium.copyWith(
                                    color: Colors.red.shade700),
                              ),
                            if (approbationDG == '-' && user!.fonctionOccupe == 'Directeur générale')
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
                              signatureDG.toString(),
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
                            if (approbationDG == 'Unapproved' &&
                                signatureDG != '-')
                              SelectableText(
                                signatureJustificationDG.toString(),
                                style: bodyMedium,
                              ),
                            if (approbationDG == 'Unapproved' &&
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
                            if (approbationDG == 'Unapproved')
                              IconButton(
                                  onPressed: () {
                                    submitUpdateDG();
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
                            if (approbationFin != '-')
                              SelectableText(
                                approbationFin.toString(),
                                style: bodyMedium.copyWith(
                                    color: Colors.green.shade700),
                              ),
                            if (approbationFin == '-' &&
                                user!.fonctionOccupe == 'Directeur des finances')
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
                              signatureFin.toString(),
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
                            if (approbationFin == 'Unapproved' &&
                                signatureFin != '-')
                              SelectableText(
                                signatureJustificationFin.toString(),
                                style: bodyMedium,
                              ),
                            if (approbationFin == 'Unapproved' &&
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
                            if (approbationFin == 'Unapproved')
                              IconButton(
                                  onPressed: () {
                                    submitUpdateFIN();
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
                            if (approbationBudget != '-')
                              SelectableText(
                                approbationBudget.toString(),
                                style: bodyMedium.copyWith(
                                    color: Colors.orange.shade700),
                              ),
                            if (approbationBudget == '-' &&
                                user!.fonctionOccupe ==
                                    'Directeur de budget')
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
                              signatureBudget.toString(),
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
                            if (approbationBudget == 'Unapproved' &&
                                signatureBudget != '-')
                              SelectableText(
                                signatureJustificationBudget.toString(),
                                style: bodyMedium,
                              ),
                            if (approbationBudget == 'Unapproved' &&
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
                            if (approbationBudget == 'Unapproved')
                              IconButton(
                                  onPressed: () {
                                    submitUpdateBudget();
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
                            if (approbationDD != '-' &&
                                user!.fonctionOccupe == 'Directeur de département')
                              SelectableText(
                                approbationDD.toString(),
                                style: bodyMedium.copyWith(
                                    color: Colors.blue.shade700),
                              ),
                            if (approbationDD == '-')
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
                              signatureDD.toString(),
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
                            if (approbationDD == 'Unapproved' &&
                                signatureDD != '-')
                              SelectableText(
                                signatureJustificationDD.toString(),
                                style: bodyMedium,
                              ),
                            if (approbationDD == 'Unapproved' &&
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
                            if (approbationDD == 'Unapproved')
                              IconButton(
                                  onPressed: () {
                                    submitUpdateDD();
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

  Future<void> submitUpdateDG() async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: id,
        nom: nom.toString(),
        postNom: postNom.toString(),
        prenom: prenom.toString(),
        telephone: telephone.toString(),
        adresse: adresse.toString(),
        departement: departement.toString(),
        numeroSecuriteSociale: numeroSecuriteSociale.toString(),
        matricule: matricule.toString(),
        servicesAffectation: servicesAffectation.toString(),
        salaire: salaireField.toString(),
        observation: observation,
        modePaiement: modePaiement.toString(),
        createdAt: createdAt,
        ligneBudgtaire: ligneBudgtaire.toString(),
        resources: resources.toString(),
        tauxJourHeureMoisSalaire: tauxJourHeureMoisSalaire.toString(),
        joursHeuresPayeA100PourecentSalaire:
            joursHeuresPayeA100PourecentSalaire.toString(),
        totalDuSalaire: totalDuSalaire.toString(),
        nombreHeureSupplementaires: nombreHeureSupplementaires.toString(),
        tauxHeureSupplementaires: tauxHeureSupplementaires.toString(),
        totalDuHeureSupplementaires: totalDuHeureSupplementaires.toString(),
        supplementTravailSamediDimancheJoursFerie:
            supplementTravailSamediDimancheJoursFerie.toString(),
        prime: prime.toString(),
        divers: divers.toString(),
        joursCongesPaye: joursCongesPaye.toString(),
        tauxCongesPaye: tauxCongesPaye.toString(),
        totalDuCongePaye: totalDuCongePaye.toString(),
        jourPayeMaladieAccident: jourPayeMaladieAccident.toString(),
        tauxJournalierMaladieAccident: tauxJournalierMaladieAccident.toString(),
        totalDuMaladieAccident: totalDuMaladieAccident.toString(),
        pensionDeduction: pensionDeduction.toString(),
        indemniteCompensatricesDeduction:
            indemniteCompensatricesDeduction.toString(),
        avancesDeduction: avancesDeduction.toString(),
        diversDeduction: diversDeduction.toString(),
        retenuesFiscalesDeduction: retenuesFiscalesDeduction.toString(),
        nombreEnfantBeneficaireAllocationsFamiliales:
            nombreEnfantBeneficaireAllocationsFamiliales.toString(),
        nombreDeJoursAllocationsFamiliales:
            nombreDeJoursAllocationsFamiliales.toString(),
        tauxJoursAllocationsFamiliales:
            tauxJoursAllocationsFamiliales.toString(),
        totalAPayerAllocationsFamiliales:
            totalAPayerAllocationsFamiliales.toString(),
        netAPayer: netAPayer.toString(),
        montantPrisConsiderationCalculCotisationsINSS:
            montantPrisConsiderationCalculCotisationsINSS.toString(),
        totalDuBrut: totalDuBrut.toString(),
        approbationDG: approbationDGController.toString(),
        signatureDG: user!.matricule.toString(),
        signatureJustificationDG: signatureJustificationDGController.text,
        approbationFin: approbationFin.toString(),
        signatureFin: signatureFin.toString(),
        signatureJustificationFin: signatureJustificationFin.toString(),
        approbationBudget: approbationBudget.toString(),
        signatureBudget: signatureBudget.toString(),
        signatureJustificationBudget: signatureJustificationBudget.toString(),
        approbationDD: approbationDD.toString(),
        signatureDD: signatureDD.toString(),
        signatureJustificationDD: signatureJustificationDD.toString(),
        signature: signature.toString());
    await PaiementSalaireApi().updateData(id!, paiementSalaireModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateFIN() async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: id,
        nom: nom.toString(),
        postNom: postNom.toString(),
        prenom: prenom.toString(),
        telephone: telephone.toString(),
        adresse: adresse.toString(),
        departement: departement.toString(),
        numeroSecuriteSociale: numeroSecuriteSociale.toString(),
        matricule: matricule.toString(),
        servicesAffectation: servicesAffectation.toString(),
        salaire: salaireField.toString(),
        observation: observation,
        modePaiement: modePaiement.toString(),
        createdAt: createdAt,
        ligneBudgtaire: ligneBudgtaire.toString(),
        resources: resources.toString(),
        tauxJourHeureMoisSalaire: tauxJourHeureMoisSalaire.toString(),
        joursHeuresPayeA100PourecentSalaire:
            joursHeuresPayeA100PourecentSalaire.toString(),
        totalDuSalaire: totalDuSalaire.toString(),
        nombreHeureSupplementaires: nombreHeureSupplementaires.toString(),
        tauxHeureSupplementaires: tauxHeureSupplementaires.toString(),
        totalDuHeureSupplementaires: totalDuHeureSupplementaires.toString(),
        supplementTravailSamediDimancheJoursFerie:
            supplementTravailSamediDimancheJoursFerie.toString(),
        prime: prime.toString(),
        divers: divers.toString(),
        joursCongesPaye: joursCongesPaye.toString(),
        tauxCongesPaye: tauxCongesPaye.toString(),
        totalDuCongePaye: totalDuCongePaye.toString(),
        jourPayeMaladieAccident: jourPayeMaladieAccident.toString(),
        tauxJournalierMaladieAccident: tauxJournalierMaladieAccident.toString(),
        totalDuMaladieAccident: totalDuMaladieAccident.toString(),
        pensionDeduction: pensionDeduction.toString(),
        indemniteCompensatricesDeduction:
            indemniteCompensatricesDeduction.toString(),
        avancesDeduction: avancesDeduction.toString(),
        diversDeduction: diversDeduction.toString(),
        retenuesFiscalesDeduction: retenuesFiscalesDeduction.toString(),
        nombreEnfantBeneficaireAllocationsFamiliales:
            nombreEnfantBeneficaireAllocationsFamiliales.toString(),
        nombreDeJoursAllocationsFamiliales:
            nombreDeJoursAllocationsFamiliales.toString(),
        tauxJoursAllocationsFamiliales:
            tauxJoursAllocationsFamiliales.toString(),
        totalAPayerAllocationsFamiliales:
            totalAPayerAllocationsFamiliales.toString(),
        netAPayer: netAPayer.toString(),
        montantPrisConsiderationCalculCotisationsINSS:
            montantPrisConsiderationCalculCotisationsINSS.toString(),
        totalDuBrut: totalDuBrut.toString(),

        approbationDG: approbationDG.toString(),
        signatureDG: signatureDG.toString(),
        signatureJustificationDG: signatureJustificationDG.toString(),

        approbationFin: approbationFinController.toString(),
        signatureFin: user!.matricule.toString(),
        signatureJustificationFin: signatureJustificationFinController.text,

        approbationBudget: approbationBudget.toString(),
        signatureBudget: signatureBudget.toString(),
        signatureJustificationBudget: signatureJustificationBudget.toString(),
        approbationDD: approbationDD.toString(),
        signatureDD: signatureDD.toString(),
        signatureJustificationDD: signatureJustificationDD.toString(),
        signature: signature.toString());
    await PaiementSalaireApi().updateData(id!, paiementSalaireModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateBudget() async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: id,
        nom: nom.toString(),
        postNom: postNom.toString(),
        prenom: prenom.toString(),
        telephone: telephone.toString(),
        adresse: adresse.toString(),
        departement: departement.toString(),
        numeroSecuriteSociale: numeroSecuriteSociale.toString(),
        matricule: matricule.toString(),
        servicesAffectation: servicesAffectation.toString(),
        salaire: salaireField.toString(),
        observation: observation,
        modePaiement: modePaiement.toString(),
        createdAt: createdAt,
        ligneBudgtaire: ligneBudgtaire.toString(),
        resources: resources.toString(),
        tauxJourHeureMoisSalaire: tauxJourHeureMoisSalaire.toString(),
        joursHeuresPayeA100PourecentSalaire:
            joursHeuresPayeA100PourecentSalaire.toString(),
        totalDuSalaire: totalDuSalaire.toString(),
        nombreHeureSupplementaires: nombreHeureSupplementaires.toString(),
        tauxHeureSupplementaires: tauxHeureSupplementaires.toString(),
        totalDuHeureSupplementaires: totalDuHeureSupplementaires.toString(),
        supplementTravailSamediDimancheJoursFerie:
            supplementTravailSamediDimancheJoursFerie.toString(),
        prime: prime.toString(),
        divers: divers.toString(),
        joursCongesPaye: joursCongesPaye.toString(),
        tauxCongesPaye: tauxCongesPaye.toString(),
        totalDuCongePaye: totalDuCongePaye.toString(),
        jourPayeMaladieAccident: jourPayeMaladieAccident.toString(),
        tauxJournalierMaladieAccident: tauxJournalierMaladieAccident.toString(),
        totalDuMaladieAccident: totalDuMaladieAccident.toString(),
        pensionDeduction: pensionDeduction.toString(),
        indemniteCompensatricesDeduction:
            indemniteCompensatricesDeduction.toString(),
        avancesDeduction: avancesDeduction.toString(),
        diversDeduction: diversDeduction.toString(),
        retenuesFiscalesDeduction: retenuesFiscalesDeduction.toString(),
        nombreEnfantBeneficaireAllocationsFamiliales:
            nombreEnfantBeneficaireAllocationsFamiliales.toString(),
        nombreDeJoursAllocationsFamiliales:
            nombreDeJoursAllocationsFamiliales.toString(),
        tauxJoursAllocationsFamiliales:
            tauxJoursAllocationsFamiliales.toString(),
        totalAPayerAllocationsFamiliales:
            totalAPayerAllocationsFamiliales.toString(),
        netAPayer: netAPayer.toString(),
        montantPrisConsiderationCalculCotisationsINSS:
            montantPrisConsiderationCalculCotisationsINSS.toString(),
        totalDuBrut: totalDuBrut.toString(),

        approbationDG: approbationDG.toString(),
        signatureDG: signatureDG.toString(),
        signatureJustificationDG: signatureJustificationDG.toString(),

        approbationFin: approbationFin.toString(),
        signatureFin: signatureFin.toString(),
        signatureJustificationFin: signatureJustificationFin.toString(),

        approbationBudget: approbationBudgetController.toString(),
        signatureBudget: user!.matricule.toString(),
        signatureJustificationBudget: signatureJustificationBudgetController.text,

        approbationDD: approbationDD.toString(),
        signatureDD: signatureDD.toString(),
        signatureJustificationDD: signatureJustificationDD.toString(),
        signature: signature.toString());
    await PaiementSalaireApi().updateData(id!, paiementSalaireModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateDD() async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: id,
        nom: nom.toString(),
        postNom: postNom.toString(),
        prenom: prenom.toString(),
        telephone: telephone.toString(),
        adresse: adresse.toString(),
        departement: departement.toString(),
        numeroSecuriteSociale: numeroSecuriteSociale.toString(),
        matricule: matricule.toString(),
        servicesAffectation: servicesAffectation.toString(),
        salaire: salaireField.toString(),
        observation: observation,
        modePaiement: modePaiement.toString(),
        createdAt: createdAt,
        ligneBudgtaire: ligneBudgtaire.toString(),
        resources: resources.toString(),
        tauxJourHeureMoisSalaire: tauxJourHeureMoisSalaire.toString(),
        joursHeuresPayeA100PourecentSalaire:
            joursHeuresPayeA100PourecentSalaire.toString(),
        totalDuSalaire: totalDuSalaire.toString(),
        nombreHeureSupplementaires: nombreHeureSupplementaires.toString(),
        tauxHeureSupplementaires: tauxHeureSupplementaires.toString(),
        totalDuHeureSupplementaires: totalDuHeureSupplementaires.toString(),
        supplementTravailSamediDimancheJoursFerie:
            supplementTravailSamediDimancheJoursFerie.toString(),
        prime: prime.toString(),
        divers: divers.toString(),
        joursCongesPaye: joursCongesPaye.toString(),
        tauxCongesPaye: tauxCongesPaye.toString(),
        totalDuCongePaye: totalDuCongePaye.toString(),
        jourPayeMaladieAccident: jourPayeMaladieAccident.toString(),
        tauxJournalierMaladieAccident: tauxJournalierMaladieAccident.toString(),
        totalDuMaladieAccident: totalDuMaladieAccident.toString(),
        pensionDeduction: pensionDeduction.toString(),
        indemniteCompensatricesDeduction:
            indemniteCompensatricesDeduction.toString(),
        avancesDeduction: avancesDeduction.toString(),
        diversDeduction: diversDeduction.toString(),
        retenuesFiscalesDeduction: retenuesFiscalesDeduction.toString(),
        nombreEnfantBeneficaireAllocationsFamiliales:
            nombreEnfantBeneficaireAllocationsFamiliales.toString(),
        nombreDeJoursAllocationsFamiliales:
            nombreDeJoursAllocationsFamiliales.toString(),
        tauxJoursAllocationsFamiliales:
            tauxJoursAllocationsFamiliales.toString(),
        totalAPayerAllocationsFamiliales:
            totalAPayerAllocationsFamiliales.toString(),
        netAPayer: netAPayer.toString(),
        montantPrisConsiderationCalculCotisationsINSS:
            montantPrisConsiderationCalculCotisationsINSS.toString(),
        totalDuBrut: totalDuBrut.toString(),

        approbationDG: approbationDG.toString(),
        signatureDG: signatureDG.toString(),
        signatureJustificationDG: signatureJustificationDG.toString(),

        approbationFin: approbationFin.toString(),
        signatureFin: signatureFin.toString(),
        signatureJustificationFin: signatureJustificationFin.toString(),

        approbationBudget: approbationBudget.toString(),
        signatureBudget: signatureBudget.toString(),
        signatureJustificationBudget: signatureJustificationBudget.toString(),

        approbationDD: approbationDDController.toString(),
        signatureDD: user!.matricule.toString(),
        signatureJustificationDD: signatureJustificationDDController.text,
        
        signature: signature.toString());
    await PaiementSalaireApi().updateData(id!, paiementSalaireModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
