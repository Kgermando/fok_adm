import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_count_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/country.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/fonction_occupe.dart';
import 'package:fokad_admin/src/utils/service_affectation.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class UpdateAgent extends StatefulWidget {
  const UpdateAgent({Key? key}) : super(key: key);
  // final AgentModel? agentModel;

  @override
  State<UpdateAgent> createState() => _UpdateAgentState();
}

class _UpdateAgentState extends State<UpdateAgent> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final List<String> departementList = Dropdown().departement;
  final List<String> typeContratList = Dropdown().typeContrat;
  final List<String> sexeList = Dropdown().sexe;
  final List<String> roleList = Dropdown().role;
  final List<String> world = Country().world;

  // Fontion occupée
  final List<String> fonctionAdminList = FonctionOccupee().adminDropdown;
  final List<String> fonctionrhList = FonctionOccupee().rhDropdown;
  final List<String> fonctionfinList = FonctionOccupee().finDropdown;
  final List<String> fonctionbudList = FonctionOccupee().budDropdown;
  final List<String> fonctioncompteList = FonctionOccupee().compteDropdown;
  final List<String> fonctionexpList = FonctionOccupee().expDropdown;
  final List<String> fonctioncommList = FonctionOccupee().commDropdown;
  final List<String> fonctionlogList = FonctionOccupee().logDropdown;

  // Service d'affectation
  // final List<String> serviceAffectation = ServiceAffectation().serviceAffectationDropdown;
  final List<String> serviceAffectationAdmin =
      ServiceAffectation().adminDropdown;
  final List<String> serviceAffectationRH = ServiceAffectation().rhDropdown;
  final List<String> serviceAffectationFin = ServiceAffectation().finDropdown;
  final List<String> serviceAffectationBud =
      ServiceAffectation().budgetDropdown;
  final List<String> serviceAffectationCompt =
      ServiceAffectation().comptableDropdown;
  final List<String> serviceAffectationEXp = ServiceAffectation().expDropdown;
  final List<String> serviceAffectationComm = ServiceAffectation().commDropdown;
  final List<String> serviceAffectationLog = ServiceAffectation().logDropdown;

  TextEditingController nomController = TextEditingController();
  TextEditingController postNomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController numeroSecuriteSocialeController =
      TextEditingController();
  TextEditingController dateNaissanceController = TextEditingController();
  TextEditingController lieuNaissanceController = TextEditingController();

  TextEditingController dateDebutContratController = TextEditingController();
  TextEditingController dateFinContratController = TextEditingController();
  TextEditingController competanceController = TextEditingController();
  // HtmlEditorController competanceController = HtmlEditorController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController salaireController = TextEditingController();

  String matricule = "";
  String sexe = "";
  String role = "";
  String nationalite = "";
  String departement = "";
  String typeContrat = "";
  String servicesAffectation = "";
  String fonctionOccupe = "";
  DateTime createdAt = DateTime.now();
  String statutAgent = "";
  String photo = "";

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
    numeroSecuriteSocialeController.dispose();
    dateNaissanceController.dispose();
    lieuNaissanceController.dispose();
    dateDebutContratController.dispose();
    dateFinContratController.dispose();
    competanceController.dispose();
    experienceController.dispose();
    salaireController.dispose();

    super.dispose();
  }

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
  AgentCountModel? agentCount;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    final data = await AgentsApi().getCount();
    setState(() {
      user = userModel;
      agentCount = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as AgentModel;
    final agentModel = ModalRoute.of(context)!.settings.arguments as AgentModel;
    matricule = agentModel.matricule;
    sexe = agentModel.sexe;
    role = agentModel.role;
    nationalite = agentModel.nationalite;
    departement = agentModel.departement;
    typeContrat = agentModel.typeContrat;
    servicesAffectation = agentModel.servicesAffectation;
    fonctionOccupe = agentModel.fonctionOccupe;
    createdAt = agentModel.createdAt;
    statutAgent = agentModel.statutAgent;
    // photo = agentModel.photo!;
    nomController = TextEditingController(text: agentModel.nom);
    postNomController = TextEditingController(text: agentModel.postNom);
    prenomController = TextEditingController(text: agentModel.prenom);
    emailController = TextEditingController(text: agentModel.email);
    telephoneController = TextEditingController(text: agentModel.telephone);
    adresseController = TextEditingController(text: agentModel.adresse);
    numeroSecuriteSocialeController =
        TextEditingController(text: agentModel.numeroSecuriteSociale);
    dateNaissanceController =
        TextEditingController(text: agentModel.dateNaissance.toString());
    dateNaissanceController =
        TextEditingController(text: agentModel.dateNaissance.toString());
    lieuNaissanceController =
        TextEditingController(text: agentModel.lieuNaissance);
    dateDebutContratController =
        TextEditingController(text: agentModel.dateDebutContrat.toString());
    dateFinContratController =
        TextEditingController(text: agentModel.dateFinContrat.toString());
    competanceController = TextEditingController(text: agentModel.competance);
    experienceController = TextEditingController(text: agentModel.experience);
    salaireController = TextEditingController(text: agentModel.salaire);

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
                                title: 'Agent $matricule',
                                controllerMenu: () =>
                                    _key.currentState!.openDrawer()),
                          ),
                        ],
                      ),
                      Expanded(child: updateAgentWidget(data))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget updateAgentWidget(AgentModel data) {
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TitleWidget(title: matricule),
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
                        Expanded(child: servicesAffectationWidget())
                      ],
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
                        Expanded(child: fonctionOccupeWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: roleWidget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: typeContratWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: salaireWidget())
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
          ),
        ],
      ),
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
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
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
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
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
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
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
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
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
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
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
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
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

  Widget numeroSecuriteSocialeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: numeroSecuriteSocialeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Numero Sécurité Sociale',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget dateNaissanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Date de naissance',
          ),
          controller: dateNaissanceController,
          firstDate: DateTime(1930),
          lastDate: DateTime(2100),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
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
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
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
          labelText: 'departement',
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
            if (departement == 'Administration') {
              fonctionList = fonctionAdminList;
              servAffectList = serviceAffectationAdmin;
            } else if (departement == 'Finances') {
              fonctionList = fonctionfinList;
              servAffectList = serviceAffectationFin;
            } else if (departement == 'Comptabilites') {
              fonctionList = fonctioncompteList;
              servAffectList = serviceAffectationCompt;
            } else if (departement == 'Budgets') {
              fonctionList = fonctionbudList;
              servAffectList = serviceAffectationBud;
            } else if (departement == 'Ressources Humaines') {
              fonctionList = fonctionrhList;
              servAffectList = serviceAffectationRH;
            } else if (departement == 'Exploitations') {
              fonctionList = fonctionexpList;
              servAffectList = serviceAffectationEXp;
            } else if (departement == 'Commercial et Marketing') {
              fonctionList = fonctioncommList;
              servAffectList = serviceAffectationComm;
            } else if (departement == 'Logistique') {
              fonctionList = fonctionlogList;
              servAffectList = serviceAffectationLog;
            } else {
              setState(() {
                fonctionList = [];
                servAffectList = [];
              });
            }
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
          items: servAffectList
              .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toSet()
              .toList(),
          onChanged: (value) {
            setState(() {
              servicesAffectation = value!;
            });
          },
        ));
  }

  Widget dateDebutContratWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Date de début du Contrat',
          ),
          controller: dateDebutContratController,
          firstDate: DateTime(1930),
          lastDate: DateTime(2100),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget dateFinContratWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Date de Fin du Contrat',
          ),
          controller: dateFinContratController,
          firstDate: DateTime(1930),
          lastDate: DateTime(2100),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
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
          items: fonctionList
              .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toSet()
              .toList(),
          onChanged: (value) {
            setState(() {
              fonctionOccupe = value!;
            });
          },
        ));
  }

  Widget competanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 100,
          controller: competanceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Formation',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget experienceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 100,
          controller: experienceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Experience',
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget salaireWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: salaireController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Salaire',
                ),
                keyboardType: TextInputType.text,
                style: const TextStyle(),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(width: p20),
            Expanded(
                flex: 1,
                child: Text("\$", style: Theme.of(context).textTheme.headline6))
          ],
        ));
  }

  Future submit(AgentModel data) async {
    final agentModel = AgentModel(
        id: data.id,
        nom: nomController.text,
        postNom: postNomController.text,
        prenom: prenomController.text,
        email: emailController.text,
        telephone: telephoneController.text,
        adresse: adresseController.text,
        sexe: sexe.toString(),
        role: role.toString(),
        matricule: matricule,
        numeroSecuriteSociale: numeroSecuriteSocialeController.text,
        dateNaissance: DateTime.parse(dateNaissanceController.text),
        lieuNaissance: lieuNaissanceController.text,
        nationalite: nationalite.toString(),
        typeContrat: typeContrat.toString(),
        departement: departement.toString(),
        servicesAffectation: servicesAffectation.toString(),
        dateDebutContrat: DateTime.parse(dateDebutContratController.text),
        dateFinContrat: DateTime.parse(dateFinContratController.text),
        fonctionOccupe: fonctionOccupe.toString(),
        competance: competanceController.text,
        experience: experienceController.text,
        statutAgent: 'false',
        createdAt: data.createdAt,
        photo: '-',
        salaire: salaireController.text,
        signature: user.matricule.toString(),
        created: DateTime.now(),
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-'
    );

    await AgentsApi().updateData(agentModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mis a jour agent avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
