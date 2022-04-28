import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/restitution_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/restitution_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/restitutions/components/detail_restitution.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableRestitution extends StatefulWidget {
  const TableRestitution({ Key? key }) : super(key: key);

  @override
  State<TableRestitution> createState() => _TableRestitutionState();
}

class _TableRestitutionState extends State<TableRestitution> {
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
    return PlutoGrid(
      columns: columns,
      rows: rows,
      onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
        final dataList = tapEvent.row!.cells.values;
        final idPlutoRow = dataList.elementAt(0);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailRestitution(id: idPlutoRow.value)));
      },
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager!.setShowColumnFilter(true);
      },
      createHeader: (PlutoGridStateManager header) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
            PrintWidget(onPressed: () {})
          ],
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
            if (column.field == 'idProduct') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'quantity') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'firstName') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'lastName') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'accuseReception') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'accuseReceptionFirstName') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'accuseReceptionLastName') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'succursale') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'created') {
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
        title: 'Id Produit',
        field: 'idProduct',
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
        title: 'Quantité',
        field: 'quantity',
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
        title: 'Nom',
        field: 'firstName',
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
        title: 'Prénom',
        field: 'lastName',
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
        title: 'accuseReception',
        field: 'accuseReception',
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
        title: 'accuse Reception Nom',
        field: 'accuseReceptionFirstName',
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
        title: 'accuse Reception Prénom',
        field: 'accuseReceptionLastName',
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
        title: 'Succursale',
        field: 'succursale',
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
    List<RestitutionModel> dataList = await RestitutionApi().getAllData();
    var data = dataList;

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'idProduct': PlutoCell(value: item.idProduct),
            'quantity': PlutoCell(value: "${item.quantity} ${item.unite}"),
            'firstName': PlutoCell(value: item.firstName),
            'lastName': PlutoCell(value: item.lastName),
            'accuseReception': PlutoCell(value: item.accuseReception),
            'accuseReceptionFirstName': PlutoCell(value: item.accuseReceptionFirstName),
            'accuseReceptionLastName': PlutoCell(value: item.accuseReceptionLastName),
            'succursale': PlutoCell(value: item.succursale),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy H:mm").format(item.created))
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
