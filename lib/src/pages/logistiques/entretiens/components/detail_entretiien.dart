import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/entretien_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/entretien_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:routemaster/routemaster.dart';

class DetailEntretien extends StatefulWidget {
  const DetailEntretien({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<DetailEntretien> createState() => _DetailEntretienState();
}

class _DetailEntretienState extends State<DetailEntretien> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  String? nom;
  String? modele;
  String? marque;
  String? etatObjet;
  List objetRemplace = [];
  String? dureeTravaux;
  DateTime? created;
  String? signature;

  @override
  initState() {
    getData();
    agentsColumn();
    agentsRow();
    super.initState();
  }

  Future<void> getData() async {
    EntretienModel data = await EntretienApi().getOneData(widget.id!);
    setState(() {
      nom = data.nom;
      modele = data.modele;
      marque = data.marque;
      etatObjet = data.etatObjet;
      objetRemplace = data.objetRemplace;
      dureeTravaux = data.dureeTravaux;
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
                    child: FutureBuilder<EntretienModel>(
                        future: EntretienApi().getOneData(widget.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<EntretienModel> snapshot) {
                          if (snapshot.hasData) {
                            EntretienModel? data = snapshot.data;
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
                                          title: data!.nom,
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

  Widget pageDetail(EntretienModel data) {
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
                  TitleWidget(title: data.modele),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              tooltip: 'Modifier',
                              onPressed: () {},
                              icon: const Icon(Icons.edit)),
                          PrintWidget(
                              tooltip: 'Imprimer le document', onPressed: () {})
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yy").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              SizedBox(height: 500, child: tableObjetRemplace())
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(EntretienModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Nom Complet :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
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
                child: Text('Modèle :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.modele,
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
                child: Text('Marque :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.marque,
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
                child: Text('Etat de l\'objet :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.etatObjet,
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
                child: Text('signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget tableObjetRemplace() {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
        final dataList = tapEvent.row!.cells.values;
        final idPlutoRow = dataList.elementAt(0);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailEntretien(id: idPlutoRow.value)));
      },
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager!.setShowColumnFilter(true);
      },
      createHeader: (PlutoGridStateManager header) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [PrintWidget(onPressed: () {})],
        );
      },
      configuration: PlutoGridConfiguration(
        columnFilterConfig: PlutoGridColumnFilterConfig(
          filters: const [
            ...FilterHelper.defaultFilters,
            // custom filter
            ClassYouImplemented(),
          ],
          resolveDefaultColumnFilter: (column, resolver) {
            if (column.field == 'nomObjet') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'cout') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'caracteristique') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'observation') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            }
            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
          },
        ),
      ),
    );
  }

  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'Nom Objet',
        field: 'nomObjet',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Coût',
        field: 'cout',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Caracteristique',
        field: 'caracteristique',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Observation',
        field: 'observation',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
    ];
  }

  Future agentsRow() async {
    List<ObjetRemplace> objetRemplaceList = [];
    for (var item in objetRemplace) {
      objetRemplaceList.add(ObjetRemplace.fromJson(item));
    }

    if (mounted) {
      setState(() {
        for (var item in objetRemplaceList) {
          rows.add(PlutoRow(cells: {
            'nomObjet': PlutoCell(value: item.nomObjet),
            'cout': PlutoCell(value: item.cout),
            'caracteristique': PlutoCell(value: item.caracteristique),
            'observation': PlutoCell(value: item.observation)
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}

class ClassYouImplemented implements PlutoFilterType {
  @override
  String get title => 'recherche';

  @override
  get compare => ({
        required String? base,
        required String? search,
        required PlutoColumn? column,
      }) {
        var keys = search!.split(',').map((e) => e.toUpperCase()).toList();

        return keys.contains(base!.toUpperCase());
      };

  const ClassYouImplemented();
}

class ObjetRemplace {
  final String nomObjet;
  final String cout;
  final String caracteristique;
  final String observation;

  ObjetRemplace(
      {required this.nomObjet,
      required this.cout,
      required this.caracteristique,
      required this.observation});

  factory ObjetRemplace.fromJson(Map<String, dynamic> json) {
    return ObjetRemplace(
        nomObjet: json['nomObjet'],
        cout: json['cout'],
        caracteristique: json['caracteristique'],
        observation: json['observation']);
  }
}
