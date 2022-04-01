import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
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

  List<UserModel?> listData = [];

  @override
  initState() {
    agentsColumn();
    agentsRow();
    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    print('agents $data');
    if (mounted) {
      setState(() {
        for (var item in data) {
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
        }
        stateManager!.resetCurrentState();
      });
    }
  }

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
