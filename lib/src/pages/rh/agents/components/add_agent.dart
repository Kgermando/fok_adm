import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_count_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/country.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/fonction_occupe.dart';
import 'package:fokad_admin/src/utils/service_affectation.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddAgent extends StatefulWidget {
  const AddAgent({Key? key}) : super(key: key);

  @override
  State<AddAgent> createState() => _AddAgentState();
}

class _AddAgentState extends State<AddAgent> {
  final ScrollController _controllerScroll = ScrollController();

  bool isLoading = false;

  final List<String> departementList = Dropdown().departement;
  final List<String> typeContratList = Dropdown().typeContrat;
  final List<String> sexeList = Dropdown().sexe;
  final List<String> roleList = Dropdown().role;
  final List<String> world = Country().world;
  final List<String> fonctionOccupeAdminList = FonctionOccupee().adminDropdown;
  final List<String> fonctionOccupeList =
      FonctionOccupee().fonctionOccupeDropdown;

  final List<String> serviceAffectation =
      ServiceAffectation().serviceAffectationDropdown;
  final List<String> serviceAffectationAdmin =
      ServiceAffectation().adminDropdown;
  final List<String> serviceAffectationRH = ServiceAffectation().rhDropdown;
  final List<String> serviceAffectationFin = ServiceAffectation().finDropdown;
  final List<String> serviceAffectationEXp = ServiceAffectation().expDropdown;
  final List<String> serviceAffectationComm = ServiceAffectation().commDropdown;
  final List<String> serviceAffectationLog = ServiceAffectation().logDropdown;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController postNomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController lieuNaissanceController = TextEditingController();
  // final TextEditingController servicesAffectationController = TextEditingController();
  final TextEditingController dateDebutContratController =
      TextEditingController();
  final TextEditingController dateFinContratController =
      TextEditingController();
  final TextEditingController competanceController = TextEditingController();
  // HtmlEditorController competanceController = HtmlEditorController();

  final TextEditingController experienceController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  String matricule = "";
  String? sexe;
  String? role;
  String? nationalite;
  String? departement;
  String? typeContrat;
  String? servicesAffectation;
  String? fonctionOccupe;

  List<String> servAffectList = [];
  List<String> fonctionList = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _controllerScroll.dispose();

    nomController.dispose();
    postNomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    adresseController.dispose();
    matriculeController.dispose();
    dateNaissanceController.dispose();
    lieuNaissanceController.dispose();
    // servicesAffectationController.dispose();
    dateDebutContratController.dispose();
    dateFinContratController.dispose();
    competanceController.dispose();
    experienceController.dispose();
    rateController.dispose();

    super.dispose();
  }

  AgentCountModel? agentCount;
  Future<void> getData() async {
    final data = await AgentsApi().getCount();
    setState(() {
      agentCount = data;
      print('agentCount ${agentCount!.count}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => const AddAgent(),
          child: const Icon(Icons.person_add),
        ),
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
                      const CustomAppbar(title: 'Nouveau agent'),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addAgentWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addAgentWidget() {
    return Row(
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
                      Expanded(child: servicesAffectationWidget())
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: roleWidget()),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(child: matriculeWidget())
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: fonctionOccupeWidget()),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(child: typeContratWidget())
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: dateDebutContratWidget()),
                      const SizedBox(
                        width: p10,
                      ),
                      if (typeContrat == 'CDD')
                        Expanded(child: dateFinContratWidget())
                    ],
                  ),
                  competanceWidget(),
                  const SizedBox(
                    width: p10,
                  ),
                  experienceWidget(),
                  const SizedBox(
                    height: p20,
                  ),
                  BtnWidget(
                      title: 'Soumettre',
                      isLoading: isLoading,
                      press: () {
                        submit();
                      })
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Genre',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: sexe,
        isExpanded: true,
        items: sexeList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            sexe = value!;
          });
        },
      ),
    );
  }

  Widget roleWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Niveau d\'accréditation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: role,
        isExpanded: true,
        items: roleList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            role = value!;
          });
        },
      ),
    );
  }

  Widget matriculeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          readOnly: true,
          initialValue: matricule,
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.red),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: matricule,
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget dateNaissanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.date_range),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Date de naissance',
            ),
            controller: dateNaissanceController,
            firstDate: DateTime(1930),
            lastDate: DateTime(2100),
            onChanged: (va) {
              print(
                  'dateDebutContratController ${dateDebutContratController.text}');
            },
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

  Widget typeContratWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type de contrat',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: typeContrat,
        isExpanded: true,
        items: typeContratList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            typeContrat = value!;
            print('typeContrat $typeContrat');
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
            String fokad = 'FO';
            final date = DateFormat("yy").format(DateTime.now());

            if (departement == 'Administration') {
              matricule = "${fokad}ADM$date-${agentCount!.count + 1}";
              fonctionList = fonctionOccupeAdminList;
              servAffectList = serviceAffectationAdmin;
            } else if (departement == 'Comptabilité et Finance') {
              matricule = "${fokad}FIN$date-${agentCount!.count + 1}";
              fonctionList = fonctionOccupeList;
              servAffectList = serviceAffectationFin;
            } else if (departement == 'Ressources Humaines') {
              matricule = "${fokad}RH$date-${agentCount!.count + 1}";
              fonctionList = fonctionOccupeList;
              servAffectList = serviceAffectationRH;
            } else if (departement == 'Exploitations') {
              matricule = "${fokad}EXP$date-${agentCount!.count + 1}";
              fonctionList = fonctionOccupeList;
              servAffectList = serviceAffectationEXp;
            } else if (departement == 'Commercial et Marketing') {
              matricule = "${fokad}COM$date-${agentCount!.count + 1}";
              fonctionList = fonctionOccupeList;
              servAffectList = serviceAffectationComm;
            } else if (departement == 'Logistique') {
              matricule = "${fokad}LOG$date-${agentCount!.count + 1}";
              fonctionList = fonctionOccupeList;
              servAffectList = serviceAffectationLog;
            }
            print('matricule $matricule');
          });
        },
      ),
    );
  }

  Widget servicesAffectationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Service d\'affectation',
            labelStyle: const TextStyle(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: const EdgeInsets.only(left: 5.0),
          ),
          value: servicesAffectation,
          isExpanded: true,
          items: servAffectList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              servicesAffectation = value;
            });
          },
        ));
  }

  Widget dateDebutContratWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.date_range),
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
              prefixIcon: const Icon(Icons.date_range),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Date de Fin du Contrat',
            ),
            controller: dateFinContratController,
            firstDate: DateTime(1930),
            lastDate: DateTime(2100),
            onChanged: (val) {
              setState(() {
                (dateFinContratController.text != "")
                  ? dateFinContratController.text
                  : "2099-12-31 00:00:00";
              });
            },
            validator: (val) {
              return 'Ce champs est obligatoire';
            }));
  }

  Widget fonctionOccupeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Fonction occupée',
            labelStyle: const TextStyle(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: const EdgeInsets.only(left: 5.0),
          ),
          value: fonctionOccupe,
          isExpanded: true,
          items: fonctionList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              fonctionOccupe = value;
            });
          },
        ));
  }

  Widget competanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          minLines: 5,
          maxLines: 100,
          controller: competanceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Formation',
          ),
          keyboardType: TextInputType.text,
          validator: (val) {
            return 'Ce champs est obligatoire';
          },
          style: const TextStyle(),
        )

        //     HtmlEditor(
        //     controller: competanceController, //required
        //     htmlEditorOptions: const HtmlEditorOptions(
        //       hint: "Your text here...",
        //       //initalText: "text content initial, if any",
        //     ),
        //     otherOptions: const OtherOptions(
        //       height: 400,
        //     ),
        // )

        );
  }

  Widget experienceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          minLines: 5,
          maxLines: 100,
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

  Future submit() async {
    print('dateDebutContratController ${dateDebutContratController.text}');
    final agentModel = AgentModel(
        nom: nomController.text,
        postNom: postNomController.text,
        prenom: prenomController.text,
        email: emailController.text,
        telephone: telephoneController.text,
        adresse: adresseController.text,
        sexe: sexe.toString(),
        role: role.toString(),
        matricule: matriculeController.text,
        dateNaissance: DateTime.parse(dateNaissanceController.text),
        lieuNaissance: lieuNaissanceController.text,
        nationalite: nationalite.toString(),
        typeContrat: typeContrat.toString(),
        departement: departement.toString(),
        servicesAffectation: servicesAffectation.toString(),
        dateDebutContrat: DateTime.parse(dateDebutContratController.text),
        dateFinContrat: DateTime.parse(dateFinContratController.text),
        fonctionOccupe: fonctionOccupe.toString(),
        competance: competanceController.toString(),
        experience: experienceController.text,
        statutAgent: true,
        createdAt: DateTime.now(),
        photo: '');

    await AgentsApi().insertData(agentModel);
    Navigator.of(context).pushReplacementNamed(RhRoutes.rhAgent);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
