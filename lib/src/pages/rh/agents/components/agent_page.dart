import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;
  List<UserModel> userList = [];

  bool statutAgent = false;

  @override
  initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    final data = await UserApi().getAllData();
    setState(() {
      userList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: context.read<Controller>().scaffoldKey,
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
                    child: Expanded(
                        child: FutureBuilder<AgentModel>(
                            future: AgentsApi().getOneData(widget.id!),
                            builder: (BuildContext context,
                                AsyncSnapshot<AgentModel> snapshot) {
                              if (snapshot.hasData) {
                                AgentModel? agentModel = snapshot.data;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: p20,
                                          child: IconButton(
                                              onPressed: () =>
                                                  Routemaster.of(context).pop(),
                                              icon:
                                                  const Icon(Icons.arrow_back)),
                                        ),
                                        const SizedBox(width: p10),
                                        Expanded(
                                          child: CustomAppbar(
                                              title:
                                                  'Matricule ${agentModel!.matricule} '),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: pageDetail(agentModel))
                                  ],
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }))),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(AgentModel agentModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.all(10),
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
                    const TitleWidget(title: 'Curriculum vitæ'),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.edit)),
                        statutAgentWidget(agentModel),
                        PrintWidget(
                            tooltip: 'Imprimer le document', onPressed: () {})
                      ],
                    )
                  ],
                ),
                identiteWidet(agentModel),
                serviceWidet(agentModel),
                competenceExperienceWidet(agentModel),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget statutAgentWidget(AgentModel agentModel) {
    return IconButton(
        tooltip: 'Changer le statut agent',
        onPressed: () => agentStatutDialog(agentModel),
        color: Colors.red.shade700,
        icon: const Icon(Icons.person));
  }

  Widget identiteWidet(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                  radius: 50,
                  child: (agentModel.photo == null)
                      ? Image.asset(
                          'assets/images/logo.png',
                          width: 150,
                          height: 150,
                        )
                      : Image.network(
                          agentModel.photo!,
                          width: 150,
                          height: 150,
                        )),
              Column(
                children: [
                  Row(
                    children: [
                      Text('Statut agent : ',
                          textAlign: TextAlign.start,
                          style: bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      (agentModel.statutAgent)
                          ? Text('Actif',
                              textAlign: TextAlign.start,
                              style: bodyMedium.copyWith(
                                  color: Colors.green.shade700))
                          : Text('Inactif',
                              textAlign: TextAlign.start,
                              style: bodyMedium.copyWith(
                                  color: Colors.orange.shade700))
                    ],
                  ),
                  Text(
                      "Créé le. ${DateFormat("dd-MM-yy").format(agentModel.createdAt)}",
                      textAlign: TextAlign.start,
                      style: bodyMedium),
                ],
              )
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.nom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Post-Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.postNom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Prénom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.prenom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Email :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.email,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Téléphone :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.telephone,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Genre :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.sexe,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Niveau d\'accréditation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.role,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Matricule :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.matricule,
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(color: Colors.blueGrey)),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Numéro de sécurité sociale :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.numeroSecuriteSociale,
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(color: Colors.blueGrey)),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Lieu de naissance :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.lieuNaissance,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Date de naissance :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(
                    DateFormat("dd-MM-yy").format(agentModel.dateNaissance),
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Nationalité :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.nationalite,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Adresse :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.adresse,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget serviceWidet(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final role = int.parse(agentModel.role);
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Type de Contrat :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.typeContrat,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Fonction occupée :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.fonctionOccupe,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Département :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.departement,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Services d\'affectation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.servicesAffectation,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Date de début du contrat :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(
                    DateFormat("dd-MM-yy").format(agentModel.dateDebutContrat),
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          if (agentModel.typeContrat == 'CDD')
            Row(
              children: [
                Expanded(
                  child: Text('Date de fin du contrat :',
                      textAlign: TextAlign.start,
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Text(
                      DateFormat("dd-MM-yy").format(agentModel.dateFinContrat),
                      textAlign: TextAlign.start,
                      style: bodyMedium),
                )
              ],
            ),
          if(role <= 3 )
          Row(
            children: [
              Expanded(
                child: Text('Salaire :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.salaire,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget competenceExperienceWidet(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Formation :',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              Text(agentModel.competance!,
                  textAlign: TextAlign.justify, style: bodyMedium)
            ],
          ),
          const SizedBox(height: p30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Experience :',
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              Text(agentModel.experience!,
                  textAlign: TextAlign.justify, style: bodyMedium)
            ],
          ),
        ],
      ),
    );
  }

  agentStatutDialog(AgentModel agentModel) {
    statutAgent = agentModel.statutAgent;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return !isLoading
              ? AlertDialog(
                  title: const Text('Autorisation d\'accès '),
                  content: FlutterSwitch(
                    width: 225.0,
                    height: 55.0,
                    activeColor: Colors.green,
                    inactiveColor: Colors.red,
                    valueFontSize: 25.0,
                    toggleSize: 45.0,
                    value: statutAgent,
                    borderRadius: 30.0,
                    padding: 8.0,
                    showOnOff: true,
                    activeText: 'Active',
                    inactiveText: 'Inactive',
                    onToggle: (val) {
                      setState(() {
                        isLoading == true;
                        statutAgent = val;
                        if (statutAgent) {
                          deleteUser(agentModel);
                          updateAgent(agentModel);
                          // isLoading == false;
                        } else {
                          createUser(agentModel.nom, agentModel.prenom,
                              agentModel.matricule, agentModel.role);
                          updateAgent(agentModel);
                          // isLoading == false;
                        }
                      });
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Routemaster.of(context).pop(),  // Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                )
              : loading();
          });
        });
  }

  // Update statut agent
  Future<void> updateAgent(AgentModel agentModel) async {
    final agent = AgentModel(
      id: agentModel.id,
      nom: agentModel.nom,
      postNom: agentModel.postNom,
      prenom: agentModel.prenom,
      email: agentModel.email,
      telephone: agentModel.telephone,
      adresse: agentModel.adresse,
      sexe: agentModel.sexe,
      role: agentModel.role,
      matricule: agentModel.matricule,
      numeroSecuriteSociale: agentModel.numeroSecuriteSociale,
      dateNaissance: agentModel.dateNaissance,
      lieuNaissance: agentModel.lieuNaissance,
      nationalite: agentModel.nationalite,
      typeContrat: agentModel.typeContrat,
      departement: agentModel.departement,
      servicesAffectation: agentModel.servicesAffectation,
      dateDebutContrat: agentModel.dateDebutContrat,
      dateFinContrat: agentModel.dateFinContrat,
      fonctionOccupe: agentModel.fonctionOccupe,
      statutAgent: statutAgent,
      createdAt: DateTime.now(),
      photo: agentModel.photo,
      salaire: agentModel.salaire
    );
    await AgentsApi().updateData(agentModel.id!, agent);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise à statut avec succès!"),
      backgroundColor: Colors.blue[700],
    ));
  }

  // Delete user login accès
  Future<void> deleteUser(AgentModel agentModel) async {
    final users = userList
        .where((element) => element.matricule == agentModel.matricule)
        .map((e) => e.id)
        .toList();
    await UserApi().deleteData(users.first!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Suppression avec succès!"),
      backgroundColor: Colors.red[700],
    ));
  }

  // Create user login accès
  Future<void> createUser(
    String nom,
    String prenom,
    String matricule,
    String role,
  ) async {
    final userModel = UserModel(
        nom: nom,
        prenom: prenom,
        matricule: matricule,
        role: role,
        isOnline: true,
        createdAt: DateTime.now(),
        passwordHash: "password");
    await UserApi().insertData(userModel);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
