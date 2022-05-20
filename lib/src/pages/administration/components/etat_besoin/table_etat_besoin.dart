import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/pages/devis/components/detail_devis.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableEtatBesoin extends StatefulWidget {
  const TableEtatBesoin({Key? key}) : super(key: key);

  @override
  State<TableEtatBesoin> createState() => _TableEtatBesoinState();
}

class _TableEtatBesoinState extends State<TableEtatBesoin> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;

  @override
  initState() {
    agentsColumn();
    getData();
    agentsRow();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? matricule;
  String? departement;
  String? servicesAffectation;
  String? fonctionOccupe;

  Future<void> getData() async {
    final userModel = await AuthApi().getUserId();
    setState(() {
      matricule = userModel.matricule;
      departement = userModel.departement;
      servicesAffectation = userModel.servicesAffectation;
      fonctionOccupe = userModel.fonctionOccupe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: PlutoGrid(
        columns: columns,
        rows: rows,
        onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
          final dataList = tapEvent.row!.cells.values;
          final idPlutoRow = dataList.elementAt(0);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailDevis(id: idPlutoRow.value)));
        },
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager!.setShowColumnFilter(true);
          stateManager!.notifyListeners();
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
              ClassFilterImplemented(),
            ],
            resolveDefaultColumnFilter: (column, resolver) {
              if (column.field == 'id') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'title') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'priority') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'departement') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'approbation') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'observation') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'created') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              }
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            },
          ),
        ),
      ),
    );
  }

  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'Id',
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
        title: 'Titre',
        field: 'title',
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
        title: 'Priorité',
        field: 'priority',
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
        title: 'Département',
        field: 'departement',
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
        title: 'Approbation',
        field: 'approbation',
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
      PlutoColumn(
        readOnly: true,
        title: 'Date',
        field: 'created',
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
    List<DevisModel?> dataList = await DevisAPi().getAllData();
    var data = dataList.where((element) => element!.approbationDG == '-');

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'title': PlutoCell(value: item.title),
            'priority': PlutoCell(value: item.priority),
            'departement': PlutoCell(value: item.departement),
            'approbation': PlutoCell(value: item.approbationDG),
            'observation': PlutoCell(value: item.approbationFin),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
