import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/presence_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:routemaster/routemaster.dart';

class ArrivePresence extends StatefulWidget {
  const ArrivePresence({Key? key, required this.presenceModel})
      : super(key: key);
  final PresenceModel presenceModel;

  @override
  State<ArrivePresence> createState() => _ArrivePresenceState();
}

class _ArrivePresenceState extends State<ArrivePresence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  int? id;
  DateTime? arrive;
  List arriveAgent = [];
  DateTime? sortie;
  List sortieAgent = [];
  TextEditingController remarqueController = TextEditingController();
  bool finJournee = false;

  List<UserModel> arriveAgentList = [];

  @override
  void initState() {
    getData();
    setState(() {
      id = widget.presenceModel.id;
      arrive = widget.presenceModel.arrive;
      arriveAgent = widget.presenceModel.arriveAgent;
      sortie = widget.presenceModel.sortie;
      sortieAgent = widget.presenceModel.sortieAgent;
      remarqueController =
          TextEditingController(text: widget.presenceModel.remarque);
      finJournee = widget.presenceModel.finJournee;
    });
    super.initState();
  }

  @override
  void dispose() {
    remarqueController.dispose();
    super.dispose();
  }

  List<UserModel> agentAffectesList = [];
  List<PresenceModel> presenceAgentList = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var agents = await UserApi().getAllData();
    var presences = await PresenceApi().getAllData();
    setState(() {
      user = userModel;
      agentAffectesList = agents;
      presenceAgentList = presences;
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
                                  title: 'Fiche de Presence',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(child: addPageWidget()))
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleWidget(title: 'Entrer'),
                        PrintWidget(onPressed: () {})
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (agentAffectesList.isEmpty)
                          const SelectableText(
                              'Vous n\'avez pas encore du personnelle'),
                        if (agentAffectesList.isNotEmpty)
                          Expanded(child: agentAffectesWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: listAgentPresent())
                      ],
                    ),
                    // remarqueWidget(),
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

  Widget agentAffectesWidget() {
    List<UserModel> presenceList = [];
    for (var u in widget.presenceModel.arriveAgent) {
      presenceList.add(UserModel.fromJson(u));
    }

    List<UserModel> dataList = [];
    var userAgentList = agentAffectesList;

    dataList = userAgentList.toSet().difference(presenceList.toSet()).toList();

    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        height: MediaQuery.of(context).size.height / 1.5,
        child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, i) {
              return ListTile(
                  title: Text(
                      "${dataList[i].matricule} ${dataList[i].nom} ${dataList[i].prenom}"),
                  leading: Checkbox(
                    value: arriveAgentList.contains(dataList[i]),
                    onChanged: (val) {
                      if (val == true) {
                        setState(() {
                          arriveAgentList.add(dataList[i]);
                        });
                      } else {
                        setState(() {
                          arriveAgentList.remove(dataList[i]);
                        });
                      }
                    },
                  ));
            }));
  }

  Widget listAgentPresent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      height: MediaQuery.of(context).size.height / 1.5,
      child: ListView.builder(
          itemCount: arriveAgentList.length,
          itemBuilder: (BuildContext context, index) {
            final agent = arriveAgentList[index];
            return ListTile(
              leading: Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade700,
              ),
              title: Text("${agent.matricule} ${agent.nom} ${agent.prenom}"),
            );
          }),
    );
  }

  Future<void> submit() async {
    final jsonList = arriveAgentList.map((item) => jsonEncode(item)).toList();
    final presenceModel = PresenceModel(
        arrive: DateTime.now(),
        arriveAgent: jsonList,
        sortie: widget.presenceModel.sortie,
        sortieAgent: widget.presenceModel.sortieAgent,
        remarque: remarqueController.text,
        finJournee: finJournee,
        signature: user!.matricule,
        created: DateTime.now());

    await PresenceApi().updateData(widget.presenceModel.id!, presenceModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
