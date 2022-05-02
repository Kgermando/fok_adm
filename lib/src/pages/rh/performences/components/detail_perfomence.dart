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
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:routemaster/routemaster.dart';

final _lightColors = [
  Colors.pinkAccent.shade700,
  Colors.tealAccent.shade700,
  Colors.amber.shade700,
  Colors.lightGreen.shade700,
  Colors.lightBlue.shade700,
  Colors.orange.shade700,
];

class DetailPerformence extends StatefulWidget {
  const DetailPerformence({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailPerformence> createState() => _DetailPerformenceState();
}

class _DetailPerformenceState extends State<DetailPerformence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  double hospitaliteTotal = 0.0;
  double ponctualiteTotal = 0.0;
  double travailleTotal = 0.0;

  @override
  initState() {
    getData();
    super.initState();
  }

  PerformenceModel? performenceModel;
  String? signature;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    PerformenceModel data = await PerformenceApi().getOneData(widget.id);
    List<PerformenceNoteModel> dataList =
        await PerformenceNoteApi().getAllData();
    setState(() {
      signature = userModel.matricule;
      performenceModel = data;

      for (var item in dataList) {
        hospitaliteTotal += double.parse(item.hospitalite);
        ponctualiteTotal += double.parse(item.ponctualite);
        travailleTotal += double.parse(item.travaille);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
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
                        future: PerformenceApi().getOneData(widget.id),
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
                                              Routemaster.of(context).pop(),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: data!.agent,
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
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
                  const TitleWidget(title: 'Votre tache'),
                  Column(
                    children: [
                      PrintWidget(
                          tooltip: 'Imprimer le document', onPressed: () {}),
                      SelectableText(
                          DateFormat("dd-MM-yy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
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
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                child: SelectableText(data.hospitalite,
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
                child: SelectableText(data.ponctualite,
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
                child: SelectableText(data.travaille,
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
                child: Text('Agent :',
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
                flex: 3,
                child: Column(
                  children: [
                    Text('Hospitalité :',
                        textAlign: TextAlign.start,
                        style: bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700)),
                    SelectableText("$hospitaliteTotal",
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
                    SelectableText("$ponctualiteTotal",
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
                    SelectableText("$travailleTotal",
                        textAlign: TextAlign.start, style: bodyMedium),
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
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return SizedBox(
        height: 500,
        child: FutureBuilder<List<PerformenceNoteModel>>(
            future: PerformenceNoteApi().getAllData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<PerformenceNoteModel>> snapshot) {
              if (snapshot.hasData) {
                List<PerformenceNoteModel>? rapports = snapshot.data!
                    .where((element) =>
                        element.agent == data.agent)
                    .toList();
                return rapports.isEmpty
                    ? Column(
                        children: [
                          Center(
                            child: Text(
                              "Votre rapport apparait ici.",
                              style: bodyLarge,
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
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Widget buildRapport(PerformenceNoteModel rapport, int index) {
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final color = _lightColors[index % _lightColors.length];

    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(p10),
        child: Column(
          children: [
            ListTile(
              visualDensity: VisualDensity.comfortable,
              dense: true,
              leading: Icon(Icons.person, color: color, size: 50),
              title: SelectableText(
                rapport.signature,
                style: bodySmall,
              ),
              subtitle: SelectableText(
                rapport.departement,
                style: bodySmall,
              ),
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
            SelectableText(rapport.note,
                style: bodyMedium, textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}
