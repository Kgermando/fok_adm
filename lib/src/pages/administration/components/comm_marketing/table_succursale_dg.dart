import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/detail_succurssale.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableSuccursaleDG extends StatefulWidget {
  const TableSuccursaleDG({Key? key}) : super(key: key);

  @override
  State<TableSuccursaleDG> createState() => _TableSuccursaleDGState();
}

class _TableSuccursaleDGState extends State<TableSuccursaleDG> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;

  @override
  void initState() {
    agentsColumn();
    agentsRow();
    super.initState();
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
              builder: (context) => DetailSuccursale(id: idPlutoRow.value)));
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
              ClassFilterImplemented(),
            ],
            resolveDefaultColumnFilter: (column, resolver) {
              if (column.field == 'id') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'name') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'province') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'approbationDG') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'approbationDD') {
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
        title: 'Nom succursale',
        field: 'name',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Province',
        field: 'province',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Approbation DG',
        field: 'approbationDG',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Approbation DD',
        field: 'approbationDD',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
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
        width: 200,
        minWidth: 150,
      ),
    ];
  }

  Future agentsRow() async {
    List<SuccursaleModel?> dataList = await SuccursaleApi().getAllData();
    var data = dataList.where((element) => element!.approbationDD == 'Approved' 
        && element.approbationDG == '-');

    if (mounted) {
      setState(() {
        for (var item in data) {
          id = item!.id;
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'name': PlutoCell(value: item.name),
            'province': PlutoCell(value: item.province),
            'approbationDG': PlutoCell(value: item.approbationDG),
            'approbationDD': PlutoCell(value: item.approbationDD),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
