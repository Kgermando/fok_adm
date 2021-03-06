import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/administration/actionnaire_api.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/administrations/actionnaire_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/agent_pdf.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class DetailAgentPage extends StatefulWidget {
  const DetailAgentPage({Key? key}) : super(key: key);

  @override
  State<DetailAgentPage> createState() => _DetailAgentPageState();
}

class _DetailAgentPageState extends State<DetailAgentPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;
  bool isLoadingAction = false;
  List<UserModel> userList = [];

  bool statutAgent = false;

  @override
  initState() {
    getData();
    super.initState();
  }

  List<ActionnaireModel> actionnaireList = [];
  // AgentModel? agentModel;
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
    final data = await UserApi().getAllData();
    var actionnaires = await ActionnaireApi().getAllData();
    if (mounted) {
      setState(() {
        user = userModel;
        userList = data;
        actionnaireList = actionnaires;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton:
            // speedialWidget(agentModel!),
            FutureBuilder<AgentModel>(
                future: AgentsApi().getOneData(id),
                builder:
                    (BuildContext context, AsyncSnapshot<AgentModel> snapshot) {
                  if (snapshot.hasData) {
                    AgentModel? data = snapshot.data;
                    return
                        // speedialWidget(data!);
                        (int.parse(user.role) <= 3)
                            ? speedialWidget(data!)
                            : Container();
                  } else {
                    return loadingMini();
                  }
                }),
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
                    child: FutureBuilder<AgentModel>(
                        future: AgentsApi().getOneData(id),
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
                                              Navigator.pop(context),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title:
                                              'Agent ${agentModel!.matricule}',
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(child: pageDetail(agentModel))
                              ],
                            );
                          } else {
                            return Center(child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(AgentModel agentModel) {
    var actionnaire = actionnaireList
        .where((element) => element.matricule == agentModel.matricule)
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.all(p16),
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
                    const TitleWidget(title: 'Curriculum vit??'),
                    Row(
                      children: [
                        if (int.parse(user.role) == 0 && actionnaire.isEmpty)
                          IconButton(
                              color: Colors.red.shade700,
                              tooltip: 'Ajout Actionnaire',
                              onPressed: () {
                                actionnaireDialog(agentModel);
                              },
                              icon: const Icon(Icons.admin_panel_settings)),
                        PrintWidget(onPressed: () async {
                          await AgentPdf.generate(agentModel);
                        }),
                      ],
                    )
                  ],
                ),
                identiteWidget(agentModel),
                serviceWidet(agentModel),
                competenceExperienceWidet(agentModel),
                infosEditeurWidet(agentModel),
                const SizedBox(height: p20)
              ],
            ),
          ),
        ),
      ],
    );
  }

  SpeedDial speedialWidget(AgentModel agentModel) {
    return SpeedDial(
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(
            Icons.content_paste_sharp,
            size: 15.0,
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.orange.shade700,
          label: 'Modifier CV agent',
          onPressed: () {
            Navigator.pushNamed(context, RhRoutes.rhAgentUpdate,
                arguments: agentModel);
          },
        ),
        // if (int.parse(user.role) <= 2)
        SpeedDialChild(
          child: const Icon(Icons.safety_divider, size: 15.0),
          foregroundColor: Colors.white,
          backgroundColor: Colors.red.shade700,
          label: 'Activer agent',
          onPressed: () {
            agentStatutDialog(agentModel);
          },
        ),
        SpeedDialChild(
            child: const Icon(Icons.monetization_on),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade700,
            label: 'Paiement',
            onPressed: () {
              Navigator.pushNamed(context, RhRoutes.rhPaiementAdd,
                  arguments: agentModel);
            }),
      ],
    );
  }

  Widget identiteWidget(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.deepOrangeAccent,
                child: ClipOval(
                    child: (agentModel.photo == '' || agentModel.photo == null)
                        ? Image.asset(
                            'assets/images/avatar.jpg',
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          )
                        : Image.network(
                            agentModel.photo!,
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: SfBarcodeGenerator(
                          value: agentModel.matricule,
                          symbology: QRCode(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Statut agent : ',
                          textAlign: TextAlign.start,
                          style: bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      (agentModel.statutAgent == 'true')
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
                      "Cr???? le. ${DateFormat("dd-MM-yyyy HH:mm").format(agentModel.createdAt)}",
                      textAlign: TextAlign.start,
                      style: bodyMedium),
                  Text(
                      "Mise ?? jour le. ${DateFormat("dd-MM-yyyy HH:mm").format(agentModel.created)}",
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
                child: SelectableText(agentModel.nom,
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
                child: SelectableText(agentModel.postNom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Pr??nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(agentModel.prenom,
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
                child: SelectableText(agentModel.email,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('T??l??phone :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(agentModel.telephone,
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
                child: SelectableText(agentModel.sexe,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Niveau d\'accr??ditation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(agentModel.role,
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
                child: SelectableText(agentModel.matricule,
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(color: Colors.blueGrey)),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Num??ro de s??curit?? sociale :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(agentModel.numeroSecuriteSociale,
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
                child: SelectableText(agentModel.lieuNaissance,
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
                    DateFormat("dd-MM-yyyy").format(agentModel.dateNaissance),
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Nationalit?? :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(agentModel.nationalite,
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
                child: SelectableText(agentModel.adresse,
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
                child: SelectableText(agentModel.typeContrat,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Fonction occup??e :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(agentModel.fonctionOccupe,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('departement :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(agentModel.departement,
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
                child: SelectableText(agentModel.servicesAffectation,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Date de d??but du contrat :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(
                    DateFormat("dd-MM-yyyy")
                        .format(agentModel.dateDebutContrat),
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
                      DateFormat("dd-MM-yyyy")
                          .format(agentModel.dateFinContrat),
                      textAlign: TextAlign.start,
                      style: bodyMedium),
                )
              ],
            ),
          if (role <= 3)
            Row(
              children: [
                Expanded(
                  child: Text('Salaire :',
                      textAlign: TextAlign.start,
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: SelectableText("${agentModel.salaire} USD",
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Formation :',
                  textAlign: TextAlign.start,
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              SelectableText(agentModel.competance!,
                  textAlign: TextAlign.justify, style: bodyMedium)
            ],
          ),
          const SizedBox(height: p30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Experience :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              SelectableText(agentModel.experience!,
                  textAlign: TextAlign.justify, style: bodyMedium)
            ],
          ),
        ],
      ),
    );
  }

  Widget infosEditeurWidet(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Signature :',
              style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
          SelectableText(agentModel.signature,
              textAlign: TextAlign.justify, style: bodyMedium)
        ],
      ),
    );
  }

  agentStatutDialog(AgentModel agentModel) {
    // statutAgent = agentModel.statutAgent;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            if (!isLoading) {
              return AlertDialog(
                title: const Text('Autorisation d\'acc??s au syst??me'),
                content: SizedBox(
                  height: 100,
                  width: 200,
                  child: Column(
                    children: [
                      FlutterSwitch(
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
                          // isLoading == true;
                          setState(() {
                            statutAgent = val;
                            String vrai = '';
                            if (statutAgent) {
                              vrai = 'true';
                            } else {
                              vrai = 'false';
                            }
                            if (vrai == 'true') {
                              createUser(
                                  agentModel.nom,
                                  agentModel.prenom,
                                  agentModel.email,
                                  agentModel.telephone,
                                  agentModel.matricule,
                                  agentModel.departement,
                                  agentModel.servicesAffectation,
                                  agentModel.fonctionOccupe,
                                  agentModel.role);
                              updateAgent(agentModel);
                              // isLoading == false;
                            } else if(vrai == 'false') {
                              deleteUser(agentModel);
                              updateAgent(agentModel);
                              // isLoading == false;
                            }
                          });

                          // setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              );
            } else {
              return loading();
            }
          });
        });
  }

  actionnaireDialog(AgentModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Etes vous s??r de faire ceci ?',
                  style: TextStyle(color: Colors.red.shade700)),
              content: isLoadingAction
                  ? Center(child: loading())
                  : Text("Cette action va cr??e un nouvel actionnaire",
                      style: Theme.of(context).textTheme.bodyLarge),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    isLoadingAction = true;
                    actionnaireSubmit(data);
                    // .then((value) => isLoadingAction = false);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
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
        statutAgent: 'true',
        createdAt: agentModel.createdAt,
        photo: agentModel.photo,
        salaire: agentModel.salaire,
        signature: user.matricule,
        created: DateTime.now(),
        approbationDG: agentModel.approbationDG,
        motifDG: agentModel.motifDG,
        signatureDG: agentModel.signatureDG,
        approbationDD: agentModel.approbationDD,
        motifDD: agentModel.motifDD,
        signatureDD: agentModel.signatureDD);
    await AgentsApi().updateData(agent);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Mise ?? statut agent succ??s!"),
      backgroundColor: Colors.blue[700],
    ));
  }

  // Delete user login acc??s
  Future<void> deleteUser(AgentModel agentModel) async {
    final userId = userList
        .where((element) => element.matricule == agentModel.matricule)
        .map((e) => e.id)
        .first;
    await UserApi().deleteData(userId!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Suppression acc??s agent succ??s!"),
      backgroundColor: Colors.red[700],
    ));
  }

  // Create user login acc??s
  Future<void> createUser(
    String nom,
    String prenom,
    String email,
    String telephone,
    String matricule,
    String departement,
    String servicesAffectation,
    String fonctionOccupe,
    String role,
  ) async {
    final userModel = UserModel(
        photo: '-',
        nom: nom,
        prenom: prenom,
        email: email,
        telephone: telephone,
        matricule: matricule,
        departement: departement,
        servicesAffectation: servicesAffectation,
        fonctionOccupe: fonctionOccupe,
        role: role,
        isOnline: 'false',
        createdAt: DateTime.now(),
        passwordHash: '12345678',
        succursale: '-');
    await UserApi().insertData(userModel);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Activation agent avec succ??s!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> actionnaireSubmit(AgentModel data) async {
    final actionnaireModel = ActionnaireModel(
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        email: data.email,
        telephone: data.telephone,
        adresse: data.adresse,
        sexe: data.sexe,
        matricule: data.matricule,
        signature: user.matricule,
        createdRef: data.id!,
        created: DateTime.now());
    await ActionnaireApi().insertData(actionnaireModel);
    Navigator.pop(context, 'ok');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Activation agent avec succ??s!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
