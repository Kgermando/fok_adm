import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/carburant_api.dart';
import 'package:fokad_admin/src/models/logistiques/carburant_model.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/detail_carburant.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableCarburant extends StatefulWidget {
  const TableCarburant({Key? key}) : super(key: key);

  @override
  State<TableCarburant> createState() => _TableCarburantState();
}

class _TableCarburantState extends State<TableCarburant> {
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
    return Expanded(
      child: PlutoGrid(
        columns: columns,
        rows: rows,
        onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
          final dataList = tapEvent.row!.cells.values;
          final idPlutoRow = dataList.elementAt(0);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailCaburant(id: idPlutoRow.value)));
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
                return resolver<ClassFilterImplemented>()
                    as PlutoFilterType;
              } else if (column.field == 'qtyEntreSortie') {
                return resolver<ClassFilterImplemented>()
                    as PlutoFilterType;
              } else if (column.field == 'typeCaburant') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'fournisseur') {
                return resolver<ClassFilterImplemented>()
                    as PlutoFilterType;
              } else if (column.field == 'nomeroFactureAchat') {
                return resolver<ClassFilterImplemented>()
                    as PlutoFilterType;
              } else if (column.field == 'prixAchatParLitre') {
                return resolver<ClassFilterImplemented>()
                    as PlutoFilterType;
              } else if (column.field == 'nomReceptioniste') {
                return resolver<ClassFilterImplemented>()
                    as PlutoFilterType;
              } else if (column.field == 'numeroPlaque') {
                return resolver<ClassFilterImplemented>()
                    as PlutoFilterType;
              } else if (column.field == 'dateHeureSortieAnguin') {
                return resolver<ClassFilterImplemented>()
                    as PlutoFilterType;
              } else if (column.field == 'created') {
                return resolver<ClassFilterImplemented>()
                    as PlutoFilterType;
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
        title: 'Opération',
        field: 'operationEntreSortie',
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
        title: 'Type Caburant',
        field: 'typeCaburant',
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
        title: 'Fournisseur',
        field: 'fournisseur',
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
        title: 'Numero Facture Achat',
        field: 'nomeroFactureAchat',
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
        title: 'Prix Achat Par Litre',
        field: 'prixAchatParLitre',
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
        title: 'Nom du receptioniste',
        field: 'nomReceptioniste',
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
        title: 'Numero Plaque',
        field: 'numeroPlaque',
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
        title: 'Date Heure Sortie',
        field: 'dateHeureSortieAnguin',
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
    List<CarburantModel?> dataList = await CarburantApi().getAllData();
    var data = dataList;

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'operationEntreSortie': PlutoCell(value: item.operationEntreSortie),
            'typeCaburant': PlutoCell(value: item.typeCaburant),
            'fournisseur': PlutoCell(value: item.fournisseur),
            'nomeroFactureAchat': PlutoCell(value: item.nomeroFactureAchat),
            'prixAchatParLitre': PlutoCell(value: item.prixAchatParLitre),
            'nomReceptioniste': PlutoCell(value: item.nomReceptioniste),
            'numeroPlaque': PlutoCell(value: item.numeroPlaque),
            'dateHeureSortieAnguin': PlutoCell(
                value: DateFormat("dd-MM-yy H:mm")
                    .format(item.dateHeureSortieAnguin)),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy H:mm").format(item.created))
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
