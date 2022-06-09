import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/salaire_dropsown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class AddPaiementSalaire extends StatefulWidget {
  const AddPaiementSalaire({Key? key}) : super(key: key);

  @override
  State<AddPaiementSalaire> createState() => _AddPaiementSalaireState();
}

class _AddPaiementSalaireState extends State<AddPaiementSalaire> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final List<String> tauxJourHeureMoisSalaireList =
      SalaireDropdown().tauxJourHeureMoisSalaireDropdown;

  final TextEditingController joursHeuresPayeA100PourecentSalaireController =
      TextEditingController();
  final TextEditingController totalDuSalaireController =
      TextEditingController();
  final TextEditingController nombreHeureSupplementairesController =
      TextEditingController();
  final TextEditingController tauxHeureSupplementairesController =
      TextEditingController();
  final TextEditingController totalDuHeureSupplementairesController =
      TextEditingController();
  final TextEditingController
      supplementTravailSamediDimancheJoursFerieController =
      TextEditingController();
  final TextEditingController primeController = TextEditingController();
  final TextEditingController diversController = TextEditingController();
  final TextEditingController joursCongesPayeController =
      TextEditingController();
  final TextEditingController tauxCongesPayeController =
      TextEditingController();
  final TextEditingController totalDuCongePayeController =
      TextEditingController();
  final TextEditingController jourPayeMaladieAccidentController =
      TextEditingController();
  final TextEditingController tauxJournalierMaladieAccidentController =
      TextEditingController();
  final TextEditingController totalDuMaladieAccidentController =
      TextEditingController();
  final TextEditingController pensionDeductionController =
      TextEditingController();
  final TextEditingController indemniteCompensatricesDeductionController =
      TextEditingController();
  final TextEditingController avancesDeductionController =
      TextEditingController();
  final TextEditingController diversDeductionController =
      TextEditingController();
  final TextEditingController retenuesFiscalesDeductionController =
      TextEditingController();
  final TextEditingController
      nombreEnfantBeneficaireAllocationsFamilialesController =
      TextEditingController();
  final TextEditingController nombreDeJoursAllocationsFamilialesController =
      TextEditingController();
  final TextEditingController tauxJoursAllocationsFamilialesController =
      TextEditingController();
  final TextEditingController totalAPayerAllocationsFamilialesController =
      TextEditingController();
  final TextEditingController netAPayerController = TextEditingController();
  final TextEditingController
      montantPrisConsiderationCalculCotisationsINSSController =
      TextEditingController();
  final TextEditingController totalDuBrutController = TextEditingController();

  String? tauxJourHeureMoisSalaire;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _controllerScroll.dispose();

    joursHeuresPayeA100PourecentSalaireController.dispose();
    totalDuSalaireController.dispose();
    nombreHeureSupplementairesController.dispose();
    tauxHeureSupplementairesController.dispose();
    totalDuHeureSupplementairesController.dispose();
    supplementTravailSamediDimancheJoursFerieController.dispose();
    primeController.dispose();
    diversController.dispose();
    joursCongesPayeController.dispose();
    tauxCongesPayeController.dispose();
    totalDuCongePayeController.dispose();
    jourPayeMaladieAccidentController.dispose();
    tauxJournalierMaladieAccidentController.dispose();
    totalDuMaladieAccidentController.dispose();
    pensionDeductionController.dispose();
    indemniteCompensatricesDeductionController.dispose();
    retenuesFiscalesDeductionController.dispose();
    nombreEnfantBeneficaireAllocationsFamilialesController.dispose();
    nombreDeJoursAllocationsFamilialesController.dispose();
    tauxJoursAllocationsFamilialesController.dispose();
    totalAPayerAllocationsFamilialesController.dispose();
    netAPayerController.dispose();
    montantPrisConsiderationCalculCotisationsINSSController.dispose();
    totalDuBrutController.dispose();
    super.dispose();
  }

  List<PaiementSalaireModel?> paiementList = [];
  String? signature;
  Future<void> getData() async {
    UserModel user = await AuthApi().getUserId();
    var paiements = await PaiementSalaireApi().getAllData();
    if (!mounted) return;
    setState(() {
      signature = user.matricule;
      paiementList = paiements
          .where((element) =>
              element.createdAt.month == DateTime.now().month &&
              element.createdAt.year == DateTime.now().year)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final agentModel = ModalRoute.of(context)!.settings.arguments as AgentModel;

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
                  child: Column(
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
                                  title: 'Nouvelle feuille',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addPaiementSalaireWidget(agentModel),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPaiementSalaireWidget(AgentModel agentModel) {
    // var isAgentDouble;
    var isAgentDouble = paiementList
        .where((e) =>
            e!.matricule == agentModel.matricule)
        .toList();

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
              child: ListView(
                controller: _controllerScroll,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleWidget(
                          title:
                              'Feuille de paie du ${DateFormat("MM-yy").format(DateTime.now())}'),
                      Row(
                        children: [PrintWidget(onPressed: () {})],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: p20,
                  ),
                  agentWidget(agentModel),
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
                    if (isAgentDouble.isEmpty)
                      BtnWidget(
                          title: 'Soumettre',
                          isLoading: isLoading,
                          press: () {
                            final form = _formKey.currentState!;
                            if (form.validate()) {
                              submit(agentModel);
                              form.reset();
                            }
                          }),
                          
                    if (isAgentDouble.isNotEmpty)
                      Text("Cet agent a été déjà soumis.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!
                        .copyWith(color: Colors.red.shade700))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget agentWidget(AgentModel agentModel) {
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
              agentModel.matricule,
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
              agentModel.numeroSecuriteSociale,
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
              agentModel.nom,
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
              agentModel.prenom,
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
              agentModel.telephone,
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
              agentModel.adresse,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: Colors.amber.shade700),
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
              agentModel.departement,
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
              agentModel.servicesAffectation,
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
              '${agentModel.salaire} USD',
              style: bodyMedium,
            ))
          ],
        ),
      ],
    );
  }

  Widget salaireWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.amber.shade700),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Salaires',
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                tauxJourHeureMoisSalaireWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: joursHeuresPayeA100PourecentSalaireWidget()),
                    Expanded(child: totalDuSalaireWidget())
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tauxJourHeureMoisSalaireWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p10, left: p5),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Taux, Jour, Heure, Mois',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        value: tauxJourHeureMoisSalaire,
        isExpanded: true,
        items: tauxJourHeureMoisSalaireList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            tauxJourHeureMoisSalaire = value!;
          });
        },
      ),
    );
  }

  Widget joursHeuresPayeA100PourecentSalaireWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: joursHeuresPayeA100PourecentSalaireController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'en %',
            hintText: 'en %',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget totalDuSalaireWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: totalDuSalaireController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Total dû',
            hintText: 'Total dû',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget heureSupplementaireWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: nombreHeureSupplementairesWidget()),
                Expanded(flex: 2, child: tauxHeureSupplementairesWidget()),
                Expanded(flex: 2, child: totalDuHeureSupplementairesWidget())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget nombreHeureSupplementairesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: nombreHeureSupplementairesController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nombre Heure',
            hintText: 'Nombre Heure',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget tauxHeureSupplementairesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: tauxHeureSupplementairesController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Taux',
            hintText: 'Taux',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget totalDuHeureSupplementairesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: totalDuHeureSupplementairesController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Total dû',
            hintText: 'Total dû',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget supplementTravailSamediDimancheJoursFerieWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: supplementairesWidget(),
          ),
        ],
      ),
    );
  }

  Widget supplementairesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: supplementTravailSamediDimancheJoursFerieController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Supplement dû travail',
            hintText: 'Supplement dû travail',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget primeWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: primeFielWidget()),
        ],
      ),
    );
  }

  Widget primeFielWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: primeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Prime',
            hintText: 'Prime',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget diversWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Expanded(child: diversFielWidget())],
            ),
          ),
        ],
      ),
    );
  }

  Widget diversFielWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: diversController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Divers',
            hintText: 'Divers',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget congesPayeWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: joursCongesPayeWidget()),
                Expanded(flex: 2, child: tauxCongesPayeWidget()),
                Expanded(flex: 2, child: totalDuCongesPayeWidget())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget joursCongesPayeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: joursCongesPayeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Jours',
            hintText: 'Jours',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget tauxCongesPayeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: tauxCongesPayeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Taux',
            hintText: 'Taux',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget totalDuCongesPayeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: totalDuCongePayeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Total dû',
            hintText: 'Total dû',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget totalDuCongePayeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: totalDuCongePayeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Total dû',
            hintText: 'Total dû',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget maladieAccidentWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: jourPayeMaladieAccidentWidget()),
                Expanded(flex: 2, child: tauxJournalierMaladieAccidentWidget()),
                Expanded(flex: 2, child: totalDuMaladieAccidentWidget())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget jourPayeMaladieAccidentWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: jourPayeMaladieAccidentController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Jours Payé',
            hintText: 'Jours Payé',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget tauxJournalierMaladieAccidentWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: tauxJournalierMaladieAccidentController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Taux',
            hintText: 'Taux',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget totalDuMaladieAccidentWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: totalDuMaladieAccidentController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Total dû',
            hintText: 'Total dû',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget totalDuBrutWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: totalDuBrutFieldWidget()),
        ],
      ),
    );
  }

  Widget totalDuBrutFieldWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: totalDuBrutController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Total dû',
            hintText: 'Total dû',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget deductionWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                indemniteCompensatricesDeductionWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: pensionDeductiontWidget()),
                    Expanded(child: avancesDeductionWidget()),
                    Expanded(child: diversDeductionWidget()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: retenuesFiscalesDeductionWidget())
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pensionDeductiontWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: pensionDeductionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Pension',
            hintText: 'Pension',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget indemniteCompensatricesDeductionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: indemniteCompensatricesDeductionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Indemnité compensatrices',
            hintText: 'Indemnité compensatrices',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget avancesDeductionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: avancesDeductionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Avances',
            hintText: 'Avances',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget diversDeductionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: diversDeductionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Divers',
            hintText: 'Divers',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget retenuesFiscalesDeductionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: retenuesFiscalesDeductionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Retenues fiscales',
            hintText: 'Retenues fiscales',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget allocationsFamilialesWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                nombreEnfantBeneficaireAllocationsFamilialesWidget(),
                nombreDeJoursAllocationsFamilialesWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: tauxJoursAllocationsFamilialesWidget()),
                    Expanded(child: totalAPayerAllocationsFamilialesWidget())
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget nombreEnfantBeneficaireAllocationsFamilialesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: nombreEnfantBeneficaireAllocationsFamilialesController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nombre des enfants béneficaire',
            hintText: 'Nombre des enfants béneficaire',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget nombreDeJoursAllocationsFamilialesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: nombreDeJoursAllocationsFamilialesController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nombre des Jours',
            hintText: 'Nombre des Jours',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget tauxJoursAllocationsFamilialesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: tauxJoursAllocationsFamilialesController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Taux journalier',
            hintText: 'Taux journalier',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget totalAPayerAllocationsFamilialesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: totalAPayerAllocationsFamilialesController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Total à payer',
            hintText: 'Total à payer',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget netAPayerWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Net à payer',
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: netAPayerFieldWidget()),
        ],
      ),
    );
  }

  Widget netAPayerFieldWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: netAPayerController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Total à payer',
            hintText: 'Total à payer',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget montantPrisConsiderationCalculCotisationsINSSWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child:
                  montantPrisConsiderationCalculCotisationsINSSFieldWidget()),
        ],
      ),
    );
  }

  Widget montantPrisConsiderationCalculCotisationsINSSFieldWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: montantPrisConsiderationCalculCotisationsINSSController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Montant pris pour la Cotisations INSS',
            hintText: 'Montant pris pour la Cotisations INSS',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Future<void> submit(AgentModel agentModel) async {
    final paiementSalaireModel = PaiementSalaireModel(
      nom: agentModel.nom,
      postNom: agentModel.postNom,
      prenom: agentModel.prenom,
      telephone: agentModel.telephone,
      adresse: agentModel.adresse,
      departement: agentModel.departement,
      numeroSecuriteSociale: agentModel.numeroSecuriteSociale,
      matricule: agentModel.matricule,
      servicesAffectation: agentModel.servicesAffectation,
      salaire: agentModel.salaire,
      observation: false, // Finance
      modePaiement: '-',
      createdAt: DateTime.now(),
      tauxJourHeureMoisSalaire:
          (tauxJourHeureMoisSalaire == '' || tauxJourHeureMoisSalaire == null)
              ? '-'
              : tauxJourHeureMoisSalaire.toString(),
      joursHeuresPayeA100PourecentSalaire:
          (joursHeuresPayeA100PourecentSalaireController.text == '')
              ? '-'
              : joursHeuresPayeA100PourecentSalaireController.text,
      totalDuSalaire: (totalDuSalaireController.text == '')
          ? '-'
          : totalDuSalaireController.text,
      nombreHeureSupplementaires:
          (nombreHeureSupplementairesController.text == '')
              ? '-'
              : nombreHeureSupplementairesController.text,
      tauxHeureSupplementaires: (tauxHeureSupplementairesController.text == '')
          ? '-'
          : tauxHeureSupplementairesController.text,
      totalDuHeureSupplementaires:
          (totalDuHeureSupplementairesController.text == '')
              ? '-'
              : totalDuHeureSupplementairesController.text,
      supplementTravailSamediDimancheJoursFerie:
          (supplementTravailSamediDimancheJoursFerieController.text == '')
              ? '-'
              : supplementTravailSamediDimancheJoursFerieController.text,
      prime: (primeController.text == '') ? '-' : primeController.text,
      divers: (diversController.text == '') ? '-' : diversController.text,
      joursCongesPaye: (joursCongesPayeController.text == '')
          ? '-'
          : joursCongesPayeController.text,
      tauxCongesPaye: (tauxCongesPayeController.text == '')
          ? '-'
          : tauxCongesPayeController.text,
      totalDuCongePaye: (totalDuCongePayeController.text == '')
          ? '-'
          : totalDuCongePayeController.text,
      jourPayeMaladieAccident: (jourPayeMaladieAccidentController.text == '')
          ? '-'
          : jourPayeMaladieAccidentController.text,
      tauxJournalierMaladieAccident:
          (tauxJournalierMaladieAccidentController.text == '')
              ? '-'
              : tauxJournalierMaladieAccidentController.text,
      totalDuMaladieAccident: (totalDuMaladieAccidentController.text == '')
          ? '-'
          : totalDuMaladieAccidentController.text,
      pensionDeduction: (pensionDeductionController.text == '')
          ? '-'
          : pensionDeductionController.text,
      indemniteCompensatricesDeduction:
          (indemniteCompensatricesDeductionController.text == '')
              ? '-'
              : indemniteCompensatricesDeductionController.text,
      avancesDeduction: (avancesDeductionController.text == '')
          ? '-'
          : avancesDeductionController.text,
      diversDeduction: (diversDeductionController.text == '')
          ? '-'
          : diversDeductionController.text,
      retenuesFiscalesDeduction:
          (retenuesFiscalesDeductionController.text == '')
              ? '-'
              : retenuesFiscalesDeductionController.text,
      nombreEnfantBeneficaireAllocationsFamiliales:
          (nombreEnfantBeneficaireAllocationsFamilialesController.text == '')
              ? '-'
              : retenuesFiscalesDeductionController.text,
      nombreDeJoursAllocationsFamiliales:
          (nombreDeJoursAllocationsFamilialesController.text == '')
              ? '-'
              : nombreDeJoursAllocationsFamilialesController.text,
      tauxJoursAllocationsFamiliales:
          (tauxJoursAllocationsFamilialesController.text == '')
              ? '-'
              : tauxJoursAllocationsFamilialesController.text,
      totalAPayerAllocationsFamiliales:
          (totalAPayerAllocationsFamilialesController.text == '')
              ? '-'
              : totalAPayerAllocationsFamilialesController.text,
      netAPayer:
          (netAPayerController.text == '') ? '-' : netAPayerController.text,
      montantPrisConsiderationCalculCotisationsINSS:
          (montantPrisConsiderationCalculCotisationsINSSController.text == '')
              ? '-'
              : montantPrisConsiderationCalculCotisationsINSSController.text,
      totalDuBrut:
          (totalDuBrutController.text == '') ? '-' : totalDuBrutController.text,

      signature: signature.toString(),
    );
    await PaiementSalaireApi().insertData(paiementSalaireModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
