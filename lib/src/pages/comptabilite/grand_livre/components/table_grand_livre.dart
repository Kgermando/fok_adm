import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/grand_livre_model.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableGrandLivre extends StatefulWidget {
  const TableGrandLivre({Key? key, required this.grandLivreModel})
      : super(key: key);
  final GrandLivreModel grandLivreModel;

  @override
  State<TableGrandLivre> createState() => _TableGrandLivreState();
}

class _TableGrandLivreState extends State<TableGrandLivre> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;
  Timer? timer;
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    agentsColumn();
    agentsRow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: DrawerMenu(),
              ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(p10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: p20,
                          child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back)),
                        ),
                        const SizedBox(width: p10),
                        Expanded(
                          child: CustomAppbar(
                              title: "Grand livre",
                              controllerMenu: () =>
                                  _key.currentState!.openDrawer()),
                        ),
                      ],
                    ),
                    Expanded(
                      child: PlutoGrid(
                        columns: columns,
                        rows: rows,
                        onRowDoubleTap:
                            (PlutoGridOnRowDoubleTapEvent tapEvent) {
                          final dataId = tapEvent.row!.cells.values;
                          final idPlutoRow = dataId.elementAt(0);

                          Navigator.pushNamed(context,
                              ComptabiliteRoutes.comptabiliteJournalDetail,
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
                              } else if (column.field == 'numeroOperation') {
                                return resolver<ClassFilterImplemented>()
                                    as PlutoFilterType;
                              } else if (column.field == 'libele') {
                                return resolver<ClassFilterImplemented>()
                                    as PlutoFilterType;
                              } else if (column.field == 'compteDebit') {
                                return resolver<ClassFilterImplemented>()
                                    as PlutoFilterType;
                              } else if (column.field == 'montantDebit') {
                                return resolver<ClassFilterImplemented>()
                                    as PlutoFilterType;
                              } else if (column.field == 'compteCredit') {
                                return resolver<ClassFilterImplemented>()
                                    as PlutoFilterType;
                              } else if (column.field == 'montantCredit') {
                                return resolver<ClassFilterImplemented>()
                                    as PlutoFilterType;
                              } else if (column.field == 'remarque') {
                                return resolver<ClassFilterImplemented>()
                                    as PlutoFilterType;
                              } else if (column.field == 'signature') {
                                return resolver<ClassFilterImplemented>()
                                    as PlutoFilterType;
                              } else if (column.field == 'created') {
                                return resolver<ClassFilterImplemented>()
                                    as PlutoFilterType;
                              }
                              return resolver<PlutoFilterTypeContains>()
                                  as PlutoFilterType;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
    List<JournalModel> journals = await JournalApi().getAllData();
    var data = journals.where((element) =>
        element.compteDebit == widget.grandLivreModel.comptedebit ||
        element.compteCredit == widget.grandLivreModel.comptedebit ||
        element.created.millisecondsSinceEpoch >=
                widget.grandLivreModel.dateStart.millisecondsSinceEpoch &&
            element.created.millisecondsSinceEpoch <=
                widget.grandLivreModel.dateEnd.millisecondsSinceEpoch);

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'numeroOperation': PlutoCell(value: item.numeroOperation),
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
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
          }));
          stateManager!.notifyListeners();
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
