import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/finances/caisse_api.dart';
import 'package:fokad_admin/src/models/finances/caisse_model.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/components/caisses/detail_caisse.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableCaisse extends StatefulWidget {
  const TableCaisse({Key? key}) : super(key: key);

  @override
  State<TableCaisse> createState() => _TableCaisseState();
}

class _TableCaisseState extends State<TableCaisse> {
  Timer? timer;
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  List<CaisseModel?> recetteList = [];
  List<CaisseModel?> depensesList = [];

  int? id;

  double recette = 0.0;
  double depenses = 0.0;
  double solde = 0.0;

  @override
  initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      setState(() {
        getData();
        agentsRow();
      });
      timer.cancel();
    }));

    agentsColumn();
    super.initState();
  }

  Future<void> getData() async {
    List<CaisseModel?> dataList = await CaisseApi().getAllData();
    setState(() {
      List<CaisseModel?> recetteList = dataList
          .where((element) => element!.typeOperation == "Encaissement")
          .toList();
      List<CaisseModel?> depensesList = dataList
          .where((element) => element!.typeOperation == "Decaissement")
          .toList();
      for (var item in recetteList) {
        recette += double.parse(item!.montant);
      }
      for (var item in depensesList) {
        depenses += double.parse(item!.montant);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
              final dataList = tapEvent.row!.cells.values;
              final idPlutoRow = dataList.elementAt(0);

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailCaisse(id: idPlutoRow.value)));
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
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'nomComplet') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'pieceJustificative') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'libelle') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'montant') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'departement') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'typeOperation') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'numeroOperation') {
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
        ),
        totalSolde()
      ],
    );
  }

  Widget totalSolde() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Card(
      color: Colors.red.shade700,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SelectableText('Total recette: ',
                    style: bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(recette)} \$',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white))
              ],
            ),
            Row(
              children: [
                SelectableText('Total dépenses: ',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(depenses)} \$',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white))
              ],
            ),
            Row(
              children: [
                SelectableText('Solde: ',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(recette - depenses)} \$',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white))
              ],
            ),
            const SizedBox(
              width: 100,
            )
          ],
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
        field: 'nomComplet',
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
        title: 'Pièce justificative',
        field: 'pieceJustificative',
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
        title: 'Libelle',
        field: 'libelle',
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
        title: 'departement',
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
        title: 'Type d\'operation',
        field: 'typeOperation',
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
        title: 'Numero d\'operation',
        field: 'numeroOperation',
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
    List<CaisseModel?> dataList = await CaisseApi().getAllData();
    var data = dataList;

    if (mounted) {
      setState(() {
        for (var item in data) {
          id = item!.id;
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'nomComplet': PlutoCell(value: item.nomComplet),
            'pieceJustificative': PlutoCell(value: item.pieceJustificative),
            'libelle': PlutoCell(value: item.libelle),
            'montant': PlutoCell(
                value: NumberFormat.decimalPattern('fr')
                    .format(double.parse(item.montant))),
            'departement': PlutoCell(value: item.departement),
            'typeOperation': PlutoCell(value: item.typeOperation),
            'numeroOperation': PlutoCell(value: item.numeroOperation),
            'created': PlutoCell(
                value: DateFormat("DD-MM-yy H:mm").format(item.created))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
