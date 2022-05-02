import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/pages/budgets/components/detail_ligne_budgetaire.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class LigneBudgetaireAdmin extends StatefulWidget {
  const LigneBudgetaireAdmin({Key? key}) : super(key: key);

  @override
  State<LigneBudgetaireAdmin> createState() => _LigneBudgetaireAdminState();
}

class _LigneBudgetaireAdminState extends State<LigneBudgetaireAdmin> {
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
              builder: (context) =>
                  DetailLigneBudgetaire(id: idPlutoRow.value)));
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
              if (column.field == 'nomLigneBudgetaire') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'departement') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'periodeBudget') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'uniteChoisie') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'nombreUnite') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'coutUnitaire') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'coutTotal') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'caisse') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'banque') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'finPropre') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'finExterieur') {
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
        width: 100,
        minWidth: 80,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'nomLigneBudgetaire',
        field: 'nomLigneBudgetaire',
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
        title: 'periodeBudget',
        field: 'periodeBudget',
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
        title: 'uniteChoisie',
        field: 'uniteChoisie',
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
        title: 'nombreUnite',
        field: 'nombreUnite',
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
        title: 'coutUnitaire',
        field: 'coutUnitaire',
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
        title: 'coutTotal',
        field: 'coutTotal',
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
        title: 'caisse',
        field: 'caisse',
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
        title: 'banque',
        field: 'banque',
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
        title: 'finPropre',
        field: 'finPropre',
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
        title: 'finExterieur',
        field: 'finExterieur',
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
        title: 'created',
        field: 'created',
        type: PlutoColumnType.date(),
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
    List<LigneBudgetaireModel?> dataList =
        await LIgneBudgetaireApi().getAllData();
    var data = dataList
        .where((element) =>
            element!.approbationDD == "Approved" &&
            element.approbationBudget == "Approved")
        .toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          id = item!.id;
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'nomLigneBudgetaire': PlutoCell(value: item.nomLigneBudgetaire),
            'departement': PlutoCell(value: item.departement),
            'periodeBudget': PlutoCell(value: item.periodeBudget),
            'uniteChoisie': PlutoCell(value: item.uniteChoisie),
            'nombreUnite': PlutoCell(value: item.nombreUnite),
            'coutUnitaire': PlutoCell(value: item.coutUnitaire),
            'coutTotal': PlutoCell(value: item.coutTotal),
            'caisse': PlutoCell(value: item.caisse),
            'banque': PlutoCell(value: item.banque),
            'finPropre': PlutoCell(value: item.finPropre),
            'finExterieur': PlutoCell(value: item.finExterieur),
            'createdAt': PlutoCell(
                value: DateFormat("DD-MM-yy HH:mm").format(item.created))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}

