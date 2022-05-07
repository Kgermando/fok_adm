import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/detail_agent_page.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableAgentAdmin extends StatefulWidget {
  const TableAgentAdmin({Key? key}) : super(key: key);

  @override
  State<TableAgentAdmin> createState() => _TableAgentAdminState();
}

class _TableAgentAdminState extends State<TableAgentAdmin> {
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: PlutoGrid(
        columns: columns,
        rows: rows,
        onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
          final dataList = tapEvent.row!.cells.values;
          final idPlutoRow = dataList.elementAt(0);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AgentPage(id: idPlutoRow.value)));
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
              ClassFilterImplemented(),
            ],
            resolveDefaultColumnFilter: (column, resolver) {
              if (column.field == 'nom') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'postNom') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'prenom') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'email') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'telephone') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'sexe') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'role') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'matricule') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'dateNaissance') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'departement') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'servicesAffectation') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'statutAgent') {
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
        width: 100,
        minWidth: 80,
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
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
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
        readOnly: true,
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
        readOnly: true,
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
        readOnly: true,
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
        readOnly: true,
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
        readOnly: true,
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
        readOnly: true,
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
        readOnly: true,
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
        readOnly: true,
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
    // var dataList = data.where((element) => element!.statutAgent == false).toList();
    if (mounted) {
      setState(() {
        for (var item in data) {
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
            'dateNaissance': PlutoCell(
                value: DateFormat("dd-MM-yy HH:mm").format(item.createdAt)),
            'departement': PlutoCell(value: item.departement),
            'servicesAffectation': PlutoCell(value: item.servicesAffectation),
            'statutAgent': PlutoCell(
                value: (item.statutAgent)
                    ? Text('Actif',
                        style: TextStyle(color: Colors.green.shade700))
                    : Text('Inactif',
                        style: TextStyle(color: Colors.red.shade700)))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
