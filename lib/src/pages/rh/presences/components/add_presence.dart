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
import 'package:intl/intl.dart';

class AddPresence extends StatefulWidget {
  const AddPresence({Key? key}) : super(key: key);

  @override
  State<AddPresence> createState() => _AddPresenceState();
}

class _AddPresenceState extends State<AddPresence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<UserModel> arriveAgentList = [];
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleWidget(title: 'Arrivée'),
                        Column(
                          children: [
                            PrintWidget(onPressed: () {}),
                            Text(DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now()))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        if (agentAffectesList.isEmpty)
                          const SelectableText(
                              'Vous n\'avez pas encore du personnels'),
                        if (agentAffectesList.isNotEmpty)
                          Expanded(child: agentAffectesWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: listAgentPresent())
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Presence',
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
    List<UserModel> dataList = [];
    var userAgentList = agentAffectesList;
    var presenceList = presenceAgentList;

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
        sortie: DateTime.now(),
        sortieAgent: [],
        remarque: remarqueController.text,
        finJournee: finJournee,
        signature: user!.matricule,
        created: DateTime.now());

    await PresenceApi().insertData(presenceModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Ajouté à la liste de presence avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}

