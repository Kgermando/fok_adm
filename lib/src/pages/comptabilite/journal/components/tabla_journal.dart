import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart'; 
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableJournal extends StatefulWidget {
  const TableJournal({Key? key}) : super(key: key);

  @override
  State<TableJournal> createState() => _TableJournalState();
}

class _TableJournalState extends State<TableJournal> {
  Timer? timer;
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
      height: MediaQuery.of(context).size.height / 2,
      child: PlutoGrid(
        columns: columns,
        rows: rows,
        onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
          final dataList = tapEvent.row!.cells.values;
          final idPlutoRow = dataList.elementAt(0);

           Navigator.pushNamed(context, ComptabiliteRoutes.comptabiliteJournalDetail,
              arguments: idPlutoRow.value); 
        },
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager!.notifyListeners();
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
                        context, ComptabiliteRoutes.comptabiliteJournal);
                  },
                  icon: Icon(Icons.refresh, color: Colors.green.shade700)),
              PrintWidget(onPressed: () {})],
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
              } else if (column.field == 'numeroOperation') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'libele') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'compteDebit') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'montantDebit') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'compteCredit') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'montantCredit') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'tva') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'remarque') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'signature') {
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
        width: 50,
        minWidth: 50,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Numero Operation',
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
        title: 'Libele',
        field: 'libele',
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
        title: 'Compte Debit',
        field: 'compteDebit',
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
        title: 'Montant Debit',
        field: 'montantDebit',
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
        title: 'Compte Credit',
        field: 'compteCredit',
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
        title: 'Montant Credit',
        field: 'montantCredit',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 100,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'TVA',
        field: 'tva',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 100,
        minWidth: 100,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'remarque',
        field: 'remarque',
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
        title: 'Signature',
        field: 'signature',
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
    List<JournalModel?> dataList = await JournalApi().getAllData();
     UserModel userModel = await AuthApi().getUserId();
    var approbations = await ApprobationApi().getAllData();
    List<JournalModel?> data = [];
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
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'numeroOperation': PlutoCell(value: item.numeroOperation),
            'libele': PlutoCell(value: item.libele),
            'compteDebit': PlutoCell(value: item.compteDebit),
            'montantDebit': PlutoCell(
                value:
                    "${NumberFormat.decimalPattern('fr').format(double.parse(item.montantDebit))} \$"),
            'compteCredit': PlutoCell(value: item.compteCredit),
            'montantCredit': PlutoCell(
                value:
                    "${NumberFormat.decimalPattern('fr').format(double.parse(item.montantCredit))} \$"),
            'tva': PlutoCell(value: "${item.tva} %"),
            'remarque': PlutoCell(value: item.remarque),
            'signature': PlutoCell(value: item.signature),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
          }));
          stateManager!.notifyListeners();
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
