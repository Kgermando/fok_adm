import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/facture_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/helpers/pdf_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/facture_cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/components/table_facture_cart.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/pdf/facture_cart_pdf.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DetailFacture extends StatefulWidget {
  const DetailFacture({Key? key}) : super(key: key);

  @override
  State<DetailFacture> createState() => _DetailFactureState();
}

class _DetailFactureState extends State<DetailFacture> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  initState() { 
    getData();
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
                  child: FutureBuilder<FactureCartModel>(
                      future: FactureApi().getOneData(id),
                      builder: (BuildContext context,
                          AsyncSnapshot<FactureCartModel> snapshot) {
                        if (snapshot.hasData) {
                          FactureCartModel? data = snapshot.data;
                          factureList = jsonDecode(data!.cart) as List;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: p20,
                                    child: IconButton(
                                        onPressed: () => Navigator.pop(context),
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
                                  child: SingleChildScrollView(
                                      child: Column(
                                children: [
                                  pageDetail(data),
                                  const SizedBox(height: p20),
                                  totalCart(data)
                                ],
                              )))
                            ],
                          );
                        } else {
                          return Center(child: loading());
                        }
                      })),
            ),
          ],
        ),
      ),
    );
  }

  Widget pageDetail(FactureCartModel data) {
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
          child: Column(
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
                                    await FactureCartPDF.generate(data, "\$");
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
              TableFactureCart(factureList: factureList)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(FactureCartModel data) {
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

  Widget totalCart(FactureCartModel data) {
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
 


}
