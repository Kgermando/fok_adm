import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableSalairesHistorique extends StatefulWidget {
  const TableSalairesHistorique({Key? key}) : super(key: key);

  @override
  State<TableSalairesHistorique> createState() => _TableSalairesHistoriqueState();
}

class _TableSalairesHistoriqueState extends State<TableSalairesHistorique> {
   final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;

  @override
  initState() {
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
                          width: 20.0,
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.arrow_back)),
                        ),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(
                            flex: 5,
                            child: CustomAppbar(
                                title: 'Etat de besoin',
                                controllerMenu: () =>
                                    _key.currentState!.openDrawer())),
                      ],
                    ),
                    Expanded(
                      child: PlutoGrid(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitleWidget(title: "Historique salaire"),
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
                              } else if (column.field == 'prenom') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'nom') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'matricule') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'departement') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'observation') {
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
        title: 'Observation',
        field: 'observation',
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
        type: PlutoColumnType.date(),
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

    var data = dataList
        .where((element) =>
            element!.createdAt.month < DateTime.now().month && 
            element.createdAt.year < DateTime.now().year)
        .toList();


    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'prenom': PlutoCell(value: item.prenom),
            'nom': PlutoCell(value: item.nom),
            'matricule': PlutoCell(value: item.matricule),
            'departement': PlutoCell(value: item.departement),
            'observation': PlutoCell(
                value: (item.observation == true) ? "Payé" : "Non payé"),
            'modePaiement': PlutoCell(value: item.modePaiement),
            'createdAt': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.createdAt))
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}