import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_resultat_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_resultat_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class UpdateCompteResultat extends StatefulWidget {
  const UpdateCompteResultat({Key? key})
      : super(key: key);

  @override
  State<UpdateCompteResultat> createState() => _UpdateCompteResultatState();
}

class _UpdateCompteResultatState extends State<UpdateCompteResultat> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController intituleController = TextEditingController();
  TextEditingController achatMarchandisesController = TextEditingController();
  TextEditingController variationStockMarchandisesController =
      TextEditingController();
  TextEditingController achatApprovionnementsController =
      TextEditingController();
  TextEditingController variationApprovionnementsController =
      TextEditingController();
  TextEditingController autresChargesExterneController =
      TextEditingController();
  TextEditingController impotsTaxesVersementsAssimilesController =
      TextEditingController();
  TextEditingController renumerationPersonnelController =
      TextEditingController();
  TextEditingController chargesSocialasController = TextEditingController();
  TextEditingController dotatiopnsProvisionsController =
      TextEditingController();
  TextEditingController autresChargesController = TextEditingController();
  TextEditingController chargesfinancieresController = TextEditingController();
  TextEditingController chargesExptionnellesController =
      TextEditingController();
  TextEditingController impotSurbeneficesController = TextEditingController();
  TextEditingController soldeCrediteurController = TextEditingController();
  TextEditingController ventesMarchandisesController = TextEditingController();

  TextEditingController productionVendueBienEtSericesController =
      TextEditingController();
  TextEditingController productionStockeeController = TextEditingController();
  TextEditingController productionImmobiliseeController =
      TextEditingController();
  TextEditingController subventionExploitationController =
      TextEditingController();
  TextEditingController autreProduitsController = TextEditingController();
  TextEditingController montantExportationController = TextEditingController();
  TextEditingController produitfinancieresController = TextEditingController();
  TextEditingController produitExceptionnelsController =
      TextEditingController();
  TextEditingController soldeDebiteurController = TextEditingController();

  @override
  void initState() {
    getData();
    setState(() {
      
    });

    super.initState();
  }

  @override
  void dispose() {
    intituleController.dispose();
    achatMarchandisesController.dispose();
    variationStockMarchandisesController.dispose();
    achatApprovionnementsController.dispose();
    variationApprovionnementsController.dispose();
    autresChargesExterneController.dispose();
    impotsTaxesVersementsAssimilesController.dispose();
    renumerationPersonnelController.dispose();
    chargesSocialasController.dispose();
    dotatiopnsProvisionsController.dispose();
    autresChargesController.dispose();
    chargesfinancieresController.dispose();
    chargesExptionnellesController.dispose();
    impotSurbeneficesController.dispose();
    soldeCrediteurController.dispose();
    ventesMarchandisesController.dispose();
    productionVendueBienEtSericesController.dispose();
    productionStockeeController.dispose();
    productionImmobiliseeController.dispose();
    subventionExploitationController.dispose();
    autreProduitsController.dispose();
    montantExportationController.dispose();
    produitfinancieresController.dispose();
    produitExceptionnelsController.dispose();
    soldeDebiteurController.dispose();

    super.dispose();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as CompteResulatsModel;

    intituleController =
        TextEditingController(text: data.intitule);
    achatMarchandisesController = TextEditingController(
        text: data.achatMarchandises);
    variationStockMarchandisesController = TextEditingController(
        text: data.variationStockMarchandises);
    achatApprovionnementsController = TextEditingController(
        text: data.achatApprovionnements);
    variationApprovionnementsController = TextEditingController(
        text: data.variationApprovionnements);
    autresChargesExterneController = TextEditingController(
        text: data.autresChargesExterne);
    chargesfinancieresController = TextEditingController(
        text: data.chargesfinancieres);
    impotsTaxesVersementsAssimilesController = TextEditingController(
        text: data.impotsTaxesVersementsAssimiles);
    renumerationPersonnelController = TextEditingController(
        text: data.renumerationPersonnel);
    chargesSocialasController =
        TextEditingController(text: data.chargesSocialas);
    dotatiopnsProvisionsController = TextEditingController(
        text: data.dotatiopnsProvisions);
    autresChargesController =
        TextEditingController(text: data.autresCharges);
    chargesExptionnellesController = TextEditingController(
        text: data.chargesExptionnelles);
    impotSurbeneficesController = TextEditingController(
        text: data.impotSurbenefices);
    soldeCrediteurController =
        TextEditingController(text: data.soldeCrediteur);
    ventesMarchandisesController = TextEditingController(
        text: data.ventesMarchandises);

    productionVendueBienEtSericesController = TextEditingController(
        text: data.productionVendueBienEtSerices);
    productionStockeeController = TextEditingController(
        text: data.productionStockee);
    productionImmobiliseeController = TextEditingController(
        text: data.productionImmobilisee);
    subventionExploitationController = TextEditingController(
        text: data.subventionExploitation);
    autreProduitsController =
        TextEditingController(text: data.autreProduits);
    montantExportationController = TextEditingController(
        text: data.montantExportation);
    produitfinancieresController = TextEditingController(
        text: data.produitfinancieres);
    produitExceptionnelsController = TextEditingController(
        text: data.produitExceptionnels);
    soldeDebiteurController =
        TextEditingController(text: data.soldeDebiteur);

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
                                  title: 'Compte resultats',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(child: addPageWidget(data)))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget(CompteResulatsModel data) {
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
                      const TitleWidget(title: "Modifier compte résultat"),
                      Row(
                        children: [PrintWidget(onPressed: () {})],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: p20,
                  ),
                  intituleWidget(),
                  const SizedBox(
                    height: p20,
                  ),
                  chargesWidget(),
                  const SizedBox(
                    height: p20,
                  ),
                  produitWidget(),
                  const SizedBox(
                    height: p20,
                  ),
                  BtnWidget(
                      title: 'Soumettre',
                      isLoading: isLoading,
                      press: () {
                        final form = _formKey.currentState!;
                        if (form.validate()) {
                          submit(data);
                          form.reset();
                        }
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chargesWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.amber.shade700),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Charges (Hors taxes)",
              style: bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: p30),
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: achatMarchandisesWidget()),
                  const SizedBox(height: p20),
                  Expanded(child: variationStockMarchandisesWidget())
                ],
              ),
              Row(
                children: [
                  Expanded(child: achatApprovionnementsWidget()),
                  const SizedBox(height: p20),
                  Expanded(child: variationApprovionnementsWidget())
                ],
              ),
              Row(
                children: [
                  Expanded(child: autresChargesExterneWidget()),
                  const SizedBox(height: p20),
                  Expanded(child: impotsTaxesVersementsAssimilesWidget())
                ],
              ),
              chargesfinancieresWidget(),
              Row(
                children: [
                  Expanded(child: renumerationPersonnelWidget()),
                  const SizedBox(height: p20),
                  Expanded(child: chargesSocialasWidget())
                ],
              ),
              Row(
                children: [
                  Expanded(child: dotatiopnsProvisionsWidget()),
                  const SizedBox(height: p20),
                  Expanded(child: autresChargesWidget())
                ],
              ),
              Row(
                children: [
                  Expanded(child: chargesExptionnellesWidget()),
                  const SizedBox(height: p20),
                  Expanded(child: importSurbeneficesWidget())
                ],
              ),
              Row(
                children: [
                  Expanded(child: soldeCrediteurWidget()),
                  const SizedBox(height: p20),
                  Expanded(child: ventesMarchandisesWidget())
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget intituleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: intituleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Intitulé',
            hintText: 'intitule',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget achatMarchandisesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: achatMarchandisesController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Achats Marchandises',
            hintText: 'Achats Marchandises',
          ),
          style: const TextStyle(),
        ));
  }

  Widget variationStockMarchandisesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: variationStockMarchandisesController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Variation Stocks Marchandises',
            hintText: 'Variation Stocks Marchandises',
          ),
        ));
  }

  Widget achatApprovionnementsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: achatApprovionnementsController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Achats Approvionnements',
            hintText: 'Achats Approvionnements',
          ),
          style: const TextStyle(),
        ));
  }

  Widget variationApprovionnementsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: variationApprovionnementsController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Variation Approvionnements',
            hintText: 'Variation Approvionnements',
          ),
          style: const TextStyle(),
        ));
  }

  Widget autresChargesExterneWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: autresChargesExterneController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Autres Charges Externe',
            hintText: 'Autres Charges Externe',
          ),
          style: const TextStyle(),
        ));
  }

  Widget impotsTaxesVersementsAssimilesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: impotsTaxesVersementsAssimilesController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Impôts Taxes Versements Assimiles',
            hintText: 'Impôts Taxes Versements Assimiles',
          ),
          style: const TextStyle(),
        ));
  }

  Widget renumerationPersonnelWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: renumerationPersonnelController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Renumeration du Personnel',
            hintText: 'Renumeration du Personnel',
          ),
          style: const TextStyle(),
        ));
  }

  Widget chargesSocialasWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: chargesSocialasController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Charges Sociales',
            hintText: 'Charges Sociales',
          ),
          style: const TextStyle(),
        ));
  }

  Widget dotatiopnsProvisionsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: dotatiopnsProvisionsController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Dotatioins Provisions',
            hintText: 'Dotatioins Provisions',
          ),
          style: const TextStyle(),
        ));
  }

  Widget autresChargesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: autresChargesController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Autres Charges',
            hintText: 'Autres Charges',
          ),
          style: const TextStyle(),
        ));
  }

  Widget chargesfinancieresWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: chargesfinancieresController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Charges financieres',
            hintText: 'Charges financieres',
          ),
          style: const TextStyle(),
        ));
  }

  Widget chargesExptionnellesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: chargesExptionnellesController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Charges Exptionnelles',
            hintText: 'Charges Exptionnelles',
          ),
          style: const TextStyle(),
        ));
  }

  Widget importSurbeneficesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: impotSurbeneficesController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Impôt Sur le benefices',
            hintText: 'Impôt Sur le benefices',
          ),
          style: const TextStyle(),
        ));
  }

  Widget soldeCrediteurWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: soldeCrediteurController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Solde Crediteur',
            hintText: 'Solde Crediteur',
          ),
          style: const TextStyle(),
        ));
  }

  Widget ventesMarchandisesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: ventesMarchandisesController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Ventes Marchandises',
            hintText: 'Ventes Marchandises',
          ),
          style: const TextStyle(),
        ));
  }

  Widget produitWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0, color: Colors.amber.shade700),
          bottom: BorderSide(width: 1.0, color: Colors.amber.shade700),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Produits (Hors taxes)",
              style: bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: p30),
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: productionVendueBienEtSericesWidget()),
                  const SizedBox(height: p20),
                  Expanded(child: productionStockeeWidget())
                ],
              ),
              Row(
                children: [
                  Expanded(child: productionImmobiliseeWidget()),
                  const SizedBox(height: p20),
                  Expanded(child: subventionExploitationWidget())
                ],
              ),
              Row(
                children: [
                  Expanded(child: autreProduitsWidget()),
                  const SizedBox(height: p20),
                  Expanded(child: montantExportationWidget())
                ],
              ),
              produitfinancieresWidget(),
              Row(
                children: [
                  Expanded(child: produitExceptionnelsWidget()),
                  const SizedBox(height: p20),
                  Expanded(child: soldeDebiteurWidget())
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget productionVendueBienEtSericesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: productionVendueBienEtSericesController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Production Vendue Bien et Serices',
            hintText: 'Production Vendue Bien et Serices',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget productionStockeeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: productionStockeeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Production Stockee',
            hintText: 'Production Stockee',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget productionImmobiliseeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: productionImmobiliseeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Production Immobilisée',
            hintText: 'Production Immobilisée',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget subventionExploitationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: subventionExploitationController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Subvention Exploitation',
            hintText: 'Subvention Exploitation',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget autreProduitsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: autreProduitsController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Autre Produits',
            hintText: 'Autre Produits',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget montantExportationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: montantExportationController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Montant Exportation',
            hintText: 'Montant Exportation',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget produitfinancieresWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: produitfinancieresController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Produits financieres',
            hintText: 'Produits financieres',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget produitExceptionnelsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: produitExceptionnelsController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Produit Exceptionnels',
            hintText: 'Produit Exceptionnels',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget soldeDebiteurWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: soldeDebiteurController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Solde Debiteur',
            hintText: 'Solde Debiteur',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Future<void> submit(CompteResulatsModel data) async {
    final compteResulatsModel = CompteResulatsModel(
        intitule: intituleController.text,
        achatMarchandises: achatMarchandisesController.text,
        variationStockMarchandises: variationStockMarchandisesController.text,
        achatApprovionnements: achatApprovionnementsController.text,
        variationApprovionnements: variationApprovionnementsController.text,
        autresChargesExterne: autresChargesExterneController.text,
        impotsTaxesVersementsAssimiles:
            impotsTaxesVersementsAssimilesController.text,
        renumerationPersonnel: renumerationPersonnelController.text,
        chargesSocialas: chargesSocialasController.text,
        dotatiopnsProvisions: dotatiopnsProvisionsController.text,
        autresCharges: autresChargesController.text,
        chargesfinancieres: chargesfinancieresController.text,
        chargesExptionnelles: chargesExptionnellesController.text,
        impotSurbenefices: impotSurbeneficesController.text,
        soldeCrediteur: soldeCrediteurController.text,
        ventesMarchandises: ventesMarchandisesController.text,
        productionVendueBienEtSerices:
            productionVendueBienEtSericesController.text,
        productionStockee: productionStockeeController.text,
        productionImmobilisee: productionImmobiliseeController.text,
        subventionExploitation: subventionExploitationController.text,
        autreProduits: autreProduitsController.text,
        montantExportation: montantExportationController.text,
        produitfinancieres: produitfinancieresController.text,
        produitExceptionnels: produitExceptionnelsController.text,
        soldeDebiteur: soldeDebiteurController.text,
        signature: user!.matricule.toString(),
        createdRef: data.createdRef,
        created: DateTime.now(),
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await CompteResultatApi().insertData(compteResulatsModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
