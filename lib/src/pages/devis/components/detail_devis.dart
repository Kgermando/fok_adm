import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:routemaster/routemaster.dart';

class DetailDevis extends StatefulWidget {
  const DetailDevis({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<DetailDevis> createState() => _DetailDevisState();
}

class _DetailDevisState extends State<DetailDevis> {
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    getData();
    agentsColumn();
    agentsRow();
    super.initState();
  }

  String? title;
  String? priority;
  String? departement;
  List<dynamic>? list;
  bool approbation = false;
  bool observation = false;
  String? signatureDG;
  String? signatureReception;
  String? signatureEmission;
  DateTime? created;

  Future<void> getData() async {
    UserModel user = await AuthApi().getUserId();
    DevisModel data = await DevisAPi().getOneData(widget.id!);
    if (!mounted) return;
    setState(() {
      title = data.title;
      priority = data.priority;
      departement = data.departement;
      list = data.list;
      approbation = data.approbation;
      observation = data.observation;
      signatureDG = data.signatureDG;
      signatureReception = data.signatureReception;
      signatureEmission = data.signatureEmission;
      created = data.created;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        width: p20,
                        child: IconButton(
                            onPressed: () => Routemaster.of(context).pop(),
                            icon: const Icon(Icons.arrow_back)),
                      ),
                      const SizedBox(width: p10),
                      const Expanded(
                          child: CustomAppbar(title: 'Etat de besoin')),
                    ],
                  ),
                  Expanded(
                      child: Scrollbar(
                    controller: _controllerScroll,
                    child: etatBesoinWidget(),
                  ))
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget etatBesoinWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 10,
              child: Container(
                margin: const EdgeInsets.all(p16),
                padding: const EdgeInsets.all(p16),
                width: (Responsive.isDesktop(context))
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width / 1.5,
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
                        TitleWidget(title: 'Etat de besoin de $departement'),
                        Row(
                          children: [PrintWidget(onPressed: () {})],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Intitulé',
                            style: bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(
                            child: SelectableText(
                          title.toString(),
                          style: bodyMedium,
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Priorité',
                            style: bodyMedium.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(
                            child: SelectableText(
                          priority.toString(),
                          style: bodyMedium,
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Département',
                            style: bodyMedium.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(
                            child: SelectableText(
                          departement.toString(),
                          style: bodyMedium,
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Approbation',
                            style: bodyMedium.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(
                            child: (approbation)
                                ? SelectableText(
                                    'Approuvé',
                                    style: bodyMedium.copyWith(
                                        color: Colors.green.shade700),
                                  )
                                : SelectableText(
                                    'Non approuvé',
                                    style: bodyMedium.copyWith(
                                        color: Colors.red.shade700),
                                  ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Observation',
                            style: bodyMedium.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(
                            child: (observation)
                                ? SelectableText(
                                    'Payé',
                                    style: bodyMedium.copyWith(
                                        color: Colors.greenAccent.shade700),
                                  )
                                : SelectableText(
                                    'Non payé',
                                    style: bodyMedium.copyWith(
                                        color: Colors.redAccent.shade700),
                                  ))
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: tableauList(),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget tableauList() {
    return PlutoGrid(
      columns: columns, rows: rows,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager!.setShowColumnFilter(true);
      },
    );
  }

  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'N°',
        field: 'id',
        type: PlutoColumnType.number(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 100,
        minWidth: 80,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'nombre',
        field: 'nombre',
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
        title: 'description',
        field: 'description',
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
        title: 'frais',
        field: 'frais',
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
    // List<dynamic> dataList = list!;
    // var data = dataList;
    if (mounted) {
      setState(() {
        for (var item in list!) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item[0]['id']),
            'title': PlutoCell(value: item[1]['nombre']),
            'priority': PlutoCell(value: item[2]['description']),
            'departement': PlutoCell(value: item[3]['frais']),
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
