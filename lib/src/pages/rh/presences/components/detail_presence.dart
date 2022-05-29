import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/presence_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/presences/components/arrive_presence.dart';
import 'package:fokad_admin/src/pages/rh/presences/components/sortie_presence.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class DetailPresence extends StatefulWidget {
  const DetailPresence({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailPresence> createState() => _DetailPresenceState();
}

class _DetailPresenceState extends State<DetailPresence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  @override
  initState() {
    getData();
    super.initState();
  }

  PresenceModel? presence;
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    PresenceModel presenceModel = await PresenceApi().getOneData(widget.id);
    setState(() {
      user = userModel;
      presence = presenceModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: (presence != null)
            ? (presence!.finJournee)
                ? Container()
                : speedialWidget()
            : Container(),
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
                        future: PresenceApi().getOneData(widget.id),
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
                                        isAlwaysShown: true,
                                        child: pageDetail(data)))
                              ],
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
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
                  (data.finJournee)
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
                  Expanded(child: listAgentEntrer(data)),
                  const SizedBox(
                    width: p20,
                  ),
                  Expanded(child: listAgentSorties(data))
                ],
              ),
              if (data.finJournee) dataWidget(data),
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
        ],
      ),
    );
  }

  Widget listAgentEntrer(PresenceModel data) {
    List<UserModel> dataList = [];
    for (var u in data.arriveAgent) {
      dataList.add(UserModel.fromJson(u));
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      height: MediaQuery.of(context).size.height / 2,
      child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, index) {
            final agent = dataList[index];
            return ListTile(
              leading: Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade700,
              ),
              title:
                  Text('${agent.nom} ${agent.prenom} <<${agent.matricule}>>'),
              subtitle:
                  Text("Heure: ${DateFormat("HH:mm").format(data.created)}"),
            );
          }),
    );
  }

  Widget listAgentSorties(PresenceModel data) {
    List<UserModel> dataList = [];
    for (var u in data.sortieAgent) {
      dataList.add(UserModel.fromJson(u));
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      height: MediaQuery.of(context).size.height / 2,
      child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, index) {
            final agent = dataList[index];
            return ListTile(
              leading: Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade700,
              ),
              title:
                  Text('${agent.nom} ${agent.prenom} <<${agent.matricule}>>'),
              subtitle:
                  Text("Heure: ${DateFormat("HH:mm").format(data.created)}"),
            );
          }),
    );
  }

  SpeedDial speedialWidget() {
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SortiePresence(presenceModel: presence!)));
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.check_box),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Entrer',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ArrivePresence(presenceModel: presence!)));
          },
        )
      ],
    );
  }
}
