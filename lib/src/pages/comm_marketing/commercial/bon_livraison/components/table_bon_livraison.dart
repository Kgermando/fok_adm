import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/bon_livraison_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/bon_livraison.dart';
import 'package:fokad_admin/src/routes/routes.dart'; 
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableBonLivraison extends StatefulWidget {
  const TableBonLivraison({Key? key}) : super(key: key);

  @override
  State<TableBonLivraison> createState() => _TableBonLivraisonState();
}

class _TableBonLivraisonState extends State<TableBonLivraison> {
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
        // final dataId = tapEvent.row!.cells.values;
        // final idPlutoRow = dataId.elementAt(0);

        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => DetailBonLivraison(id: idPlutoRow.value)));
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
            const TitleWidget(title: "Bon de Livraisons"),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, ComMarketingRoutes.comMarketingBonLivraison);
                },
                icon: Icon(Icons.refresh, color: Colors.green.shade700)),
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
            } else if (column.field == 'idProduct') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'quantityAchat') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'priceAchatUnit') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'prixVenteUnit') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'unite') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'tva') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'remise') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'qtyRemise') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'accuseReception') {
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
        title: 'Quantit?? d\'Achat',
        field: 'quantityAchat',
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
        title: 'Price d\'AchatUnit',
        field: 'priceAchatUnit',
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
        title: 'Prix Vente Unitaire',
        field: 'prixVenteUnit',
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
        title: 'TVA',
        field: 'tva',
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
        title: 'Remise',
        field: 'remise',
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
        title: 'Qty Remise',
        field: 'qtyRemise',
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
        title: 'Accuse Reception',
        field: 'accuseReception',
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
    List<BonLivraisonModel> dataList = await BonLivraisonApi().getAllData();
    var data = dataList;

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'idProduct': PlutoCell(value: item.idProduct),
            'quantityAchat':
                PlutoCell(value: "${item.quantityAchat} ${item.unite}"),
            'priceAchatUnit': PlutoCell(
                value:
                    '${NumberFormat.decimalPattern('fr').format(double.parse(item.priceAchatUnit))} \$'),
            'prixVenteUnit': PlutoCell(
                value:
                    '${NumberFormat.decimalPattern('fr').format(double.parse(item.prixVenteUnit))} \$'),
            'tva': PlutoCell(value: "${item.tva} %"),
            'remise': PlutoCell(value: item.remise),
            'qtyRemise': PlutoCell(value: item.qtyRemise),
            'accuseReception': PlutoCell(value: item.accuseReception),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy H:mm").format(item.created))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
