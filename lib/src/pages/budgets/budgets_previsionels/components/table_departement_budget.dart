import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableDepartementBudget extends StatefulWidget {
  const TableDepartementBudget({Key? key}) : super(key: key);

  @override
  State<TableDepartementBudget> createState() => _TableDepartementBudgetState();
}

class _TableDepartementBudgetState extends State<TableDepartementBudget> {
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

        Navigator.pushNamed(context, BudgetRoutes.budgetBudgetPrevisionelDetail,
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
                  Navigator.pushNamed(context, BudgetRoutes.budgetBudgetPrevisionel);
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
            }
            if (column.field == 'departement') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'periodeBudget') {
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
        title: 'Titre',
        field: 'title',
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
        title: 'Département',
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
        title: 'Periode Budget',
        field: 'periodeBudget',
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
        title: 'Date',
        field: 'created',
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
    UserModel userModel = await AuthApi().getUserId();
    var approbations = await ApprobationApi().getAllData();
    List<DepartementBudgetModel?> dataList =
        await DepeartementBudgetApi().getAllData();
    List<DepartementBudgetModel?> data = [];

    for (var item in approbations) {
      var isApproved = dataList
          .where((element) => 
                  element!.created.microsecondsSinceEpoch ==
                      item.reference.microsecondsSinceEpoch)
          .toList();
      if (isApproved.isNotEmpty) {
        data = dataList
        .where((element) =>
            DateTime.now().millisecondsSinceEpoch <=
                    element!.periodeFin.millisecondsSinceEpoch &&
                element.created.microsecondsSinceEpoch == item.reference.microsecondsSinceEpoch &&
                item.fontctionOccupee == 'Directeur générale' &&
                item.approbation == "Approved" ||
            element.signature == userModel.matricule ||
            element.isSubmit == false)
        .toList();
      } else {
        data = dataList
            .where((element) =>
                DateTime.now().millisecondsSinceEpoch <=
                        element!.periodeFin.millisecondsSinceEpoch &&
                element.signature == userModel.matricule ||
                element.isSubmit == false)
            .toList();
      }
      
    }

    

    if (mounted) {
      setState(() {
        for (var item in dataList) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'title': PlutoCell(value: item.title),
            'departement': PlutoCell(value: item.departement),
            'periodeBudget': PlutoCell(
                value:
                    "${DateFormat("dd-MM-yyyy").format(item.periodeDebut)} - ${DateFormat("dd-MM-yyyy").format(item.periodeFin)}"),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
