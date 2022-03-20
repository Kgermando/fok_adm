import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/utils/country.dart';
import 'package:fokad_admin/src/utils/departement.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AgentsRh extends StatefulWidget {
  const AgentsRh({Key? key}) : super(key: key);

  @override
  State<AgentsRh> createState() => _AgentsRhState();
}

class _AgentsRhState extends State<AgentsRh> {
  final ScrollController _controllerScroll = ScrollController();

 bool isLoading = false;

  final List<String> departementList = DepartementList().departement;
  final List<String> world = Country().world;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController postNomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController sexeController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController lieuNaissanceController = TextEditingController();
  final TextEditingController typeContratController = TextEditingController();
  final TextEditingController servicesAffectationController =
      TextEditingController();
  final TextEditingController dateDebutContratController =
      TextEditingController();
  final TextEditingController dateFinContratController =
      TextEditingController();
  final TextEditingController fonctionOccupeController =
      TextEditingController();
  final TextEditingController competanceController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController passwordHashController = TextEditingController();

  String? nationalite;
  String? departement;
  

  @override
  void dispose() {
    nomController.dispose();
    postNomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    adresseController.dispose();
    sexeController.dispose();
    roleController.dispose();
    matriculeController.dispose();
    dateNaissanceController.dispose();
    lieuNaissanceController.dispose();
    typeContratController.dispose();
    servicesAffectationController.dispose();
    dateDebutContratController.dispose();
    dateFinContratController.dispose();
    fonctionOccupeController.dispose();
    competanceController.dispose();
    experienceController.dispose();
    rateController.dispose();
    passwordHashController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addAgent(),
          child: const Icon(Icons.add),
        ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomAppbar(title: 'Liste des Agents'),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            tableWidget()
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget tableWidget() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 2,
      child: Container()
    );
  }

  addAgent() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(p8),
                ),
                backgroundColor: Colors.transparent,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(p16),
                    child: SizedBox(
                      width: Responsive.isDesktop(context)
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.width,
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitleWidget(title: 'Nouveau agent'),
                              PrintWidget(onPressed: () {})
                            ],
                          ),
                          const SizedBox(
                            height: p20,
                          ),
                          Row(
                            children: [
                              Expanded(child: nomWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: postNomWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: prenomWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: sexeWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: dateNaissanceWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: lieuNaissanceWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: nationaliteWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: adresseWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: emailWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: telephoneWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: departmentWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: roleWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: servicesAffectationWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: matriculeWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: dateDebutContratWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: dateFinContratWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: fonctionOccupeWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: rateWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: competanceWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: experienceWidget())
                            ],
                          ),
                          const SizedBox(
                            height: p20,
                          ),
                          BtnWidget(
                            title: 'Soumettre', 
                            isLoading: isLoading,
                            press: () {}
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  Widget nomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget postNomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: postNomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Post-Nom',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget prenomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: prenomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Prénom',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget emailWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Email',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget telephoneWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: telephoneController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Téléphone',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget adresseWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: adresseController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Adresse',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget sexeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: sexeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Sexe',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget roleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: roleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Niveau d\'acreditation',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget matriculeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: matriculeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Matricule',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget dateNaissanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Date de naissance',
            ),
            controller: dateNaissanceController,
            firstDate: DateTime(1930),
            lastDate: DateTime(2100),
            // dateLabelText: 'Date de naissance',
            validator: (val) {
              return 'Ce champs est obligatoire';
            }));
  }

  Widget lieuNaissanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: lieuNaissanceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Lieu de naissance',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget nationaliteWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Nationalite',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: nationalite,
        isExpanded: true,
        items: world.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            nationalite = value!;
          });
        },
      ),
    );
  }

  Widget departmentWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Département',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: departement,
        isExpanded: true,
        items: departementList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            departement = value!;
          });
        },
      ),
    );
  }

  Widget servicesAffectationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: servicesAffectationController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Service d\'affectation',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget dateDebutContratWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Date de début du Contrat',
            ),
            controller: dateDebutContratController,
            firstDate: DateTime(1930),
            lastDate: DateTime(2100),
            // dateLabelText: 'Date de naissance',
            validator: (val) {
              return 'Ce champs est obligatoire';
            }));
  }

  Widget dateFinContratWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Date de Fin du Contrat',
            ),
            controller: dateFinContratController,
            firstDate: DateTime(1930),
            lastDate: DateTime(2100),
            // dateLabelText: 'Date de naissance',
            validator: (val) {
              return 'Ce champs est obligatoire';
            }));
  }

  Widget fonctionOccupeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: fonctionOccupeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Fonction',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget competanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: competanceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Compétance',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget experienceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: experienceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Experience',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Widget rateWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: rateController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Experience',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        ));
  }

  Future submit() async {
    final userModel = UserModel(
        nom: nomController.text,
        postNom: postNomController.text,
        prenom: prenomController.text,
        email: emailController.text,
        telephone: telephoneController.text,
        adresse: adresseController.text,
        sexe: sexeController.text,
        role: roleController.text,
        matricule: matriculeController.text,
        dateNaissance: DateTime.parse(dateNaissanceController.text),
        lieuNaissance: lieuNaissanceController.text,
        nationalite: nationalite.toString(),
        typeContrat: typeContratController.text,
        departement: departement.toString(),
        servicesAffectation: servicesAffectationController.text,
        dateDebutContrat: DateTime.parse(dateDebutContratController.text),
        dateFinContrat: DateTime.parse(dateFinContratController.text),
        fonctionOccupe: fonctionOccupeController.text,
        competance: competanceController.text,
        experience: experienceController.text,
        statutAgent: true,
        isOnline: false,
        createdAt: DateTime.now(),
        passwordHash: passwordHashController.text);
  }
}
