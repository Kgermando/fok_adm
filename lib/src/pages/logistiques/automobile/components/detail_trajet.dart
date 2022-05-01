import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/trajet_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/trajet_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/update_trajet.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class DetailTrajet extends StatefulWidget {
  const DetailTrajet({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<DetailTrajet> createState() => _DetailTrajetState();
}

class _DetailTrajetState extends State<DetailTrajet> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  bool statutAgent = false;

  String? nomeroEntreprise;
  String? nomUtilisateur;
  String? trajetDe;
  String? trajetA;
  String? mission;
  String? kilometrageSorite; // somme d'affectation pour le budget
  String? kilometrageRetour;
  DateTime? created;
  String? signature;

  @override
  initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    TrajetModel data = await TrajetApi().getOneData(widget.id!);
    setState(() {
      nomeroEntreprise = data.nomeroEntreprise;
      nomUtilisateur = data.nomUtilisateur;
      trajetDe = data.trajetDe;
      trajetA = data.trajetA;
      mission = data.mission;
      kilometrageSorite = data.kilometrageSorite;
      kilometrageRetour = data.kilometrageRetour;
      created = data.created;
      signature = data.signature;
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
                    child: FutureBuilder<TrajetModel>(
                        future: TrajetApi().getOneData(widget.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<TrajetModel> snapshot) {
                          if (snapshot.hasData) {
                            TrajetModel? data = snapshot.data;
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
                                          title: data!.nomeroEntreprise,
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

  Widget pageDetail(TrajetModel data) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: data.nomUtilisateur),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            tooltip: "Ajout kilometrage retour",
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateTrajet(trajetModel: data)));
                            }, icon: Icon(Icons.traffic_outlined, color: Colors.red.shade700,)),
                          PrintWidget(
                              tooltip: 'Imprimer le document', onPressed: () {}),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(TrajetModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Numero attribué :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.nomeroEntreprise,
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
                child: Text('Nom complet :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.nomUtilisateur,
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
                child: Text('Trajet De... :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.trajetDe,
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
                child: Text('Trajet A... :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.trajetA,
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
                child: Text('Mission :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.mission,
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
                child: Text('Kilometrage de sorite :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.kilometrageSorite,
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
                child: Text('Kilometrage de retour :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.kilometrageRetour,
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
                child: Text('signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }
}
