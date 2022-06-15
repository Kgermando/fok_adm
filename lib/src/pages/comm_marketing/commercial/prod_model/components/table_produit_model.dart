import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/produit_model_api.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart'; 
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableProduitModel extends StatefulWidget {
  const TableProduitModel({Key? key}) : super(key: key);

  @override
  State<TableProduitModel> createState() => _TableProduitModelState();
}

class _TableProduitModelState extends State<TableProduitModel> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;

  @override
  void initState() {
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
        Navigator.pushNamed(
            context, ComMarketingRoutes.comMarketingProduitModelDetail, arguments: idPlutoRow.value);
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
                  Navigator.pushNamed(
                      context, ComMarketingRoutes.comMarketingProduitModel);
                },
                icon: Icon(Icons.refresh, color: Colors.green.shade700)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
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
            if (column.field == 'idProduct') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'categorie') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'sousCategorie1') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'sousCategorie2') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'sousCategorie3') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'sousCategorie4') {
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
        title: 'Id Produit',
        field: 'idProduct',
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
        title: 'Categorie',
        field: 'categorie',
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
        title: 'Sous Categorie 1',
        field: 'sousCategorie1',
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
        title: 'Sous Categorie 2',
        field: 'sousCategorie2',
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
        title: 'Sous Categorie 3',
        field: 'sousCategorie3',
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
        title: 'Sous Categorie 4',
        field: 'sousCategorie4',
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
        title: 'Date',
        field: 'created',
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
    List<ProductModel> dataList = await ProduitModelApi().getAllData();
    UserModel userModel = await AuthApi().getUserId();
    var approbations = await ApprobationApi().getAllData();
    List<ProductModel?> data = [];
    // Verifie les approbation si c'est la list es vide
    if (approbations.isNotEmpty) {
      List<ApprobationModel> isApproved = [];
      for (var item in dataList) {
        isApproved = approbations
            .where((element) =>
                element.reference.microsecondsSinceEpoch ==
                item.created.microsecondsSinceEpoch)
            .toList();
      }
      // FIltre si le filtre donne des elements
      if (isApproved.isNotEmpty) {
        for (var item in approbations) {
          data = dataList
              .where((element) =>
                  element.created.microsecondsSinceEpoch ==
                          item.reference.microsecondsSinceEpoch &&
                      item.fontctionOccupee == 'Directeur de departement' &&
                      item.approbation == "Approved" ||
                  element.signature == userModel.matricule)
              .toList();
        }
      } else {
        data = dataList
            .where((element) => element.signature == userModel.matricule)
            .toList();
      }
    } else {
      data = dataList
          .where((element) => element.signature == userModel.matricule)
          .toList();
    }

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'idProduct': PlutoCell(value: item.idProduct),
            'categorie': PlutoCell(value: item.categorie),
            'sousCategorie1': PlutoCell(value: item.sousCategorie1),
            'sousCategorie2': PlutoCell(value: item.sousCategorie2),
            'sousCategorie3': PlutoCell(value: item.sousCategorie3),
            'sousCategorie4': PlutoCell(value: item.sousCategorie4),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy HH:mm").format(item.created))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
