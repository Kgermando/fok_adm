import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/cart_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/creance_facture_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/facture_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/gain_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/number_facture_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/vente_cart_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/creance_cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/facture_cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/gain_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/number_facture.dart';
import 'package:fokad_admin/src/models/comm_maketing/vente_cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/cart/components/cart_item_widget.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isloading = false;

  // For cloud to send local
  List<CartModel> listDataCart = [];
  List<CartModel> panierBtnList = [];
  int numberFacture = 0;

  @override
  initState() {
    getData();
    super.initState();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    List<CartModel>? dataList = await CartApi().getAllData();
    final numberFac = await NumberFactureApi().getAllData();
    if (!mounted) return;
    setState(() {
      user = userModel;
      listDataCart = dataList;
      panierBtnList =
          dataList; // Pour verrouiller le button d'achat si le panier est vide
      numberFacture = numberFac.length + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: (panierBtnList.isNotEmpty)
            ? speedialWidget()
            : IconButton(
                onPressed: () {},
                icon: const Icon(Icons.do_not_disturb_alt_rounded),
                color: themeColor,
              ),
        bottomNavigationBar: isloading ? loading() : totalCart(),
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
                    child: FutureBuilder<List<CartModel>>(
                        future: CartApi().getAllData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<CartModel>> snapshot) {
                          if (snapshot.hasData) {
                            List<CartModel>? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: p20,
                                      child: IconButton(
                                          onPressed: () =>
                                              Routemaster.of(context).pop(),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: 'Panier',
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: data!.isEmpty
                                        ? Center(
                                            child: Text(
                                              'Le panier est vide.',
                                              style:
                                                  Responsive.isDesktop(context)
                                                      ? const TextStyle(
                                                          fontSize: 24)
                                                      : const TextStyle(
                                                          fontSize: 16),
                                            ),
                                          )
                                        : Scrollbar(
                                            controller: _controllerScroll,
                                            isAlwaysShown: true,
                                            child: ListView.builder(
                                                controller: _controllerScroll,
                                                itemCount: data.length,
                                                itemBuilder: (context, index) {
                                                  final cart = data[index];
                                                  return CartItemWidget(
                                                      cart: cart);
                                                }),
                                          ))
                              ],
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget totalCart() {
    // Montant a Vendre
    double sumCart = 0.0;

    var dataPriceCart = listDataCart
        .map((e) => (double.parse(e.quantityCart) >= double.parse(e.qtyRemise))
            ? double.parse(e.remise) * double.parse(e.quantityCart)
            : double.parse(e.priceCart) * double.parse(e.quantityCart))
        .toList();

    for (var data in dataPriceCart) {
      sumCart += data;
    }

    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        'Total: ${NumberFormat.decimalPattern('fr').format(sumCart)} \$',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  SpeedDial speedialWidget() {
    return SpeedDial(
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
            child: const Icon(Icons.inventory_rounded),
            label: 'Facture',
            onPressed: factureData),
        SpeedDialChild(
            child: const Icon(Icons.print),
            label: 'Impression facture',
            onPressed: () {
              if (isloading) return;
              _createFacturePDF();
              factureData();
            }),
        SpeedDialChild(
            child: const Icon(Icons.money_off),
            label: 'Vente à crédit',
            onPressed: () {
              if (isloading) return;
              creanceData();
            }),
        SpeedDialChild(
            child: const Icon(Icons.print),
            label: 'Impression facture à crédit',
            onPressed: () {
              if (isloading) return;
              creanceData();
              _createPDFCreance();
            }),
      ],
    );
  }

  Future factureData() async {
    final jsonList = listDataCart.map((item) => jsonEncode(item)).toList();
    final factureCartModel = FactureCartModel(
        cart: jsonList,
        client: '$numberFacture',
        approbationDG: '-',
        signatureDG: '-',
        signatureJustificationDG: '-',
        approbationFin: '-',
        signatureFin: '-',
        signatureJustificationFin: '-',
        approbationBudget: '-',
        signatureBudget: '-',
        signatureJustificationBudget: '-',
        approbationDD: '-',
        signatureDD: '-',
        signatureJustificationDD: '-',
        succursale: user!.succursale.toString(),
        signature: user!.matricule.toString(),
        created: DateTime.now());
    await FactureApi().insertData(factureCartModel);

    // Genere le numero de la facture
    numberFactureField(numberFacture.toString(), user!.succursale.toString(),
        user!.matricule.toString());
    // Ajout des items dans historique
    venteHisotory();
    // Add Gain par produit
    gainVentes();
    // Suppressions total de la table cart
    cleanCart();

    Routemaster.of(context).pop();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Facture $numberFacture ajouté."),
      backgroundColor: Colors.green[700],
    ));
  }

  // PDF Generate Facture
  Future _createFacturePDF() async {
    final jsonList = listDataCart.map((item) => jsonEncode(item)).toList();
    final factureCartModel = FactureCartModel(
        cart: jsonList,
        client: '$numberFacture',
        approbationDG: '-',
        signatureDG: '-',
        signatureJustificationDG: '-',
        approbationFin: '-',
        signatureFin: '-',
        signatureJustificationFin: '-',
        approbationBudget: '-',
        signatureBudget: '-',
        signatureJustificationBudget: '-',
        approbationDD: '-',
        signatureDD: '-',
        signatureJustificationDD: '-',
        succursale: user!.succursale.toString(),
        signature: user!.matricule.toString(),
        created: DateTime.now());

    List<FactureCartModel> factureList = [];
    factureList.add(factureCartModel);

    // ignore: unused_local_variable
    FactureCartModel? facture;

    for (var item in factureList) {
      facture = item;
    }
    // final pdfFile = await FactureCartPDF.generate(facture!, '\$');
    // PdfApi.openFile(pdfFile);
  }

  Future creanceData() async {
    final jsonList = listDataCart.map((item) => jsonEncode(item)).toList();
    final creanceCartModel = CreanceCartModel(
        cart: jsonList,
        client: '$numberFacture',
        approbationDG: '-',
        signatureDG: '-',
        signatureJustificationDG: '-',
        approbationFin: '-',
        signatureFin: '-',
        signatureJustificationFin: '-',
        approbationBudget: '-',
        signatureBudget: '-',
        signatureJustificationBudget: '-',
        approbationDD: '-',
        signatureDD: '-',
        signatureJustificationDD: '-',
        succursale: user!.succursale.toString(),
        signature: user!.matricule.toString(),
        created: DateTime.now());
    await CreanceFactureApi().insertData(creanceCartModel);
    // Genere le numero de la facture
    numberFactureField(numberFacture.toString(), user!.succursale.toString(),
        user!.matricule.toString());
    // Ajout des items dans historique
    venteHisotory();
    // Add Gain par par produit
    gainVentes();
    // suppressions total de la table cart
    cleanCart();
    Routemaster.of(context).pop();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Créance $numberFacture ajouté."),
      backgroundColor: Colors.green[700],
    ));
  }

  // PDF Generate Creance
  Future<void> _createPDFCreance() async {
    final jsonList = listDataCart.map((item) => jsonEncode(item)).toList();
    final creanceCartModel = CreanceCartModel(
        cart: jsonList,
        client: '$numberFacture',
        approbationDG: '-',
        signatureDG: '-',
        signatureJustificationDG: '-',
        approbationFin: '-',
        signatureFin: '-',
        signatureJustificationFin: '-',
        approbationBudget: '-',
        signatureBudget: '-',
        signatureJustificationBudget: '-',
        approbationDD: '-',
        signatureDD: '-',
        signatureJustificationDD: '-',
        succursale: user!.succursale.toString(),
        signature: user!.matricule.toString(),
        created: DateTime.now());

    List<CreanceCartModel> creanceList = [];
    creanceList.add(creanceCartModel);

    // ignore: unused_local_variable
    CreanceCartModel? creance;

    for (var item in creanceList) {
      creance = item;
    }

    // final pdfFile = await CreanceCartPDF.generate(creance!, '\$');
    // PdfApi.openFile(pdfFile);

    // PdfApi.openFile(pdfFile);
  }

  cleanCart() async {
    await CartApi().deleteAllData();
  }

  numberFactureField(String number, String succursale, String signature) async {
    final numberFactureModel = NumberFactureModel(
        number: number,
        approbationDG: '-',
        signatureDG: '-',
        signatureJustificationDG: '-',
        approbationFin: '-',
        signatureFin: '-',
        signatureJustificationFin: '-',
        approbationBudget: '-',
        signatureBudget: '-',
        signatureJustificationBudget: '-',
        approbationDD: '-',
        signatureDD: '-',
        signatureJustificationDD: '-',
        succursale: succursale,
        signature: signature,
        created: DateTime.now());
    await NumberFactureApi().insertData(numberFactureModel);
  }

  venteHisotory() async {
    for (var item in listDataCart) {
      double priceTotal = 0;
      if (double.parse(item.quantityCart) >= double.parse(item.qtyRemise)) {
        priceTotal =
            double.parse(item.quantityCart) * double.parse(item.remise);
      } else {
        priceTotal =
            double.parse(item.quantityCart) * double.parse(item.priceCart);
      }
      final venteCartModel = VenteCartModel(
          idProductCart: item.idProductCart,
          quantityCart: item.quantityCart,
          priceTotalCart: priceTotal.toString(),
          unite: item.unite,
          tva: item.tva,
          remise: item.remise,
          qtyRemise: item.qtyRemise,
          approbationDG: '-',
          signatureDG: '-',
          signatureJustificationDG: '-',
          approbationFin: '-',
          signatureFin: '-',
          signatureJustificationFin: '-',
          approbationBudget: '-',
          signatureBudget: '-',
          signatureJustificationBudget: '-',
          approbationDD: '-',
          signatureDD: '-',
          signatureJustificationDD: '-',
          succursale: item.succursale,
          signature: item.signature,
          created: item.created);
      await VenteCartApi().insertData(venteCartModel);
    }
  }

  gainVentes() async {
    for (var item in listDataCart) {
      double gainTotal = 0;
      if (double.parse(item.quantityCart) >= double.parse(item.qtyRemise)) {
        gainTotal =
            (double.parse(item.remise) - double.parse(item.priceAchatUnit)) *
                double.parse(item.quantityCart);
      } else {
        gainTotal =
            (double.parse(item.priceCart) - double.parse(item.priceAchatUnit)) *
                double.parse(item.quantityCart);
      }
      final gainModel = GainModel(
        sum: gainTotal,
        approbationDG: '-',
        signatureDG: '-',
        signatureJustificationDG: '-',
        approbationFin: '-',
        signatureFin: '-',
        signatureJustificationFin: '-',
        approbationBudget: '-',
        signatureBudget: '-',
        signatureJustificationBudget: '-',
        approbationDD: '-',
        signatureDD: '-',
        signatureJustificationDD: '-',
        succursale: item.succursale,
        signature: item.signature,
        created: item.created);
      await GainApi().insertData(gainModel);
    }
  }
}
