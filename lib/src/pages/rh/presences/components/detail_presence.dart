import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/presence_api.dart';
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
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class DetailPresence extends StatefulWidget {
  const DetailPresence({Key? key}) : super(key: key);

  @override
  State<DetailPresence> createState() => _DetailPresenceState();
}

class _DetailPresenceState extends State<DetailPresence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  bool finJournee = false;
  TextEditingController remarqueController = TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    remarqueController.dispose();
    super.dispose();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<PresenceModel>(
            future: PresenceApi().getOneData(id),
            builder:
                (BuildContext context, AsyncSnapshot<PresenceModel> snapshot) {
              if (snapshot.hasData) {
                PresenceModel? data = snapshot.data;
                return (data != null)
                    ? (data.finJournee == 'true')
                        ? Container()
                        : speedialWidget(data)
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
                    child: FutureBuilder<PresenceModel>(
                        future: PresenceApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<PresenceModel> snapshot) {
                          if (snapshot.hasData) {
                            PresenceModel? data = snapshot.data;
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
                                              "Présence du ${DateFormat("dd-MM-yyyy").format(data!.created)}",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: Scrollbar(
                                        controller: _controllerScroll,
                                        child: pageDetail(data)))
                              ],
                            );
                          } else {
                            return Center(
                                child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(PresenceModel data) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TitleWidget(
                      title:
                          "Presence du ${DateFormat("dd-MM-yy").format(data.created)}"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (data.finJournee == 'true')
                      ? SelectableText("Journée fini.",
                          style:
                              bodyMedium!.copyWith(color: Colors.red.shade700))
                      : SelectableText("Journée en cours...",
                          style: bodyMedium!
                              .copyWith(color: Colors.orange.shade700)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SelectableText("ENTRER",
                        textAlign: TextAlign.center,
                        style: bodyLarge!.copyWith(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    width: p20,
                  ),
                  Expanded(
                    child: SelectableText("SORTIE",
                        textAlign: TextAlign.center,
                        style: bodyLarge.copyWith(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: presenceEntrerWidget(data)),
                  const SizedBox(
                    width: p20,
                  ),
                  Expanded(child: presenceSortieWidget(data))
                ],
              ),
              if (data.finJournee == 'true') dataWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(PresenceModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Rapport de la journée :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.remarque,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          remarqueWidget(),
          checkboxRead(data),
          const SizedBox(
            height: p20,
          ),
        ],
      ),
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

  checkboxRead(PresenceModel data) {
    finJournee = data.finJournee == 'true';
    return isLoading
        ? loadingMini()
        : ListTile(
            leading: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: finJournee,
              onChanged: (bool? value) {
                setState(() {
                  isLoading = true;
                  submit(data);
                });
                setState(() {
                  finJournee = value!;
                });
              },
            ),
            title: const Text("Cocher pour marquer la fin de la journée"),
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

  Widget presenceEntrerWidget(PresenceModel presence) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      height: MediaQuery.of(context).size.height / 2,
      child: FutureBuilder<List<PresenceEntrerModel>>(
          future: PresenceEntrerApi().getAllData(),
          builder: (BuildContext context,
              AsyncSnapshot<List<PresenceEntrerModel>> snapshot) {
            if (snapshot.hasData) {
              List<PresenceEntrerModel>? data = snapshot.data;
              var dataList = data!
                  .where((element) =>
                      element.reference.microsecondsSinceEpoch ==
                      presence.createdRef.microsecondsSinceEpoch)
                  .toList();
              return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext context, index) {
                    final agent = dataList[index];
                    return ListTile(
                      leading: Icon(
                        Icons.person,
                        size: 40.0,
                        color: Colors.green.shade700,
                      ),
                      title: Text(
                          '${agent.nom} ${agent.prenom} <<${agent.matricule}>>'),
                      subtitle: Text(
                          "Heure: ${DateFormat("HH:mm").format(agent.created)}"),
                      onLongPress: () {
                        detailAgentDialog(agent);
                      },
                    );
                  });
            } else {
              return Center(child: loading());
            }
          }),
    );
  }

  detailAgentDialog(PresenceEntrerModel agent) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Infos detail'),
              content: SizedBox(
                height: 200,
                width: 300,
                child: Column(
                  children: [
                    Text("Nom: ${agent.nom}"),
                    Text("Prénom: ${agent.prenom}"),
                    Text("Matricule: ${agent.matricule}"),
                    const Text("Note: "),
                    AutoSizeText(agent.note, textAlign: TextAlign.justify, maxLines: 4),
                    Text("Signé par: ${agent.signature}"),
                    Text("Ajouté le: ${DateFormat("dd-MM-yyyy HH:mm").format(agent.created)}"),  
                  ],
                )
              ),
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

  Widget presenceSortieWidget(PresenceModel presence) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      height: MediaQuery.of(context).size.height / 2,
      child: FutureBuilder<List<PresenceSortieModel>>(
          future: PresenceSortieApi().getAllData(),
          builder: (BuildContext context,
              AsyncSnapshot<List<PresenceSortieModel>> snapshot) {
            if (snapshot.hasData) {
              List<PresenceSortieModel>? data = snapshot.data;
              var dataList = data!
                  .where((element) =>
                      element.reference.microsecondsSinceEpoch ==
                      presence.createdRef.microsecondsSinceEpoch)
                  .toList();
              return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext context, index) {
                    final agent = dataList[index];
                    return ListTile(
                      leading: Icon(
                        Icons.person,
                        size: 40.0,
                        color: Colors.green.shade700,
                      ),
                      title: Text(
                          '${agent.nom} ${agent.prenom} <<${agent.matricule}>>'),
                      subtitle: Text(
                          "Heure: ${DateFormat("HH:mm").format(agent.created)}"),
                    );
                  });
            } else {
              return Center(child: loading());
            }
          }),
    );
  }

  SpeedDial speedialWidget(PresenceModel data) {
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
          child: const Icon(Icons.check_box_outline_blank),
          foregroundColor: Colors.white,
          backgroundColor: Colors.pink.shade700,
          label: 'Sortie',
          onPressed: () {
            Navigator.pushReplacementNamed(context, RhRoutes.rhPresenceSortie,
                arguments: data);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.check_box),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Entrer',
          onPressed: () {
            Navigator.pushReplacementNamed(context, RhRoutes.rhPresenceEntrer,
                arguments: data);
          },
        )
      ],
    );
  }

  Future<void> submit(PresenceModel data) async {
    final presence = PresenceModel(
        remarque: remarqueController.text,
        finJournee: 'true',
        signature: data.signature,
        signatureFermeture: user!.matricule,
        createdRef: data.createdRef,
        created: DateTime.now());
    await PresenceApi().updateData(data.id!, presence);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Fermeture confirmée avec succès!"),
      backgroundColor: Colors.purple[700],
    ));
  }
}
