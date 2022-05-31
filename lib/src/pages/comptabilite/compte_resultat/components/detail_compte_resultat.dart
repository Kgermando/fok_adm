import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_resultat_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_resultat_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comptabilite/compte_resultat/components/update_compte_resultat.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailCompteResultat extends StatefulWidget {
  const DetailCompteResultat({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailCompteResultat> createState() => _DetailCompteResultatState();
}

class _DetailCompteResultatState extends State<DetailCompteResultat> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  String approbationDGController = '-';
  TextEditingController signatureJustificationDGController =
      TextEditingController();

  double totalCharges1 = 0.0;
  double totalCharges123 = 0.0;
  double totalGeneralCharges = 0.0;

  double totalProduits1 = 0.0;
  double totalProduits123 = 0.0;
  double totalGeneralProduits = 0.0;

  @override
  initState() {
    getData();
    super.initState();
  }

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
    var approbations = await ApprobationApi().getAllData();
    setState(() {
      user = userModel;
      approbList = approbations;
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
                    child: FutureBuilder<CompteResulatsModel>(
                        future: CompteResultatApi().getOneData(widget.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<CompteResulatsModel> snapshot) {
                          if (snapshot.hasData) {
                            CompteResulatsModel? data = snapshot.data;
                            totalCharges(data!);
                            totalProduits(data);
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
                                          title: data.intitule,
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
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  totalCharges(CompteResulatsModel data) {
    totalCharges1 = double.parse(data.achatMarchandises) +
        double.parse(data.variationStockMarchandises) +
        double.parse(data.achatApprovionnements) +
        double.parse(data.variationApprovionnements) +
        double.parse(data.autresChargesExterne) +
        double.parse(data.impotsTaxesVersementsAssimiles) +
        double.parse(data.renumerationPersonnel) +
        double.parse(data.chargesSocialas) +
        double.parse(data.dotatiopnsProvisions) +
        double.parse(data.autresCharges) +
        double.parse(data.chargesfinancieres);

    totalCharges123 = totalCharges1 +
        double.parse(data.chargesExptionnelles) +
        double.parse(data.impotSurbenefices);
    totalGeneralCharges = totalCharges123 + double.parse(data.soldeCrediteur);
  }

  totalProduits(CompteResulatsModel data) {
    totalProduits1 = double.parse(data.ventesMarchandises) +
        double.parse(data.productionVendueBienEtSerices) +
        double.parse(data.productionStockee) +
        double.parse(data.productionImmobilisee) +
        double.parse(data.subventionExploitation) +
        double.parse(data.autreProduits) +
        double.parse(data.produitfinancieres);

    totalProduits123 = totalProduits1 + double.parse(data.produitExceptionnels);
    totalGeneralProduits = totalProduits123 +
        double.parse(data.soldeDebiteur) +
        double.parse(data.montantExportation);
  }

  Widget pageDetail(CompteResulatsModel data) {
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
                  TitleWidget(title: data.intitule.toUpperCase()),
                  Column(
                    children: [
                      Row(
                        children: [
                          editButton(data),
                          deleteButton(data),
                          PrintWidget(
                              tooltip: 'Imprimer le document',
                              onPressed: () {}),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget editButton(CompteResulatsModel data) {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.orange.shade700),
      tooltip: "Modifier",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de faire cette action ?'),
          content: const Text('Cette action permet de modifier le ficher.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UpdateCompteResultat(compteResulatsModel: data)));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteButton(CompteResulatsModel data) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade700),
      tooltip: "Supprimer",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de faire cette action ?'),
          content:
              const Text('Cette action va supprimer difinitivement le ficher.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await CompteResultatApi().deleteData(data.id!);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataWidget(CompteResulatsModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Charges (Hors taxes)',
                        textAlign: TextAlign.start,
                        style:
                            headline6!.copyWith(fontWeight: FontWeight.bold)),
                    Divider(color: Colors.amber.shade700),
                    const SizedBox(height: p20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: SelectableText("Comptes",
                              textAlign: TextAlign.start,
                              style: bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1,
                          child: SelectableText("Exercice",
                              textAlign: TextAlign.center,
                              style: bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    Divider(color: Colors.amber.shade700),
                    const SizedBox(height: p30),
                    chargeWidget(data)
                  ],
                ),
              ),
              Container(
                  color: Colors.amber.shade700,
                  width: 2,
                  height: MediaQuery.of(context).size.height / 1.3),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: p8),
                  child: Column(
                    children: [
                      Text('Produits (Hors taxes)',
                          textAlign: TextAlign.start,
                          style:
                              headline6.copyWith(fontWeight: FontWeight.bold)),
                      Divider(color: Colors.amber.shade700),
                      const SizedBox(height: p20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: SelectableText("Comptes",
                                textAlign: TextAlign.start,
                                style: bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 1,
                            child: SelectableText("Exercice",
                                textAlign: TextAlign.center,
                                style: bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      Divider(color: Colors.amber.shade700),
                      const SizedBox(height: p30),
                      produitWidget(data)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget chargeWidget(CompteResulatsModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Achats Marchandises",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.achatMarchandises))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Variation Stock Marchandises",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.variationStockMarchandises))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Achats Approvionnements",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.achatApprovionnements))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Variation Approvionnements",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.variationApprovionnements))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Autres Charges Externe",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.autresChargesExterne))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Impôts Taxes et Versements Assimilés",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.impotsTaxesVersementsAssimiles))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Renumeration du Personnel",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.renumerationPersonnel))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Charges Sociales",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.chargesSocialas))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Dotatiopns Provisions",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.dotatiopnsProvisions))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Autres Charges",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.autresCharges))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Charges financieres",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.chargesfinancieres))} \$",
                    textAlign: TextAlign.center,
                    style: bodyLarge),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text('Total (I):',
                  textAlign: TextAlign.start,
                  style: headline6!.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 1,
              child: SelectableText(
                  "${NumberFormat.decimalPattern('fr').format(totalCharges1)} \$",
                  textAlign: TextAlign.start,
                  style: headline6.copyWith(color: Colors.red.shade700)),
            )
          ],
        ),
        Divider(
          color: Colors.red.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Charges exptionnelles (II)",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.chargesExptionnelles))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.red.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Impôt Sur les benefices (III)",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.impotSurbenefices))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.red.shade700,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AutoSizeText('Total des charges(I + II + III):',
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: headline6.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: SelectableText(
                        "${NumberFormat.decimalPattern('fr').format(totalCharges123)} \$",
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(color: Colors.red.shade700)),
                  )
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.red.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Solde Crediteur (bénéfice) ",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.soldeCrediteur))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        const SizedBox(height: p20),
        Divider(
          color: Colors.red.shade700,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('TOTAL GENERAL :',
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: SelectableText(
                        "${NumberFormat.decimalPattern('fr').format(totalGeneralCharges)} \$",
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(color: Colors.red.shade700)),
                  )
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.red.shade700,
        ),
      ],
    );
  }

  Widget produitWidget(CompteResulatsModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Ventes Marchandises",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.ventesMarchandises))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Production Vendue des Biens Et Services",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.productionVendueBienEtSerices))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Production Stockée",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.productionStockee))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Production Immobilisée",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.productionImmobilisee))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Subvention d'exploitations",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.subventionExploitation))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Autres Produits",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.autreProduits))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Produit financieres",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.produitfinancieres))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.amber.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total (I):',
                      textAlign: TextAlign.start,
                      style: headline6!.copyWith(fontWeight: FontWeight.bold)),
                  SelectableText("Dont à l'exportation :",
                      textAlign: TextAlign.start, style: bodyMedium),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  SelectableText(
                      "${NumberFormat.decimalPattern('fr').format(totalProduits1)} \$",
                      textAlign: TextAlign.start,
                      style: headline6.copyWith(color: Colors.red.shade700)),
                  SelectableText(
                      "${NumberFormat.decimalPattern('fr').format(double.parse(data.montantExportation))} \$",
                      textAlign: TextAlign.center,
                      style: bodyMedium),
                ],
              ),
            )
          ],
        ),
        Divider(
          color: Colors.red.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Produit exceptionnels (II)",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.produitExceptionnels))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.red.shade700,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('Total des produits(I + II):',
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: SelectableText(
                        "${NumberFormat.decimalPattern('fr').format(totalProduits123)} \$",
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(color: Colors.red.shade700)),
                  )
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.red.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SelectableText("Solde debiteur (pertes) :",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.amber.shade700,
                    width: 2,
                  ),
                )),
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.soldeDebiteur))} \$",
                    textAlign: TextAlign.center,
                    style: bodyMedium),
              ),
            )
          ],
        ),
        const SizedBox(height: p20),
        Divider(
          color: Colors.red.shade700,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('TOTAL GENERAL :',
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: SelectableText(
                        "${NumberFormat.decimalPattern('fr').format(totalGeneralProduits)} \$",
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(color: Colors.red.shade700)),
                  )
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.red.shade700,
        ),
      ],
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

  Widget approbationForm(CompteResulatsModel data) {
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

  Future submitApprobation(CompteResulatsModel data) async {
    final approbation = ApprobationModel(
        reference: data.created.microsecondsSinceEpoch,
        title: data.intitule,
        departement: 'Comptabilites',
        fontctionOccupee: user.fonctionOccupe,
        ligneBudgtaire: '-',
        resources: '-',
        approbation: approbationDGController,
        justification: signatureJustificationDGController.text,
        signature: user.matricule,
        created: DateTime.now());
    await ApprobationApi().insertData(approbation);
    Navigator.of(context).pop();
  }
}
