import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
 

class TableSalaireFin extends StatefulWidget {
  const TableSalaireFin({Key? key}) : super(key: key);

  @override
  State<TableSalaireFin> createState() => _TableSalaireFinState();
}

class _TableSalaireFinState extends State<TableSalaireFin> {
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

        Navigator.pushNamed(context, RhRoutes.rhPaiementBulletin,
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
                  Navigator.pushNamed(context, RhRoutes.rhPaiement);
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
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'prenom') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'nom') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'matricule') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'departement') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'approbation') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'modePaiement') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'salaire') {
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
        width: 100,
        minWidth: 80,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Prénom',
        field: 'prenom',
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
        title: 'Nom',
        field: 'nom',
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
        title: 'Matricule',
        field: 'matricule',
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
        title: 'departement',
        field: 'departement',
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
        title: 'Salaire',
        field: 'salaire',
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
        title: 'Mode de paiement',
        field: 'modePaiement',
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
        field: 'createdAt',
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
    List<PaiementSalaireModel?> dataList =
        await PaiementSalaireApi().getAllData();
    List<PaiementSalaireModel?> data = [];
    var approbations = await ApprobationApi().getAllData();
    for (var item in approbations) {
      data = dataList
          .where((element) =>
              element!.createdAt.microsecondsSinceEpoch == item.reference.microsecondsSinceEpoch &&
                  item.fontctionOccupee == 'Directeur de budget' &&
                  item.approbation == "Approved")
          .toList();
    } 

    if (mounted) {
      setState(() {
        for (var item in data) {
          id = item!.id;
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'prenom': PlutoCell(value: item.prenom),
            'nom': PlutoCell(value: item.nom),
            'matricule': PlutoCell(value: item.matricule),
            'departement': PlutoCell(value: item.departement),
            'salaire': PlutoCell(value: item.salaire),
            'modePaiement': PlutoCell(value: item.modePaiement),
            'createdAt':
                PlutoCell(value: DateFormat("dd-MM-yyyy").format(item.createdAt))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
