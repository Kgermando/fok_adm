import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/presence_entrer_api.dart';
import 'package:fokad_admin/src/api/rh/presence_sortie_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/presence_entrer_model.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';
import 'package:fokad_admin/src/models/rh/presence_sortie_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class SortiePresence extends StatefulWidget {
  const SortiePresence({Key? key}) : super(key: key);

  @override
  State<SortiePresence> createState() => _SortiePresenceState();
}

class _SortiePresenceState extends State<SortiePresence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  int? id;
  DateTime? arrive;
  List arriveAgent = [];
  DateTime? sortie;
  List sortieAgent = [];
  TextEditingController remarqueController = TextEditingController();
  bool finJournee = false;

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

  List<PresenceSortieModel> presenceAgentSortieList = [];
  List<PresenceEntrerModel> presenceAgentEntrerList = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var presenceEntrers = await PresenceEntrerApi().getAllData();
    var presenceSorties = await PresenceSortieApi().getAllData();
    setState(() {
      user = userModel;
      presenceAgentSortieList = presenceSorties;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleWidget(title: 'Sortie'),
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
          ),
        ],
      ),
    );
  }

  Widget agentWidget(PresenceModel data) {
    // Agents qui ne sont pas encore entrer
    List<PresenceEntrerModel> presenceUserList = [];

    // Agent entrer today
    var presenceEntrerTodayList = presenceAgentEntrerList
        .where((element) =>
            element.reference.microsecondsSinceEpoch ==
            data.createdRef.microsecondsSinceEpoch)
        .toList();

    // Verification de l'agent si il est deja sortie aujourd'hui
    var presenceSortieTodayList = presenceAgentSortieList
        .where((element) =>
            element.reference.microsecondsSinceEpoch ==
            data.createdRef.microsecondsSinceEpoch)
        .toList();

    presenceUserList = presenceEntrerTodayList
        .toSet()
        .difference(presenceSortieTodayList.toSet())
        .toList();

    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        height: MediaQuery.of(context).size.height / 1.5,
        child: ListView.builder(
            itemCount: presenceUserList.length,
            itemBuilder: (context, index) {
              var agent = presenceUserList[index];
              return ListTile(
                title: Text("${agent.nom} ${agent.prenom}"),
                subtitle: Text(agent.matricule),
                onLongPress: () {
                  detailAgentDialog(agent);
                },
                trailing: isLoading
                    ? loadingMini()
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          submit(agent);
                        },
                        icon: const Icon(Icons.send)),
              );
            }));
  }

  detailAgentDialog(PresenceEntrerModel agent) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: TitleWidget(
                  title: 'Remarque sur ${agent.nom} ${agent.prenom}'),
              content: SizedBox(
                  height: 200,
                  width: 300,
                  child: Column(
                    children: [noteWidget(agent)],
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget noteWidget(PresenceEntrerModel agent) {
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

  Future<void> submit(PresenceEntrerModel agent) async {
    final presenceModel = PresenceSortieModel(
        reference: DateTime.now(),
        nom: agent.nom,
        prenom: agent.prenom,
        matricule: agent.matricule,
        note: (noteController.text == "") ? '-' : noteController.text,
        signature: user!.matricule,
        created: DateTime.now());
    await PresenceSortieApi().insertData(presenceModel);
    // Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Sortie confirmée avec succès!"),
      backgroundColor: Colors.blue[700],
    ));
  }
}
