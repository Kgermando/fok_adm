import 'package:flutter/material.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableCreanceCart extends StatefulWidget {
  const TableCreanceCart({Key? key, required this.factureList}) : super(key: key);
  final List<dynamic> factureList;

  @override
  State<TableCreanceCart> createState() => _TableCreanceCartState();
}

class _TableCreanceCartState extends State<TableCreanceCart> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  initState() {
    agentsColumn();
    agentsRow(); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager!.setShowColumnFilter(true);
            stateManager!.notifyListeners();
          },
          configuration: PlutoGridConfiguration(
            columnFilterConfig: PlutoGridColumnFilterConfig(
              filters: const [
                ...FilterHelper.defaultFilters,
                // custom filter
                ClassFilterImplemented(),
              ],
              resolveDefaultColumnFilter: (column, resolver) {
                if (column.field == 'quantityCart') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'idProductCart') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'priceAchatUnit') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'priceCart') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'tva') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                } else if (column.field == 'total') {
                  return resolver<ClassFilterImplemented>() as PlutoFilterType;
                }
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              },
            ),
          ),
        ));
  }


  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'Quantités',
        field: 'quantityCart',
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
        title: 'Designation',
        field: 'idProductCart',
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
        title: 'Prix d\'achat unitaire',
        field: 'priceAchatUnit',
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
        title: 'Prix de Vente ou Remise',
        field: 'priceCart',
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
        title: 'TVA',
        field: 'tva',
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
        title: 'Total',
        field: 'total',
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
    // List<dynamic> cartItem = facture!.cart.toList();
    // final cartItem = jsonDecode(facture!.cart) as List;

    List<CartModel> cartItemList = [];

    for (var element in widget.factureList) {
      cartItemList.add(CartModel.fromJson(element));
    }


    if (mounted) {
      setState(() {
        for (var item in cartItemList) {
          double total = 0;

          var qtyRemise = double.parse(item.qtyRemise);
          var quantity = double.parse(item.quantityCart);
          if (quantity >= qtyRemise) {
            total +=
                double.parse(item.remise) * double.parse(item.quantityCart);
          } else {
            total +=
                double.parse(item.priceCart) * double.parse(item.quantityCart);
          }

          rows.add(PlutoRow(cells: {
            'quantityCart': PlutoCell(
                value:
                    '${NumberFormat.decimalPattern('fr').format(double.parse(item.quantityCart))} ${item.unite}'),
            'idProductCart': PlutoCell(value: item.idProductCart),
            'priceAchatUnit': PlutoCell(value: item.priceAchatUnit),
            'priceCart': PlutoCell(
                value: (double.parse(item.quantityCart) >=
                        double.parse(item.qtyRemise))
                    ? "${NumberFormat.decimalPattern('fr').format(double.parse(item.remise))} \$"
                    : "${NumberFormat.decimalPattern('fr').format(double.parse(item.priceCart))} \$"),
            'tva': PlutoCell(value: "${item.tva} %"),
            'total': PlutoCell(
                value: "${NumberFormat.decimalPattern('fr').format(total)} \$")
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}