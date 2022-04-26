import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/pages/devis/components/detail_devis.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableDevis extends StatefulWidget {
  const TableDevis({ Key? key }) : super(key: key);

  @override
  State<TableDevis> createState() => _TableDevisState();
}

class _TableDevisState extends State<TableDevis> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;

  @override
  initState() {
    agentsColumn();
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
    return PlutoGrid(
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
            if (column.field == 'title') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'priority') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'departement') {
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
    var data = dataList.where((element) => element!.departement == departement && 
      element.approbationDG == 'Approved'  || element.departement == 'Administration' && 
      element.approbationDG == 'Unapproved' || element.departement == 'Finances' && 
      element.approbationDG == 'Approved' && element.approbationFin == 'Unapproved'
    ).toList();
    
    if (mounted) {
      setState(() {
        for (var item in data) {
          id = item!.id;
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'title': PlutoCell(value: item.title),
            'priority': PlutoCell(value: item.priority),
            'departement': PlutoCell(value: item.departement),
            'approbation': PlutoCell(value: item.approbationDG),
            'observation': PlutoCell(value: item.approbationFin),
            'created': PlutoCell(
                value: DateFormat("DD-MM-yy H:mm").format(item.created))
          }));
        }
        stateManager!.resetCurrentState();
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