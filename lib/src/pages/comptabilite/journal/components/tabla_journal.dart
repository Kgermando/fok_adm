import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/components/detail_journal.dart';
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
    setState(() {
      timer = Timer.periodic(const Duration(milliseconds: 500), ((timer) {
        agentsRow();
        timer.cancel();
      }));
    });

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
            builder: (context) => DetailJournal(id: idPlutoRow.value)));
      },
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager!.notifyListeners();
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
        title: 'Libele',
        field: 'libele',
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
        title: 'Debit',
        field: 'compteDebit',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 250,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Credit',
        field: 'compteCredit',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 250,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'TVA',
        field: 'montantCredit',
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
        title: 'montant',
        field: 'montantDebit',
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
    UserModel userModel = await AuthApi().getUserId();
    List<JournalModel?> dataList = await JournalApi().getAllData();
    var data = dataList.where((element) =>
        element!.approbationDG == "Approved" &&
            element.approbationDD == "Approved" ||
        element.signature == userModel.matricule);

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'libele': PlutoCell(value: item.libele),
            'compteDebit': PlutoCell(value: item.compteDebit),
            'compteCredit': PlutoCell(value: item.compteCredit),
            'montantCredit': PlutoCell(value: "${item.montantCredit} %"), // TVA
            'montantDebit': PlutoCell(
                value:
                    "${NumberFormat.decimalPattern('fr').format(double.parse(item.montantDebit))} \$"), // Montant
            'remarque': PlutoCell(value: item.remarque),
            'signature': PlutoCell(value: item.signature),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy HH:mm").format(item.created))
          }));
          stateManager!.notifyListeners();
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
