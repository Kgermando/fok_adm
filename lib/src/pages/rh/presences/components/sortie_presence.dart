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

class SortiePresence extends StatefulWidget {
  const SortiePresence({Key? key, required this.presenceModel})
      : super(key: key);
  final PresenceModel presenceModel;

  @override
  State<SortiePresence> createState() => _SortiePresenceState();
}

class _SortiePresenceState extends State<SortiePresence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScrollSortie = ScrollController();
  final ScrollController _controllerScrollListAgent = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  int? id;
  DateTime? arrive;
  List arriveAgent = [];
  DateTime? sortie;
  List sortieAgent = [];
  TextEditingController remarqueController = TextEditingController();
  bool finJournee = false;

  List<UserModel> sortieAgentList = [];

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
    });
    super.initState();
  }

  @override
  void dispose() {
    remarqueController.dispose();
    super.dispose();
  }

  List<UserModel> agentAffectesList = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var agents = await UserApi().getAllData();
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Scrollbar(
                                controller: _controllerScrollSortie,
                                child: agentSortiesWidget())),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(
                            child: Scrollbar(
                                controller: _controllerScrollListAgent,
                                child: listAgentPresent()))
                      ],
                    ),
                    checkboxRead(),
                    remarqueWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Sortie',
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
            labelText: 'Note de la journée',
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

  Widget agentSortiesWidget() {
    List<UserModel> dataArriveList = [];
    // print("arriveAgent $arriveAgent");

    for (var u in arriveAgent) {
      dataArriveList.add(UserModel.fromJson(u));
    }
    List<UserModel> dataSortieList = [];
    for (var u in sortieAgent) {
      dataSortieList.add(UserModel.fromJson(u));
    }

    List<UserModel> dataList = [];

    dataList =
        dataArriveList.toSet().difference(dataSortieList.toSet()).toList();

    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        height: MediaQuery.of(context).size.height / 1.8,
        child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, i) {
              return ListTile(
                  title: Text(
                      "${dataList[i].matricule} ${dataList[i].nom} ${dataList[i].prenom}"),
                  leading: Checkbox(
                    value: sortieAgentList.contains(dataList[i]),
                    onChanged: (val) {
                      if (val!) {
                        setState(() {
                          sortieAgentList.add(dataList[i]);
                        });
                      } else {
                        setState(() {
                          sortieAgentList.remove(dataList[i]);
                        });
                      }
                    },
                  ));
            }));
  }

  Widget listAgentPresent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      height: MediaQuery.of(context).size.height / 1.8,
      child: ListView.builder(
          controller: _controllerScrollListAgent,
          itemCount: sortieAgentList.length,
          itemBuilder: (BuildContext context, index) {
            final agent = sortieAgentList[index];
            return ListTile(
              leading: Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade700,
              ),
              title:
                  Text("<<${agent.matricule}>> ${agent.nom} ${agent.prenom}"),
            );
          }),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.green;
  }

  checkboxRead() {
    finJournee = widget.presenceModel.finJournee;
    return ListTile(
      leading: Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: finJournee,
        onChanged: (bool? value) {
          setState(() {
            isLoading = true;
          });
          setState(() {
            finJournee = value!;
          });
          setState(() {
            isLoading = false;
          });
        },
      ),
      title: const Text("Fin de la journée"),
    );
  }

  Future<void> submit() async {
    final jsonList = sortieAgentList.map((item) => jsonEncode(item)).toList();
    final presenceModel = PresenceModel(
        arrive: widget.presenceModel.arrive,
        arriveAgent: widget.presenceModel.arriveAgent,
        sortie: DateTime.now(),
        sortieAgent: jsonList,
        remarque: remarqueController.text,
        finJournee: finJournee,
        signature: user!.matricule,
        created: DateTime.now());

    await PresenceApi().updateData(widget.presenceModel.id!, presenceModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Sortie confirmé avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
