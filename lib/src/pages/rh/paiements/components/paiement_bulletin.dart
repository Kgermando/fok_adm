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
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class PaiementBulletin extends StatefulWidget {
  const PaiementBulletin({Key? key, this.id}) : super(key: key);

  final int? id;

  @override
  State<PaiementBulletin> createState() => _PaiementBulletinState();
}

class _PaiementBulletinState extends State<PaiementBulletin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
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

  String? paye;

  String? ligneBudgtaire;
  String? resource;
  List<LigneBudgetaireModel> ligneBudgetaireList = [];

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      setState(() {
        getData();
      });
      
      timer.cancel();
    }));

    super.initState();
  }

  UserModel? user = UserModel(
      nom: '-',
      prenom: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '-',
      isOnline: false,
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
                  future: PaiementSalaireApi().getOneData(widget.id!),
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
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
                                  child: bulletinPaieWidget(data!)))
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
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
                    infosEditeurWidget(data),
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
                'Ligne Budgtaire',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              data.ligneBudgtaire,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: Colors.amber.shade700),
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
              data.resources,
              style: bodyMedium,
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
            if (!data.observation && user!.departement == "Finances")
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

   Widget infosEditeurWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyLarge;
    final bodySmall = Theme.of(context).textTheme.bodyMedium;
    List<String> dataList = ['Approved', 'Unapproved', '-'];
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(p10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text('Directeur Générale',
                        style: bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700))),
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
                                style: bodySmall!
                                    .copyWith(color: Colors.red.shade700),
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
                                style: bodySmall.copyWith(
                                    color: Colors.red.shade700),
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
                                style: bodySmall.copyWith(
                                    color: Colors.red.shade700),
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
            Divider(
              color: Colors.amber.shade700,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text('Directeur de Finance',
                        style: bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700))),
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
                                style: bodySmall.copyWith(
                                    color: Colors.green.shade700),
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
                                style: bodySmall.copyWith(
                                    color: Colors.green.shade700),
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
                                style: bodySmall.copyWith(
                                    color: Colors.green.shade700),
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
            Divider(
              color: Colors.amber.shade700,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text('Budget',
                        style: bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700))),
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
                                style: bodySmall.copyWith(
                                    color: Colors.orange.shade700),
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
                                    Expanded(child: resourcesWidget())
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
                                style: bodySmall.copyWith(
                                    color: Colors.orange.shade700),
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
                                style: bodySmall.copyWith(
                                    color: Colors.orange.shade700),
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
            Divider(
              color: Colors.amber.shade700,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text('Directeur de departement',
                        style: bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700))),
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
                                style: bodySmall.copyWith(
                                    color: Colors.blue.shade700),
                              ),
                              if (data.approbationDD != '-' &&
                                  user!.fonctionOccupe ==
                                      'Directeur de departement')
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
                                      // labelText: 'Approbation',
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
                                style: bodySmall.copyWith(
                                    color: Colors.blue.shade700),
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
                                style: bodySmall.copyWith(
                                    color: Colors.blue.shade700),
                              ),
                              if (data.approbationDD == 'Unapproved' &&
                                  data.signatureDD != '-')
                                SelectableText(
                                  data.signatureJustificationDD.toString(),
                                  style: bodyMedium,
                                ),
                              if (approbationDDController == 'Unapproved' &&
                                  user!.fonctionOccupe ==
                                      'Directeur de departement')
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
                              if (approbationDDController == 'Unapproved')
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

  Future<void> submitUpdateDG(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: data.id,
        nom: data.nom.toString(),
        postNom: data.postNom.toString(),
        prenom: data.prenom.toString(),
        telephone: data.telephone.toString(),
        adresse: data.adresse.toString(),
        departement: data.departement.toString(),
        numeroSecuriteSociale: data.numeroSecuriteSociale.toString(),
        matricule: data.matricule.toString(),
        servicesAffectation: data.servicesAffectation.toString(),
        salaire: data.salaire.toString(),
        observation: data.observation,
        modePaiement: data.modePaiement.toString(),
        createdAt: data.createdAt,
        ligneBudgtaire: data.ligneBudgtaire.toString(),
        resources: data.resources.toString(),
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire.toString(),
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire.toString(),
        totalDuSalaire: data.totalDuSalaire.toString(),
        nombreHeureSupplementaires: data.nombreHeureSupplementaires.toString(),
        tauxHeureSupplementaires: data.tauxHeureSupplementaires.toString(),
        totalDuHeureSupplementaires:
            data.totalDuHeureSupplementaires.toString(),
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie.toString(),
        prime: data.prime.toString(),
        divers: data.divers.toString(),
        joursCongesPaye: data.joursCongesPaye.toString(),
        tauxCongesPaye: data.tauxCongesPaye.toString(),
        totalDuCongePaye: data.totalDuCongePaye.toString(),
        jourPayeMaladieAccident: data.jourPayeMaladieAccident.toString(),
        tauxJournalierMaladieAccident:
            data.tauxJournalierMaladieAccident.toString(),
        totalDuMaladieAccident: data.totalDuMaladieAccident.toString(),
        pensionDeduction: data.pensionDeduction.toString(),
        indemniteCompensatricesDeduction:
            data.indemniteCompensatricesDeduction.toString(),
        avancesDeduction: data.avancesDeduction.toString(),
        diversDeduction: data.diversDeduction.toString(),
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction.toString(),
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales.toString(),
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales.toString(),
        tauxJoursAllocationsFamiliales:
            data.tauxJoursAllocationsFamiliales.toString(),
        totalAPayerAllocationsFamiliales:
            data.totalAPayerAllocationsFamiliales.toString(),
        netAPayer: data.netAPayer.toString(),
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS.toString(),
        totalDuBrut: data.totalDuBrut.toString(),
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
        signature: data.signature.toString());
    await PaiementSalaireApi().updateData(data.id!, paiementSalaireModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise à jour avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateFIN(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: data.id,
        nom: data.nom.toString(),
        postNom: data.postNom.toString(),
        prenom: data.prenom.toString(),
        telephone: data.telephone.toString(),
        adresse: data.adresse.toString(),
        departement: data.departement.toString(),
        numeroSecuriteSociale: data.numeroSecuriteSociale.toString(),
        matricule: data.matricule.toString(),
        servicesAffectation: data.servicesAffectation.toString(),
        salaire: data.salaire.toString(),
        observation: data.observation,
        modePaiement: data.modePaiement.toString(),
        createdAt: data.createdAt,
        ligneBudgtaire: data.ligneBudgtaire.toString(),
        resources: data.resources.toString(),
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire.toString(),
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire.toString(),
        totalDuSalaire: data.totalDuSalaire.toString(),
        nombreHeureSupplementaires: data.nombreHeureSupplementaires.toString(),
        tauxHeureSupplementaires: data.tauxHeureSupplementaires.toString(),
        totalDuHeureSupplementaires:
            data.totalDuHeureSupplementaires.toString(),
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie.toString(),
        prime: data.prime.toString(),
        divers: data.divers.toString(),
        joursCongesPaye: data.joursCongesPaye.toString(),
        tauxCongesPaye: data.tauxCongesPaye.toString(),
        totalDuCongePaye: data.totalDuCongePaye.toString(),
        jourPayeMaladieAccident: data.jourPayeMaladieAccident.toString(),
        tauxJournalierMaladieAccident:
            data.tauxJournalierMaladieAccident.toString(),
        totalDuMaladieAccident: data.totalDuMaladieAccident.toString(),
        pensionDeduction: data.pensionDeduction.toString(),
        indemniteCompensatricesDeduction:
            data.indemniteCompensatricesDeduction.toString(),
        avancesDeduction: data.avancesDeduction.toString(),
        diversDeduction: data.diversDeduction.toString(),
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction.toString(),
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales.toString(),
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales.toString(),
        tauxJoursAllocationsFamiliales:
            data.tauxJoursAllocationsFamiliales.toString(),
        totalAPayerAllocationsFamiliales:
            data.totalAPayerAllocationsFamiliales.toString(),
        netAPayer: data.netAPayer.toString(),
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS.toString(),
        totalDuBrut: data.totalDuBrut.toString(),
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
        signature: data.signature.toString());
    await PaiementSalaireApi().updateData(data.id!, paiementSalaireModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise à jour avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateBudget(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: data.id,
        nom: data.nom.toString(),
        postNom: data.postNom.toString(),
        prenom: data.prenom.toString(),
        telephone: data.telephone.toString(),
        adresse: data.adresse.toString(),
        departement: data.departement.toString(),
        numeroSecuriteSociale: data.numeroSecuriteSociale.toString(),
        matricule: data.matricule.toString(),
        servicesAffectation: data.servicesAffectation.toString(),
        salaire: data.salaire.toString(),
        observation: data.observation,
        modePaiement: data.modePaiement.toString(),
        createdAt: data.createdAt,
        ligneBudgtaire: ligneBudgtaire.toString(),
        resources: resource.toString(),
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire.toString(),
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire.toString(),
        totalDuSalaire: data.totalDuSalaire.toString(),
        nombreHeureSupplementaires: data.nombreHeureSupplementaires.toString(),
        tauxHeureSupplementaires: data.tauxHeureSupplementaires.toString(),
        totalDuHeureSupplementaires:
            data.totalDuHeureSupplementaires.toString(),
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie.toString(),
        prime: data.prime.toString(),
        divers: data.divers.toString(),
        joursCongesPaye: data.joursCongesPaye.toString(),
        tauxCongesPaye: data.tauxCongesPaye.toString(),
        totalDuCongePaye: data.totalDuCongePaye.toString(),
        jourPayeMaladieAccident: data.jourPayeMaladieAccident.toString(),
        tauxJournalierMaladieAccident:
            data.tauxJournalierMaladieAccident.toString(),
        totalDuMaladieAccident: data.totalDuMaladieAccident.toString(),
        pensionDeduction: data.pensionDeduction.toString(),
        indemniteCompensatricesDeduction:
            data.indemniteCompensatricesDeduction.toString(),
        avancesDeduction: data.avancesDeduction.toString(),
        diversDeduction: data.diversDeduction.toString(),
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction.toString(),
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales.toString(),
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales.toString(),
        tauxJoursAllocationsFamiliales:
            data.tauxJoursAllocationsFamiliales.toString(),
        totalAPayerAllocationsFamiliales:
            data.totalAPayerAllocationsFamiliales.toString(),
        netAPayer: data.netAPayer.toString(),
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS.toString(),
        totalDuBrut: data.totalDuBrut.toString(),
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
        signature: data.signature.toString());
    await PaiementSalaireApi().updateData(widget.id!, paiementSalaireModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise à jour avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateDD(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: data.id,
        nom: data.nom.toString(),
        postNom: data.postNom.toString(),
        prenom: data.prenom.toString(),
        telephone: data.telephone.toString(),
        adresse: data.adresse.toString(),
        departement: data.departement.toString(),
        numeroSecuriteSociale: data.numeroSecuriteSociale.toString(),
        matricule: data.matricule.toString(),
        servicesAffectation: data.servicesAffectation.toString(),
        salaire: data.salaire.toString(),
        observation: data.observation,
        modePaiement: data.modePaiement.toString(),
        createdAt: data.createdAt,
        ligneBudgtaire: data.ligneBudgtaire.toString(),
        resources: data.resources.toString(),
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire.toString(),
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire.toString(),
        totalDuSalaire: data.totalDuSalaire.toString(),
        nombreHeureSupplementaires: data.nombreHeureSupplementaires.toString(),
        tauxHeureSupplementaires: data.tauxHeureSupplementaires.toString(),
        totalDuHeureSupplementaires:
            data.totalDuHeureSupplementaires.toString(),
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie.toString(),
        prime: data.prime.toString(),
        divers: data.divers.toString(),
        joursCongesPaye: data.joursCongesPaye.toString(),
        tauxCongesPaye: data.tauxCongesPaye.toString(),
        totalDuCongePaye: data.totalDuCongePaye.toString(),
        jourPayeMaladieAccident: data.jourPayeMaladieAccident.toString(),
        tauxJournalierMaladieAccident:
            data.tauxJournalierMaladieAccident.toString(),
        totalDuMaladieAccident: data.totalDuMaladieAccident.toString(),
        pensionDeduction: data.pensionDeduction.toString(),
        indemniteCompensatricesDeduction:
            data.indemniteCompensatricesDeduction.toString(),
        avancesDeduction: data.avancesDeduction.toString(),
        diversDeduction: data.diversDeduction.toString(),
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction.toString(),
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales.toString(),
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales.toString(),
        tauxJoursAllocationsFamiliales:
            data.tauxJoursAllocationsFamiliales.toString(),
        totalAPayerAllocationsFamiliales:
            data.totalAPayerAllocationsFamiliales.toString(),
        netAPayer: data.netAPayer.toString(),
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS.toString(),
        totalDuBrut: data.totalDuBrut.toString(),
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
        signature: data.signature.toString());
    await PaiementSalaireApi().updateData(widget.id!, paiementSalaireModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise à jour avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitobservation(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        telephone: data.telephone,
        adresse: data.adresse,
        departement: data.departement,
        numeroSecuriteSociale: data.numeroSecuriteSociale,
        matricule:data. matricule,
        servicesAffectation: data.servicesAffectation,
        salaire: data.salaire,
        observation: isChecked,
        modePaiement: data.modePaiement,
        createdAt: data.createdAt,
        ligneBudgtaire: data.ligneBudgtaire,
        resources: data.resources,
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
        nombreDeJoursAllocationsFamiliales: data.nombreDeJoursAllocationsFamiliales,
        tauxJoursAllocationsFamiliales: data.tauxJoursAllocationsFamiliales,
        totalAPayerAllocationsFamiliales: data.totalAPayerAllocationsFamiliales,
        netAPayer: data.netAPayer,
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS,
        totalDuBrut: data.totalDuBrut,
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
        signature: data.signature);
    await PaiementSalaireApi().updateData(widget.id!, paiementSalaireModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise à jour avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

}
