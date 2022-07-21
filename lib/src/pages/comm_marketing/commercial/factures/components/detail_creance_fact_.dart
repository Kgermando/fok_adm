import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/creance_facture_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/helpers/pdf_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/creance_cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/pdf/creance_cart_pdf.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DetailCreanceFact extends StatefulWidget {
  const DetailCreanceFact({Key? key}) : super(key: key);

  @override
  State<DetailCreanceFact> createState() => _DetailCreanceFactState();
}

class _DetailCreanceFactState extends State<DetailCreanceFact> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    getData();
    agentsColumn();
    agentsRow();
    super.initState();
  }

   List<dynamic> factureList = [];

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: 'false',
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context)!.settings.arguments as int;
    
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
                    child: FutureBuilder<CreanceCartModel>(
                        future: CreanceFactureApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<CreanceCartModel> snapshot) {
                          if (snapshot.hasData) {
                            CreanceCartModel? data = snapshot.data;
                            factureList = jsonDecode(data!.cart) as List;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: p20,
                                      child: IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: data.client,
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: Scrollbar(
                                        controller: _controllerScroll,
                                        child: pageDetail(data)))
                              ],
                            );
                          } else {
                            return Center(
                                child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(CreanceCartModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: ListView(
            controller: _controllerScroll,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: 'Facture n° ${data.client}'),
                  Column(
                    children: [
                      Row(
                        children: [
                          PrintWidget(
                              tooltip: 'Imprimer le document',
                              onPressed: () async {
                                final pdfFile =
                                    await CreanceCartPDF.generate(data, "\$");
                                PdfApi.openFile(pdfFile);
                              })
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              listCart()
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(CreanceCartModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }

Widget totalCart(CreanceCartModel data) {
    List<dynamic> cartItem;
    // cartItem = facture!.cart.toList();
    cartItem = jsonDecode(data.cart) as List;

    List<CartModel> cartItemList = [];

    for (var element in cartItem) {
      cartItemList.add(CartModel.fromJson(element));
    }

    double sumCart = 0;
    for (var data in cartItemList) {
      var qtyRemise = double.parse(data.qtyRemise);
      var quantity = double.parse(data.quantityCart);
      if (quantity >= qtyRemise) {
        sumCart += double.parse(data.remise) * double.parse(data.quantityCart);
      } else {
        sumCart +=
            double.parse(data.priceCart) * double.parse(data.quantityCart);
      }
    }
    return Card(
      elevation: 5,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(p20),
        // color: const Color(0xFFE8F5E9),
        child: Text(
          'Total: ${NumberFormat.decimalPattern('fr').format(sumCart)} \$',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  listCart() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
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

    for (var element in factureList) {
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
