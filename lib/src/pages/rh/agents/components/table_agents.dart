import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
<<<<<<< HEAD
import 'package:fokad_admin/src/widgets/print_widget.dart';
=======
import 'package:fokad_admin/src/models/users/user_model.dart';
>>>>>>> parent of 80eb0c4 (add logout done)
import 'package:pluto_grid/pluto_grid.dart';

class TableAgents extends StatefulWidget {
  const TableAgents({Key? key}) : super(key: key);

  @override
  State<TableAgents> createState() => _TableAgentsState();
}

class _TableAgentsState extends State<TableAgents> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  initState() {
    agentsColumn();
    agentsRow();
<<<<<<< HEAD
=======
    
>>>>>>> parent of 80eb0c4 (add logout done)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      
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
            if (column.field == 'nom') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'postNom') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'prenom') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'email') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'telephone') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'sexe') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'role') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'matricule') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'dateNaissance') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'departement') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'servicesAffectation') {
              return resolver<ClassYouImplemented>() as PlutoFilterType;
            } else if (column.field == 'statutAgent') {
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
        title: 'Nom',
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
        title: 'Post-Nom',
        field: 'postNom',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        title: 'Prénom',
        field: 'prenom',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        title: 'Email',
        field: 'email',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        title: 'telephone',
        field: 'telephone',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        title: 'sexe',
        field: 'sexe',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        title: 'Acréditation',
        field: 'role',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        title: 'Matricule',
        field: 'matricule',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        title: 'Date de naissance',
        field: 'dateNaissance',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        title: 'Département',
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
        title: 'Services d\'affectation',
        field: 'servicesAffectation',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        title: 'Statut Agent',
        field: 'statutAgent',
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
    List<AgentModel?> data = await AgentsApi().getAllData();
    // print('agents $data');
    if (mounted) {
      setState(() {
        for (var item in data) {
<<<<<<< HEAD
          // print('item ${item!.id}');
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'nom': PlutoCell(value: item.nom),
            'postNom': PlutoCell(value: item.postNom),
            'prenom': PlutoCell(value: item.prenom),
            'email': PlutoCell(value: item.email),
            'telephone': PlutoCell(value: item.telephone),
            'sexe': PlutoCell(value: item.sexe),
            'role': PlutoCell(value: item.role),
            'matricule': PlutoCell(value: item.matricule),
            'dateNaissance': PlutoCell(value: item.dateNaissance),
            'departement': PlutoCell(value: item.departement),
            'servicesAffectation': PlutoCell(value: item.servicesAffectation),
            'statutAgent':
                PlutoCell(value: (item.statutAgent) ? 'Actif' : 'Inactif')
          }));
=======
          print('item ${item!.id}');
          rows.add(
            PlutoRow(
              cells: {
                'id': PlutoCell(value: item.id),
                'nom': PlutoCell(value: item.nom),
                'postNom': PlutoCell(value: item.postNom),
                'prenom': PlutoCell(value: item.prenom),
                'email': PlutoCell(value: item.email),
                'telephone': PlutoCell(value: item.telephone),
                'sexe': PlutoCell(value: item.sexe),
                'role': PlutoCell(value: item.role),
                'matricule': PlutoCell(value: item.matricule),
                'dateNaissance': PlutoCell(value: item.dateNaissance),
                'departement': PlutoCell(value: item.departement),
                'servicesAffectation': PlutoCell(value: item.servicesAffectation),
                'statutAgent': PlutoCell(value: item.statutAgent)
              }
            )
          );
>>>>>>> parent of 80eb0c4 (add logout done)
        }
        stateManager!.resetCurrentState();
      });
    }
  }
<<<<<<< HEAD
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
=======

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns, rows: rows,
      // onChanged: (PlutoGridOnChangedEvent event) {
      //   setState(() {});
      //   print(event);
      //   PlutoRow tr = rows[event.rowIdx!];
      //   for (var f in tr.cells.values) {
      //     print(f.value);
      //   }
      //   PlutoCell? tc = tr.cells['id'];
      //   print(tc!.value);
      // },
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        // stateManager.setSelectingMode(gridSelectingMode);
      },
    );
  }
}
>>>>>>> parent of 80eb0c4 (add logout done)
