import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:routemaster/routemaster.dart';

class AddPaiementSalaire extends StatefulWidget {
  const AddPaiementSalaire({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<AddPaiementSalaire> createState() => _AddPaiementSalaireState();
}

class _AddPaiementSalaireState extends State<AddPaiementSalaire> {
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _controllerScroll.dispose();

    nomController.dispose();
    prenomController.dispose();

    super.dispose();
  }


  String? matricule;
  String? nom;
  String? postNom;
  String? prenom;
  String? telephone;
  String? adresse;
  String? departement;
  String? numeroSecuriteSociale;
  String? servicesAffectation;
  String? salaire;

  Future<void> getData() async {
    AgentModel data = await AgentsApi().getOneData(widget.id!);
    if (!mounted) return;
    setState(() {
      matricule = data.matricule;
      nom = data.nom;
      postNom = data.postNom;
      prenom = data.prenom;
      telephone = data.telephone;
      adresse = data.adresse;
      departement = data.departement;
      numeroSecuriteSociale = data.numeroSecuriteSociale;
      numeroSecuriteSociale = data.numeroSecuriteSociale;
      servicesAffectation = data.servicesAffectation;
      salaire = data.salaire;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("id ${widget.id}");
    return Scaffold(
        // key: context.read<Controller>().scaffoldKey,
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
                              child: CustomAppbar(title: 'Nouveau bulletin')),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addPaiementSalaireWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPaiementSalaireWidget() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: SizedBox(
                width: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width,
                child: ListView(
                  controller: _controllerScroll,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [PrintWidget(onPressed: () {})],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(child: matriculeWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: numeroSecuriteSocialeWidget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: prenomWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: nomWidget())
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(child: telephoneWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: departementWidget())
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(child: servicesAffectationWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: salaireWidget())
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    adresseWidget(),
                    const SizedBox(
                      height: p20,
                    ),

                    
                    BtnWidget(
                      title: 'Soumettre',
                      isLoading: isLoading,
                      press: () {
                        final form = _formKey.currentState!;
                        if (form.validate()) {
                          submit();
                          form.reset();
                        }
                      })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget matriculeWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium; 
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Matricule', style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
          SelectableText(matricule.toString(), style: bodyMedium,)
        ]
      )
    );
  }

  Widget numeroSecuriteSocialeWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Numéro de securité sociale',
            style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          SelectableText(
            numeroSecuriteSociale.toString(),
            style: bodyMedium,
          )
        ]));
  }

  
  Widget nomWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium; 
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Nom',
          style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        SelectableText(
          nom.toString(),
          style: bodyMedium,
        )
      ]));
  }

  Widget prenomWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Prénom',
            style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          SelectableText(
            prenom.toString(),
            style: bodyMedium,
          )
        ]));
  }

  Widget telephoneWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Téléphone',
            style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          SelectableText(
            telephone.toString(),
            style: bodyMedium,
          )
        ]));
  }

  Widget adresseWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Adresse',
            style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          SelectableText(
            adresse.toString(),
            style: bodyMedium,
          )
        ]));
  }

  Widget departementWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Département',
            style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          SelectableText(
            departement.toString(),
            style: bodyMedium,
          )
        ]));
  }

  Widget servicesAffectationWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Services d\'ffectation',
            style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          SelectableText(
            servicesAffectation.toString(),
            style: bodyMedium,
          )
        ]));
  }

  Widget salaireWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Salaire',
            style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          SelectableText(
            salaire.toString(),
            style: bodyMedium,
          )
        ]));
  }

  submit() {}
}
