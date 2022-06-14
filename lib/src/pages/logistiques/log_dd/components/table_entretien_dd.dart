import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/entretien_api.dart';
import 'package:fokad_admin/src/models/logistiques/entretien_model.dart'; 
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableEntretienDD extends StatefulWidget {
  const TableEntretienDD({Key? key}) : super(key: key);

  @override
  State<TableEntretienDD> createState() => _TableEntretienDDState();
}

class _TableEntretienDDState extends State<TableEntretienDD> {
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
          Navigator.pushNamed(context, LogistiqueRoutes.logEntretienDetail,
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
                    Navigator.pushNamed(context, LogistiqueRoutes.logDD);
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
              if (column.field == 'nom') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'modele') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'marque') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'etatObjet') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'dureeTravaux') {
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
        title: 'Nom complet',
        field: 'nom',
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
        title: 'Modèle',
        field: 'modele',
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
        title: 'Marque',
        field: 'marque',
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
        title: 'Etat de l\'objet',
        field: 'etatObjet',
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
        title: 'Durée travaux',
        field: 'dureeTravaux',
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
    List<EntretienModel?> dataList = await EntretienApi().getAllData();
    var data =
        dataList.toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          id = item!.id;
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'nom': PlutoCell(value: item.nom),
            'modele': PlutoCell(value: item.modele),
            'marque': PlutoCell(value: item.marque),
            'etatObjet': PlutoCell(value: item.etatObjet),
            'dureeTravaux': PlutoCell(value: item.dureeTravaux),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy H:mm").format(item.created))
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
