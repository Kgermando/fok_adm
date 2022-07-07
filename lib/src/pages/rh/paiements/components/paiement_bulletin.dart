import 'dart:async';
 
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class PaiementBulletin extends StatefulWidget {
  const PaiementBulletin({Key? key}) : super(key: key);

  @override
  State<PaiementBulletin> createState() => _PaiementBulletinState();
}

class _PaiementBulletinState extends State<PaiementBulletin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  bool isChecked = false;

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

  String? paye;

  @override
  void initState() {
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
    if (!mounted) return;
    setState(() {
      user = userModel;
      ligneBudgetaireList = budgets; 
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
              child: FutureBuilder<PaiementSalaireModel>(
                  future: PaiementSalaireApi().getOneData(id),
                  builder: (BuildContext context,
                      AsyncSnapshot<PaiementSalaireModel> snapshot) {
                    if (snapshot.hasData) {
                      PaiementSalaireModel? data = snapshot.data; 
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: p20,
                                child: IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back)),
                              ),
                              const SizedBox(width: p10),
                              Expanded(
                                  child: CustomAppbar(
                                      title: 'Bulletin de paie',
                                      controllerMenu: () =>
                                          _key.currentState!.openDrawer())),
                            ],
                          ),
                          Expanded(
                              child: SingleChildScrollView(
                                  child: Column(
                            children: [
                              bulletinPaieWidget(data!),
                              const SizedBox(height: p10),
                              approbationWidget(data)
                              
                            ],
                          )))
                        ],
                      );
                    } else {
                      return Center(child: loading());
                    }
                  }),
            ),
          ),
        ],
      )),
    );
  }

  Widget bulletinPaieWidget(PaiementSalaireModel data) {
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
                    color: Colors.amber.shade700,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleWidget(
                            title:
                                'Bulletin de paie du ${DateFormat("dd-mm-yyyy HH:mm").format(data.createdAt)}'),
                        Row(
                          children: [PrintWidget(onPressed: () {})],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    agentWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    salaireWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    heureSupplementaireWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    supplementTravailSamediDimancheJoursFerieWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    primeWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    diversWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    congesPayeWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    maladieAccidentWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    totalDuBrutWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    deductionWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    allocationsFamilialesWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    netAPayerWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    montantPrisConsiderationCalculCotisationsINSSWidget(data),
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

  Widget agentWidget(PaiementSalaireModel data) {
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
              data.matricule,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: Colors.amber.shade700),
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
              data.numeroSecuriteSociale,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: Colors.amber.shade700),
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
              data.nom,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: Colors.amber.shade700),
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
              data.prenom,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: Colors.amber.shade700),
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
              data.telephone,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: Colors.amber.shade700),
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
              data.adresse,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: Colors.amber.shade700),
        Row(
          children: [
            Expanded(
              child: Text(
                'departement',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              data.departement,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: Colors.amber.shade700),
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
              data.servicesAffectation,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: Colors.amber.shade700),
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
              '${data.salaire} USD',
              style: bodyMedium.copyWith(color: Colors.blueGrey),
            ))
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
              data.modePaiement,
              style: bodyMedium,
            ))
          ],
        ),
      ],
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

  checkboxRead(PaiementSalaireModel data) {
    isChecked = false;
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
            submitObservation(data);
          });
          setState(() {
            isLoading = false;
          });
        },
      ),
      title: const Text("Confirmation de payement"),
    );
  }

  Widget salaireWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          top: const BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                          data.tauxJourHeureMoisSalaire,
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
                          data.joursHeuresPayeA100PourecentSalaire,
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
                          data.totalDuSalaire,
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

  Widget heureSupplementaireWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                          data.nombreHeureSupplementaires,
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
                          data.tauxHeureSupplementaires,
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
                          data.totalDuHeureSupplementaires,
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

  Widget supplementTravailSamediDimancheJoursFerieWidget(
      PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                    data.supplementTravailSamediDimancheJoursFerie,
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget primeWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                    data.prime,
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget diversWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                    data.divers,
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget congesPayeWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                          data.joursCongesPaye,
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
                          data.tauxCongesPaye,
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
                          data.totalDuHeureSupplementaires,
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

  Widget maladieAccidentWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                          data.jourPayeMaladieAccident,
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
                          data.tauxJournalierMaladieAccident,
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
                          data.totalDuMaladieAccident,
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

  Widget totalDuBrutWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                    data.totalDuBrut,
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget deductionWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                          data.pensionDeduction,
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
                          data.indemniteCompensatricesDeduction,
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
                          data.avancesDeduction,
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
                          data.diversDeduction,
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
                          data.retenuesFiscalesDeduction,
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

  Widget allocationsFamilialesWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                          data.nombreEnfantBeneficaireAllocationsFamiliales,
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
                          data.nombreDeJoursAllocationsFamiliales,
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
                          data.tauxJoursAllocationsFamiliales,
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
                          data.totalAPayerAllocationsFamiliales,
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

  Widget netAPayerWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                    data.netAPayer,
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget montantPrisConsiderationCalculCotisationsINSSWidget(
      PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
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
                    data.montantPrisConsiderationCalculCotisationsINSS,
                    style: bodyMedium,
                  ),
                ],
              )),
        ],
      ),
    );
  }

 

  Future<void> submitObservation(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
      id: data.id,
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        email: data.email,
        telephone: data.telephone,
        adresse: data.adresse,
        departement: data.departement,
        numeroSecuriteSociale: data.numeroSecuriteSociale,
        matricule: data.matricule,
        servicesAffectation: data.servicesAffectation,
        salaire: data.salaire,
        observation: 'true',
        modePaiement: data.modePaiement,
        createdAt: data.createdAt,
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire,
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire,
        totalDuSalaire: data.totalDuSalaire,
        nombreHeureSupplementaires: data.nombreHeureSupplementaires,
        tauxHeureSupplementaires: data.tauxHeureSupplementaires,
        totalDuHeureSupplementaires: data.totalDuHeureSupplementaires,
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie,
        prime: data.prime,
        divers: data.divers,
        joursCongesPaye: data.joursCongesPaye,
        tauxCongesPaye: data.tauxCongesPaye,
        totalDuCongePaye: data.totalDuCongePaye,
        jourPayeMaladieAccident: data.jourPayeMaladieAccident,
        tauxJournalierMaladieAccident: data.tauxJournalierMaladieAccident,
        totalDuMaladieAccident: data.totalDuMaladieAccident,
        pensionDeduction: data.pensionDeduction,
        indemniteCompensatricesDeduction: data.indemniteCompensatricesDeduction,
        avancesDeduction: data.avancesDeduction,
        diversDeduction: data.diversDeduction,
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction,
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales,
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales,
        tauxJoursAllocationsFamiliales: data.tauxJoursAllocationsFamiliales,
        totalAPayerAllocationsFamiliales: data.totalAPayerAllocationsFamiliales,
        netAPayer: data.netAPayer,
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS,
        totalDuBrut: data.totalDuBrut,
        signature: data.signature,
        
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
        ressource: data.ressource  
    );
    await PaiementSalaireApi().updateData(paiementSalaireModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise à jour avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }



   Widget approbationWidget(PaiementSalaireModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          height: 200,
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add_task, color: Colors.green.shade700)),
                ],
              ),
              const SizedBox(height: p20),
              Row(
                children: [
                  const Expanded(flex: 1, child: Text("Directeur générale")),
                  const SizedBox(width: p20),
                  if (data.approbationDG != '-')
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Approbation"),
                                  const SizedBox(height: p20),
                                  Text(data.approbationDG),
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
                        ])),
                  if (data.approbationDG == '-' &&
                      user.fonctionOccupe == "Directeur générale")
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(child: approbationDGWidget(data)),
                          Expanded(child: motifDGWidget(data))
                        ])),
                ],
              ),
              const SizedBox(height: p20),
              Row(
                children: [
                  const Expanded(
                      flex: 1, child: Text("Directeur de departement")),
                  const SizedBox(width: p20),
                  if (data.approbationDD != '-')
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Approbation"),
                                  const SizedBox(height: p20),
                                  Text(data.approbationDD),
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
                        ])),
                  if (data.approbationDD == '-' &&
                      user.fonctionOccupe == "Directeur de departement")
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(child: approbationDDWidget(data)),
                          Expanded(child: motifDDWidget(data))
                        ])),
                ],
              ),
              const SizedBox(height: p20),
              Row(
                children: [
                  const Expanded(flex: 1, child: Text("Budget")),
                  const SizedBox(width: p20),
                  if (data.approbationBudget != '-')
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
                                      Text(data.approbationBudget),
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
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Ligne Budgetaire"),
                                      const SizedBox(height: p20),
                                      Text(data.ligneBudgetaire),
                                    ],
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Ressource"),
                                      const SizedBox(height: p20),
                                      Text(data.ressource),
                                    ],
                                  )),
                            ]),
                          ],
                        )),
                  if (data.approbationBudget == '-' &&
                      user.fonctionOccupe == "Directeur de budget")
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(child: approbationBudgetWidget(data)),
                              Expanded(child: motifBudgetWidget(data))
                            ]),
                            Row(children: [
                              Expanded(child: ligneBudgtaireWidget()),
                              Expanded(child: resourcesWidget())
                            ]),
                          ],
                        )),
                ],
              ),
              const SizedBox(height: p20),
              Row(
                children: [
                  const Expanded(flex: 1, child: Text("Finance")),
                  const SizedBox(width: p20),
                  if (data.approbationFin != '-')
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Approbation"),
                                  const SizedBox(height: p20),
                                  Text(data.approbationFin),
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
                        ])),
                  if (data.approbationFin == '-' &&
                      user.fonctionOccupe == "Directeur de finance")
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(child: approbationFinWidget(data)),
                          Expanded(child: motifFinWidget(data))
                        ])),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget approbationDGWidget(PaiementSalaireModel data) {
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

  Widget motifDGWidget(PaiementSalaireModel data) {
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

  Widget approbationDDWidget(PaiementSalaireModel data) {
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

  Widget motifDDWidget(PaiementSalaireModel data) {
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

  Widget approbationBudgetWidget(PaiementSalaireModel data) {
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

  Widget motifBudgetWidget(PaiementSalaireModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
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

  Widget approbationFinWidget(PaiementSalaireModel data) {
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

  Widget motifFinWidget(PaiementSalaireModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
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

  Future<void> submitDG(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
      id: data.id,
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        email: data.email,
        telephone: data.telephone,
        adresse: data.adresse,
        departement: data.departement,
        numeroSecuriteSociale: data.numeroSecuriteSociale,
        matricule: data.matricule,
        servicesAffectation: data.servicesAffectation,
        salaire: data.salaire,
        observation: data.observation,
        modePaiement: data.modePaiement,
        createdAt: data.createdAt,
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire,
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire,
        totalDuSalaire: data.totalDuSalaire,
        nombreHeureSupplementaires: data.nombreHeureSupplementaires,
        tauxHeureSupplementaires: data.tauxHeureSupplementaires,
        totalDuHeureSupplementaires: data.totalDuHeureSupplementaires,
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie,
        prime: data.prime,
        divers: data.divers,
        joursCongesPaye: data.joursCongesPaye,
        tauxCongesPaye: data.tauxCongesPaye,
        totalDuCongePaye: data.totalDuCongePaye,
        jourPayeMaladieAccident: data.jourPayeMaladieAccident,
        tauxJournalierMaladieAccident: data.tauxJournalierMaladieAccident,
        totalDuMaladieAccident: data.totalDuMaladieAccident,
        pensionDeduction: data.pensionDeduction,
        indemniteCompensatricesDeduction: data.indemniteCompensatricesDeduction,
        avancesDeduction: data.avancesDeduction,
        diversDeduction: data.diversDeduction,
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction,
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales,
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales,
        tauxJoursAllocationsFamiliales: data.tauxJoursAllocationsFamiliales,
        totalAPayerAllocationsFamiliales: data.totalAPayerAllocationsFamiliales,
        netAPayer: data.netAPayer,
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS,
        totalDuBrut: data.totalDuBrut,
        signature: data.signature,
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
    await PaiementSalaireApi().updateData(paiementSalaireModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitDD(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
      id: data.id,
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        email: data.email,
        telephone: data.telephone,
        adresse: data.adresse,
        departement: data.departement,
        numeroSecuriteSociale: data.numeroSecuriteSociale,
        matricule: data.matricule,
        servicesAffectation: data.servicesAffectation,
        salaire: data.salaire,
        observation: data.observation,
        modePaiement: data.modePaiement,
        createdAt: data.createdAt,
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire,
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire,
        totalDuSalaire: data.totalDuSalaire,
        nombreHeureSupplementaires: data.nombreHeureSupplementaires,
        tauxHeureSupplementaires: data.tauxHeureSupplementaires,
        totalDuHeureSupplementaires: data.totalDuHeureSupplementaires,
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie,
        prime: data.prime,
        divers: data.divers,
        joursCongesPaye: data.joursCongesPaye,
        tauxCongesPaye: data.tauxCongesPaye,
        totalDuCongePaye: data.totalDuCongePaye,
        jourPayeMaladieAccident: data.jourPayeMaladieAccident,
        tauxJournalierMaladieAccident: data.tauxJournalierMaladieAccident,
        totalDuMaladieAccident: data.totalDuMaladieAccident,
        pensionDeduction: data.pensionDeduction,
        indemniteCompensatricesDeduction: data.indemniteCompensatricesDeduction,
        avancesDeduction: data.avancesDeduction,
        diversDeduction: data.diversDeduction,
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction,
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales,
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales,
        tauxJoursAllocationsFamiliales: data.tauxJoursAllocationsFamiliales,
        totalAPayerAllocationsFamiliales: data.totalAPayerAllocationsFamiliales,
        netAPayer: data.netAPayer,
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS,
        totalDuBrut: data.totalDuBrut,
        signature: data.signature,
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
    await PaiementSalaireApi().updateData(paiementSalaireModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitBudget(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
      id: data.id,
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        email:  data.email,
        telephone: data.telephone,
        adresse: data.adresse,
        departement: data.departement,
        numeroSecuriteSociale: data.numeroSecuriteSociale,
        matricule: data.matricule,
        servicesAffectation: data.servicesAffectation,
        salaire: data.salaire,
        observation: data.observation,
        modePaiement: data.modePaiement,
        createdAt: data.createdAt,
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire,
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire,
        totalDuSalaire: data.totalDuSalaire,
        nombreHeureSupplementaires: data.nombreHeureSupplementaires,
        tauxHeureSupplementaires: data.tauxHeureSupplementaires,
        totalDuHeureSupplementaires: data.totalDuHeureSupplementaires,
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie,
        prime: data.prime,
        divers: data.divers,
        joursCongesPaye: data.joursCongesPaye,
        tauxCongesPaye: data.tauxCongesPaye,
        totalDuCongePaye: data.totalDuCongePaye,
        jourPayeMaladieAccident: data.jourPayeMaladieAccident,
        tauxJournalierMaladieAccident: data.tauxJournalierMaladieAccident,
        totalDuMaladieAccident: data.totalDuMaladieAccident,
        pensionDeduction: data.pensionDeduction,
        indemniteCompensatricesDeduction: data.indemniteCompensatricesDeduction,
        avancesDeduction: data.avancesDeduction,
        diversDeduction: data.diversDeduction,
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction,
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales,
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales,
        tauxJoursAllocationsFamiliales: data.tauxJoursAllocationsFamiliales,
        totalAPayerAllocationsFamiliales: data.totalAPayerAllocationsFamiliales,
        netAPayer: data.netAPayer,
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS,
        totalDuBrut: data.totalDuBrut,
        signature: data.signature,
        approbationDG: approbationDG,
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
    await PaiementSalaireApi().updateData(paiementSalaireModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitFin(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
      id: data.id,
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        email: data.email,
        telephone: data.telephone,
        adresse: data.adresse,
        departement: data.departement,
        numeroSecuriteSociale: data.numeroSecuriteSociale,
        matricule: data.matricule,
        servicesAffectation: data.servicesAffectation,
        salaire: data.salaire,
        observation: data.observation,
        modePaiement: data.modePaiement,
        createdAt: data.createdAt,
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire,
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire,
        totalDuSalaire: data.totalDuSalaire,
        nombreHeureSupplementaires: data.nombreHeureSupplementaires,
        tauxHeureSupplementaires: data.tauxHeureSupplementaires,
        totalDuHeureSupplementaires: data.totalDuHeureSupplementaires,
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie,
        prime: data.prime,
        divers: data.divers,
        joursCongesPaye: data.joursCongesPaye,
        tauxCongesPaye: data.tauxCongesPaye,
        totalDuCongePaye: data.totalDuCongePaye,
        jourPayeMaladieAccident: data.jourPayeMaladieAccident,
        tauxJournalierMaladieAccident: data.tauxJournalierMaladieAccident,
        totalDuMaladieAccident: data.totalDuMaladieAccident,
        pensionDeduction: data.pensionDeduction,
        indemniteCompensatricesDeduction: data.indemniteCompensatricesDeduction,
        avancesDeduction: data.avancesDeduction,
        diversDeduction: data.diversDeduction,
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction,
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales,
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales,
        tauxJoursAllocationsFamiliales: data.tauxJoursAllocationsFamiliales,
        totalAPayerAllocationsFamiliales: data.totalAPayerAllocationsFamiliales,
        netAPayer: data.netAPayer,
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS,
        totalDuBrut: data.totalDuBrut,
        signature: data.signature,
        approbationDG: approbationDG,
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
    await PaiementSalaireApi().updateData(paiementSalaireModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
