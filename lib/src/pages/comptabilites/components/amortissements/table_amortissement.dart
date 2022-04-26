import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comptabilite/amortissement_api.dart';
import 'package:fokad_admin/src/models/comptabilites/amortissement_model.dart';
import 'package:fokad_admin/src/pages/comptabilites/components/amortissements/detail_amortisselment.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableAmortissement extends StatefulWidget {
  const TableAmortissement({ Key? key }) : super(key: key);

  @override
  State<TableAmortissement> createState() => _TableAmortissementState();
}

class _TableAmortissementState extends State<TableAmortissement> {
  Timer? timer;
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;

  @override
  initState() {
    agentsColumn();
    timer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      agentsRow();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
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
            builder: (context) => DetailAmortissement(id: idPlutoRow.value)));
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
            if (column.field == 'titleArmotissement') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'comptes') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'intitule') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'montant') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'typeJournal') {
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
        title: 'Titre de l\'armotissement',
        field: 'titleArmotissement',
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
        title: 'Comptes',
        field: 'comptes',
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
        title: 'Intitule',
        field: 'intitule',
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
        title: 'Montant',
        field: 'montant',
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
        title: 'Type de journal',
        field: 'typeJournal',
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
    List<AmortissementModel?> dataList =
        await AmortissementApi().getAllData();
    var data = dataList;

    if (mounted) {
      setState(() {
        for (var item in data) {
          id = item!.id;
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'titleArmotissement': PlutoCell(value: item.titleArmotissement),
            'comptes': PlutoCell(value: item.comptes),
            'intitule': PlutoCell(value: item.intitule),
            'montant': PlutoCell(value: item.montant),
            'typeJournal': PlutoCell(value: item.typeJournal),
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