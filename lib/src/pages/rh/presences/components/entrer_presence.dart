import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/presence_entrer_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/presence_entrer_model.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class EntrerPresence extends StatefulWidget {
  const EntrerPresence({Key? key}) : super(key: key);

  @override
  State<EntrerPresence> createState() => _EntrerPresenceState();
}

class _EntrerPresenceState extends State<EntrerPresence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // final ScrollController _controllerScroll = ScrollController();
  // final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  // List<UserModel> agentList = []; // User enregistrer dans le systeme
  List<PresenceEntrerModel> presenceAgentEntrerList = []; // prence agent sortie
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var presenceEntrers = await PresenceEntrerApi().getAllData();
    setState(() {
      user = userModel;
      // agentList = agents;
      presenceAgentEntrerList = presenceEntrers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final presenceModel =
        ModalRoute.of(context)!.settings.arguments as PresenceModel;
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
                            width: 20.0,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ),
                          const SizedBox(
                            width: p10,
                          ),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Fiche de Presence',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                              child: addPageWidget(presenceModel)))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget(PresenceModel data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(p16),
          child: SizedBox(
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TitleWidget(title: 'Entrer'),
                    Column(
                      children: [
                        PrintWidget(onPressed: () {}),
                        Text(DateFormat("dd-MM-yyyy HH:mm")
                            .format(DateTime.now()))
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: p20,
                ),
                agentWidget(data),
                const SizedBox(
                  height: p20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget agentWidget(PresenceModel data) {
    // Agents qui ne sont pas encore entrer
    List<UserModel> presenceUserList = [];

    // Verification de l'agent s'il est deja entrer aujourd'hui
    var presenceEntrerTodayList = presenceAgentEntrerList
        .where((element) => element.reference.day == data.createdRef.day)
        .toList();

    return FutureBuilder<List<UserModel>>(
        future: UserApi().getAllData(),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.hasData) {
            List<UserModel>? agentList = snapshot.data;

            presenceUserList = agentList!
                .toSet()
                .difference(presenceEntrerTodayList.toSet())
                .toList();

            return agentList.isEmpty
                ? Center(
                    child: Text(
                      'Aucun agent dans la liste.',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(fontSize: 24)
                          : const TextStyle(fontSize: 16),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: ListView.builder(
                        itemCount: presenceUserList.length,
                        itemBuilder: (context, index) {
                          var agent = presenceUserList[index];
                          return dataListWidget(agent);
                        }));
          } else {
            return Center(child: loading());
          }
        });
  }

  Widget dataListWidget(UserModel agent) {
    return GestureDetector(
      onDoubleTap: (() => detailAgentDialog(agent)),
      child: Card(
        elevation: 10,
        child: ListTile(
          style: ListTileStyle.list,
          leading: const Icon(Icons.person_pin, size: 40.0),
          title: Text("${agent.nom} ${agent.prenom}"),
          subtitle: Text(agent.matricule),
          trailing: Text(DateFormat("HH:mm").format(DateTime.now())),
          // trailing: isLoading
          //     ? loadingMini()
          //     : IconButton(
          //         tooltip: "Validez l'entrer",
          //         onPressed: () {
          //           setState(() {
          //             isLoading = true;
          //           });
          //           submit(agent).then((value) => setState(() {
          //                 isLoading = false;
          //               }));
          //         },
          //         icon: Icon(Icons.send, color: Colors.amber.shade700)),
        ),
      ),
    );
  }

  detailAgentDialog(UserModel agent) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                  "Heure d'arriver ${DateFormat("HH:mm").format(DateTime.now())}"),
              titleTextStyle: TextStyle(color: Colors.green.shade700),
              content: SizedBox(
                  height: 300,
                  width: 100,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text("Prénom")),
                          const SizedBox(width: p10),
                          Expanded(child: Text(agent.prenom))
                        ],
                      ),
                      const SizedBox(height: p10),
                      Row(
                        children: [
                          const Expanded(child: Text("Nom")),
                          const SizedBox(width: p10),
                          Expanded(child: Text(agent.nom))
                        ],
                      ),
                      const SizedBox(height: p10),
                      Row(
                        children: [
                          const Expanded(child: Text("Matricule")),
                          const SizedBox(width: p10),
                          Expanded(child: Text(agent.matricule))
                        ],
                      ),
                      const SizedBox(height: p10),
                      Expanded(child: noteWidget(agent)),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    submit(agent);
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget noteWidget(UserModel agent) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: noteController,
          keyboardType: TextInputType.multiline,
          minLines: 2,
          maxLines: 5,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Note sur ${agent.prenom} ${agent.nom}",
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

  Future<void> submit(UserModel agent) async {
    final presenceModel = PresenceEntrerModel(
        reference: DateTime.now(),
        nom: agent.nom,
        prenom: agent.prenom,
        matricule: agent.matricule,
        note: (noteController.text == "") ? '-' : noteController.text,
        signature: user!.matricule,
        created: DateTime.now());
    await PresenceEntrerApi().insertData(presenceModel);
    // Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Presence confirmée avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
