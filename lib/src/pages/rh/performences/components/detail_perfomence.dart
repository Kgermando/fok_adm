import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/performence_api.dart';
import 'package:fokad_admin/src/api/rh/performence_note_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/perfomence_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart'; 
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

final _lightColors = [
  Colors.pinkAccent.shade700,
  Colors.tealAccent.shade700,
  Colors.amber.shade700,
  Colors.lightGreen.shade700,
  Colors.lightBlue.shade700,
  Colors.orange.shade700,
];

class DetailPerformence extends StatefulWidget {
  const DetailPerformence({Key? key}) : super(key: key);

  @override
  State<DetailPerformence> createState() => _DetailPerformenceState();
}

class _DetailPerformenceState extends State<DetailPerformence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  @override
  initState() {
    getData();
    super.initState();
  }

  String? signature;
  List<PerformenceNoteModel> performenceNoteList = [];
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var performenceNotes = await PerformenceNoteApi().getAllData();
    setState(() {
      signature = userModel.matricule;
      performenceNoteList = performenceNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<PerformenceModel>(
            future: PerformenceApi().getOneData(id),
            builder: (BuildContext context,
                AsyncSnapshot<PerformenceModel> snapshot) {
              if (snapshot.hasData) {
                PerformenceModel? data = snapshot.data;
                return FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RhRoutes.rhPerformenceAddNote,
                          arguments: data);
                    });
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
                    child: FutureBuilder<PerformenceModel>(
                        future: PerformenceApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<PerformenceModel> snapshot) {
                          if (snapshot.hasData) {
                            PerformenceModel? data = snapshot.data;
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
                                          title: "Performences",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: pageDetail(data!)))
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

  Widget pageDetail(PerformenceModel data) {
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: data.agent),
                  SelectableText(
                      DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                      textAlign: TextAlign.start)
                ],
              ),
              dataWidget(data),
              Divider(
                color: Colors.amber.shade700,
              ),
              listRapport(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(PerformenceModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    List<PerformenceNoteModel> performenceList = [];
    performenceList = performenceNoteList
        .where((element) => element.agent == data.agent)
        .toList();

    double hospitaliteTotal = 0.0;
    double ponctualiteTotal = 0.0;
    double travailleTotal = 0.0;

    for (var item in performenceList) {
      hospitaliteTotal += double.parse(item.hospitalite);
      ponctualiteTotal += double.parse(item.ponctualite);
      travailleTotal += double.parse(item.travaille);
    }

    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.nom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Post-Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.postnom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Prénom:',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.prenom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Matricule :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.agent,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Département :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.departement,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.red.shade700,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SelectableText("CUMULS",
                textAlign: TextAlign.center,
                style: headline6!.copyWith(
                    color: Colors.red.shade700, fontWeight: FontWeight.bold)),
          ]),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text('Hospitalité :',
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700)),
                    SelectableText("$hospitaliteTotal",
                        textAlign: TextAlign.start, style: headline6),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text('Ponctualité :',
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700)),
                    SelectableText("$ponctualiteTotal",
                        textAlign: TextAlign.start, style: headline6),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text('Travaille :',
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade700)),
                    SelectableText("$travailleTotal",
                        textAlign: TextAlign.start, style: headline6),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget listRapport(PerformenceModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return SizedBox(
        height: 500,
        child: FutureBuilder<List<PerformenceNoteModel>>(
            future: PerformenceNoteApi().getAllData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<PerformenceNoteModel>> snapshot) {
              if (snapshot.hasData) {
                List<PerformenceNoteModel>? rapports = snapshot.data!
                    .where((element) => element.agent == data.agent)
                    .toList();

                return rapports.isEmpty
                    ? Column(
                        children: [
                          Center(
                            child: Text(
                              "Pas encore de note.",
                              style: headline6,
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: rapports.length,
                        itemBuilder: (context, index) {
                          final rapport = rapports[index];
                          return buildRapport(rapport, index);
                        });
              } else {
                return Center(child: loading());
              }
            }));
  }

  Widget buildRapport(PerformenceNoteModel rapport, int index) {
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final color = _lightColors[index % _lightColors.length];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(p10),
        child: Column(
          children: [
            ListTile(
              dense: true,
              leading: Icon(Icons.person, color: color),
              title: SelectableText(
                rapport.signature,
                style: bodySmall,
              ),
              // subtitle: SelectableText(
              //   rapport.departement,
              //   style: bodySmall,
              // ),
              trailing: SelectableText(
                  timeago.format(rapport.created, locale: 'fr_short'),
                  textAlign: TextAlign.start,
                  style: bodySmall!.copyWith(color: color)),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text('Hospitalité :',
                          textAlign: TextAlign.start,
                          style: bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700)),
                      SelectableText(rapport.hospitalite,
                          textAlign: TextAlign.start, style: bodyMedium),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text('Ponctualité :',
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700)),
                      SelectableText(rapport.ponctualite,
                          textAlign: TextAlign.start, style: bodyMedium),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text('Travaille :',
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700)),
                      SelectableText(rapport.travaille,
                          textAlign: TextAlign.start, style: bodyMedium),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SelectableText(rapport.note,
                      style: bodyMedium, textAlign: TextAlign.justify),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
