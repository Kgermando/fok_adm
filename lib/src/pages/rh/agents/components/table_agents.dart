import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/detail_agent_page.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
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

  int? id;

  @override
  initState() {
    agentsColumn();
    agentsRow();
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
            builder: (context) => AgentPage(id: idPlutoRow.value)));
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
            PrintWidget(onPressed: () {
              // exportToExcel();
            })
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
            } else if (column.field == 'nom') {
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
    // print('agents $data');
    if (mounted) {
      setState(() {
        for (var item in data) {
          id = item!.id;
          // print('item ${item!.id}');
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'nom': PlutoCell(value: item.nom),
            'postNom': PlutoCell(value: item.postNom),
            'prenom': PlutoCell(value: item.prenom),
            'email': PlutoCell(value: item.email),
            'telephone': PlutoCell(value: item.telephone),
            'sexe': PlutoCell(value: item.sexe),
            'role': PlutoCell(value: item.role),
            'matricule': PlutoCell(value: item.matricule),
            'dateNaissance':
                PlutoCell(value: DateFormat("dd-MM-yy").format(item.createdAt)),
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

  // Future<void> exportToExcel() async {
  //   var excel = Excel.createExcel();
  //   Sheet sheetObject = excel['Historique de ravitailement'];
  //   sheetObject.insertRowIterables([
  //     'Date',
  //     'ID Produit',
  //     'Prix d\'achat unitaire',
  //     'Quantité d\'entrer',
  //     'Quantité restante',
  //     'Unité',
  //     'Prix de vente unitaire',
  //     'TVA',
  //     'Succursale',
  //     'Societé'
  //   ], 0);

  //   for (int i = 0; i < historyRavitaillementList.length; i++) {
  //     List<String> dataList = [
  //       DateFormat("dd/MM/yy HH-mm").format(historyRavitaillementList[i].date),
  //       historyRavitaillementList[i].idProduct,
  //       historyRavitaillementList[i].priceAchatUnit,
  //       historyRavitaillementList[i].quantityAchat,
  //       historyRavitaillementList[i].quantity,
  //       historyRavitaillementList[i].unite,
  //       historyRavitaillementList[i].prixVenteUnit,
  //       historyRavitaillementList[i].tva,
  //       historyRavitaillementList[i].succursale,
  //       historyRavitaillementList[i].nameBusiness
  //     ];

  //     sheetObject.insertRowIterables(dataList, i + 1);
  //   }
  //   excel.setDefaultSheet('Historique de ravitailement');
  //   final dir = await getApplicationDocumentsDirectory();
  //   final dateTime = DateTime.now();
  //   final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);

  //   var onValue = excel.encode();
  //   File('${dir.path}/historique_ravitailement$date.xlsx')
  //     ..createSync(recursive: true)
  //     ..writeAsBytesSync(onValue!);

  //   if (!mounted) return;
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: const Text("Exportation effectué!"),
  //     backgroundColor: Colors.green[700],
  //   ));
  // }
}
