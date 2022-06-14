import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/presence_api.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TablePresence extends StatefulWidget {
  const TablePresence({Key? key}) : super(key: key);

  @override
  State<TablePresence> createState() => _TablePresenceState();
}

class _TablePresenceState extends State<TablePresence> {
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
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
        final dataList = tapEvent.row!.cells.values;
        final idPlutoRow = dataList.elementAt(0);
        Navigator.pushNamed(context, RhRoutes.rhPresenceDetail,
            arguments: idPlutoRow.value);
      },
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager!.setShowColumnFilter(true);
        stateManager!.notifyListeners();
      },
      createHeader: (PlutoGridStateManager header) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RhRoutes.rhPresence);
                },
                icon: Icon(Icons.refresh, color: Colors.green.shade700)),
            PrintWidget(onPressed: () {})
          ],
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
            } else if (column.field == 'arrive') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'sortie') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'finJournee') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'created') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
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
        title: 'Heure d\'arrivé',
        field: 'arrive',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 200,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Heure de sortie',
        field: 'sortie',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 200,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Journée',
        field: 'finJournee',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 200,
      ),
    ];
  }

  Future agentsRow() async {
    List<PresenceModel?> dataList = await PresenceApi().getAllData();
    var data = dataList;

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'arrive': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created)),
            'sortie': PlutoCell(
                value: (item.finJournee == 'true')
                    ? DateFormat("dd-MM-yyyy HH:mm").format(item.createdRef)
                    : "-"),
            'finJournee': PlutoCell(
                value: (item.finJournee == 'true') ? "Journée fini" : 'Journée en cours'),
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
