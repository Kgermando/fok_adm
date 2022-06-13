import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart'; 
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/creance_dette_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
import 'package:fokad_admin/src/models/finances/creance_dette_model.dart';
import 'package:fokad_admin/src/models/finances/dette_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableDette extends StatefulWidget {
  const TableDette({Key? key}) : super(key: key);

  @override
  State<TableDette> createState() => _TableDetteState();
}

class _TableDetteState extends State<TableDette> {
  Timer? timer;
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;
  double paye = 0.0;
  double nonPaye = 0.0;

  @override
  initState() {
    agentsColumn();
    getData();
    agentsRow();

    super.initState();
  }


  List<CreanceDetteModel> creanceDetteList = [];
  Future<void> getData() async {
    List<DetteModel?> dataList = await DetteApi().getAllData();
    var creanceDette = await CreanceDetteApi().getAllData();
    setState(() {
      List<DetteModel?> data = dataList.toList();
      creanceDetteList = creanceDette
        .where((element) => element.creanceDette == 'dettes').toList();
      for (var item in data) {
        nonPaye += double.parse(item!.montant);
      }

      for (var item in creanceDetteList) {
        paye += double.parse(item.montant);
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
              Navigator.pushNamed(
                  context, FinanceRoutes.transactionsDetteDetail,
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
                        Navigator.pushNamed(
                            context, FinanceRoutes.transactionsDettes);
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
                  } else if (column.field == 'ligneBudgtaire') {
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
                SelectableText('Total: ',
                    style: bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(nonPaye)} \$',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white))
              ],
            ),
            Row(
              children: [
                SelectableText('Payé: ',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(paye)} \$',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white))
              ],
            ),
            Row(
              children: [
                SelectableText('Non Payé: ',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(nonPaye - paye)} \$',
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
        width: 200,
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
        width: 200,
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
        width: 300,
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
        width: 200,
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
    List<DetteModel?> dataList = await DetteApi().getAllData();
    UserModel userModel = await AuthApi().getUserId();
    var approbations = await ApprobationApi().getAllData();
    List<DetteModel?> data = [];
    // Verifie les approbation si c'est la list es vide
    if (approbations.isNotEmpty) {
      List<ApprobationModel> isApproved = [];
      for (var item in dataList) {
        isApproved = approbations
            .where((element) =>
                element.reference.microsecondsSinceEpoch ==
                item!.createdRef.microsecondsSinceEpoch)
            .toList();
      }
      // FIltre si le filtre donne des elements
      if (isApproved.isNotEmpty) {
        for (var item in approbations) {
          data = dataList
              .where((element) =>
                  element!.createdRef.microsecondsSinceEpoch ==
                          item.reference.microsecondsSinceEpoch &&
                      item.fontctionOccupee == 'Directeur générale' &&
                      item.approbation == "Approved" ||
                  element.signature == userModel.matricule)
              .toList();
        }
      } else {
        data = dataList
            .where((element) => element!.signature == userModel.matricule)
            .toList();
      }
    } else {
      data = dataList
          .where((element) => element!.signature == userModel.matricule)
          .toList();
    }

    if (mounted) {
      setState(() {
        for (var item in data) {
          id = item!.id;
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'nomComplet': PlutoCell(value: item.nomComplet),
            'pieceJustificative': PlutoCell(value: item.pieceJustificative),
            'libelle': PlutoCell(value: item.libelle),
            'montant': PlutoCell(value: "${NumberFormat.decimalPattern('fr')
                .format(double.parse(item.montant))} \$"),
            'numeroOperation': PlutoCell(value: item.numeroOperation),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
