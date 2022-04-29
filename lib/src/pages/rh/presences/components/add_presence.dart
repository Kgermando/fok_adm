import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/api/rh/presence_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:routemaster/routemaster.dart';

class AddPresence extends StatefulWidget {
  const AddPresence({Key? key}) : super(key: key);

  @override
  State<AddPresence> createState() => _AddPresenceState();
}

class _AddPresenceState extends State<AddPresence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<String> arriveAgentList = [];
  List<String> sortieAgentList = [];
  TextEditingController remarqueController = TextEditingController();
  bool finJournee = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    remarqueController.dispose();
    super.dispose();
  }

  List<AgentModel> agentAffectesList = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var agents = await AgentsApi().getAllData();
    setState(() {
      user = userModel;
      agentAffectesList = agents;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                  Routemaster.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ),
                           const SizedBox(
                            width: p10,
                          ),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Presence',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addPageWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget() {
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleWidget(title: 'Fiche de Presence'),
                        PrintWidget(onPressed: () {})
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        if(agentAffectesList.isEmpty)
                        const SelectableText('Vous n\'avez pas encore du personnelle'),
                        if (agentAffectesList.isNotEmpty)
                        Expanded(child: agentAffectesWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: listAgentPresent())
                      ],
                    ),
                    remarqueWidget(),
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

  Widget remarqueWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: remarqueController,
          keyboardType: TextInputType.multiline,
          minLines: 2,
          maxLines: 5,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Remarque de la journée',
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

  Widget agentAffectesWidget() {
    final List<String> multiChoises =
        agentAffectesList.map((e) => e.matricule).toSet().toList();
    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        height: MediaQuery.of(context).size.height /2,
        child: ListView.builder(
            itemCount: multiChoises.length,
            itemBuilder: (context, i) {
              return ListTile(
                  title: Text(multiChoises[i]),
                  leading: Checkbox(
                    value: arriveAgentList.contains(multiChoises[i]),
                    onChanged: (val) {
                      if (val == true) {
                        setState(() {
                          arriveAgentList.add(multiChoises[i]);
                        });
                      } else {
                        setState(() {
                          arriveAgentList.remove(multiChoises[i]);
                        });
                      }
                    },
                  ));
            }));
  }

  listAgentPresent() {
    return Expanded(
      child: ListView.builder(
        itemCount: arriveAgentList.length,
        itemBuilder: (BuildContext context, index) {
          final agent = arriveAgentList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            height: MediaQuery.of(context).size.height,
            child: ListTile(
              title: Text(agent),
            ),
          );
      }),
    );
  }

  Future<void> submit() async {
    final presenceModel = PresenceModel(
        arrive: DateTime.now(),
        arriveAgent: arriveAgentList,
        sortie: DateTime.parse("00-00-0 00:00:00"),
        sortieAgent: sortieAgentList,
        remarque: remarqueController.text,
        finJournee: finJournee,
        signature: user!.matricule,
        created: DateTime.now());

    await PresenceApi().insertData(presenceModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
