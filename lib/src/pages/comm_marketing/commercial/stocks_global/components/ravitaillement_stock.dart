import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/history_rabitaillement_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/produit_model_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/history_ravitaillement_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/regex.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:intl/intl.dart';

class RavitailleemntStock extends StatefulWidget {
  const RavitailleemntStock({Key? key}) : super(key: key);

  @override
  State<RavitailleemntStock> createState() => _RavitailleemntStockState();
}

class _RavitailleemntStockState extends State<RavitailleemntStock> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final List<String> unites = Dropdown().unites;
  List<ProductModel> idProductDropdown = [];

  int? id;
  String? quantity;
  String? priceAchatUnit;
  double prixVenteUnit = 0.0;
  double tva = 0.0;
  bool modeAchat = true;
  DateTime? date;
  String? telephone;
  String? succursale;
  String? nameBusiness;

  TextEditingController controlleridProduct = TextEditingController();
  TextEditingController controllerquantity = TextEditingController();
  // TextEditingController controllerQuantityAchat = TextEditingController();
  TextEditingController controllerpriceAchatUnit = TextEditingController();
  TextEditingController controllerPrixVenteUnit = TextEditingController();
  TextEditingController controllerUnite = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    loadProdModel();
    setState(() {});
  }

  @override
  void dispose() {
    controlleridProduct.dispose();
    controllerquantity.dispose();
    controllerpriceAchatUnit.dispose();
    controllerPrixVenteUnit.dispose();
    controllerUnite.dispose();
    super.dispose();
  }

  void loadProdModel() async {
    List<ProductModel>? achatDB = await ProduitModelApi().getAllData();
    if (!mounted) return;
    setState(() {
      idProductDropdown = achatDB;
    });
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    StocksGlobalMOdel stocksGlobalMOdel =
        ModalRoute.of(context)!.settings.arguments as StocksGlobalMOdel;

    // controlleridProduct =
    //     TextEditingController(text: stocksGlobalMOdel.idProduct);
    // controllerquantity =
    //     TextEditingController(text: stocksGlobalMOdel.quantity);
    // controllerpriceAchatUnit =
    //     TextEditingController(text: stocksGlobalMOdel.priceAchatUnit);
    // controllerPrixVenteUnit =
    //     TextEditingController(text: stocksGlobalMOdel.prixVenteUnit);
    // controllerUnite =
    //     TextEditingController(text: stocksGlobalMOdel.unite);
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ),
                          const SizedBox(width: p10),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Ravitaillement',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addPageWidget(stocksGlobalMOdel),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget(StocksGlobalMOdel data) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: SizedBox(
                width: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width,
                child: ListView(
                  controller: _controllerScroll,
                  children: [
                    modeAchatField(),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                            child: quantityField(data),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: priceAchatUnitField(data),
                          )
                        ],
                      ),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                            child: prixVenteField(data),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: tvaField(data),
                          )
                        ],
                      ),
                    if (!Responsive.isDesktop(context)) quantityField(data),
                    if (!Responsive.isDesktop(context))
                      priceAchatUnitField(data),
                    if (!Responsive.isDesktop(context)) prixVenteField(data),
                    if (!Responsive.isDesktop(context)) tvaField(data),
                    if (!Responsive.isDesktop(context))
                      const SizedBox(
                        height: p20,
                      ),
                    BtnWidget(
                        title: 'Ravitailler',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submit(data);
                            form.reset();
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget modeAchatField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Text(
            "Décochez la case si Achats à crédit",
            style: Responsive.isDesktop(context)
                ? Theme.of(context).textTheme.bodyText1
                : Theme.of(context).textTheme.bodyText2,
          ),
          Checkbox(
            value: modeAchat,
            onChanged: (bool? value) {
              setState(() {
                modeAchat = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget quantityField(StocksGlobalMOdel data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controllerquantity,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: 'Quantités',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (quantity) => quantity != null && quantity.isEmpty
                  ? 'La Quantité total est obligatoire'
                  : null,
              onChanged: (value) => setState(() => controllerquantity.text),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Column(
                  children: [
                    const Text("Quantité précédent"),
                    Text("${data.quantity} ${data.unite} \$",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.orange)),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget priceAchatUnitField(StocksGlobalMOdel data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controllerpriceAchatUnit,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: 'Prix d\'achats unitaire',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) => value != null && value.isEmpty
                  ? 'Le prix d\'achat unitaire est obligatoire'
                  : null,
              onChanged: (value) =>
                  setState(() => controllerpriceAchatUnit.text),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Column(
                  children: [
                    const Text("Prix d'achat précédent"),
                    Text(
                        "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.priceAchatUnit).toStringAsFixed(2)))} \$",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.orange)),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget prixVenteField(StocksGlobalMOdel data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controllerPrixVenteUnit,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: 'Prix de vente unitaire',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Le Prix de vente unitaires est obligatoire';
                } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
                  return 'chiffres obligatoire';
                } else {
                  return null;
                }
              },
              onChanged: (value) => setState(() {
                prixVenteUnit = (value == "") ? 0.0 : double.parse(value);
              }),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Column(
                  children: [
                    const Text("Prix de vente précédent"),
                    Text(
                        "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.prixVenteUnit).toStringAsFixed(2)))} \$",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.orange)),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget tvaField(StocksGlobalMOdel data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: 'TVA en %',
                // hintText: 'Mettez "1" si vide',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) {
                if (RegExpIsValide().isValideVente.hasMatch(value!)) {
                  return 'chiffres obligatoire';
                } else {
                  return null;
                }
              },
              onChanged: (value) => setState(() {
                tva = (value == "") ? 1 : double.parse(value);
              }),
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 1,
          child: tvaValeur(),
        )
      ],
    );
  }

  double? pavTVA;

  tvaValeur() {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    var pvau = prixVenteUnit * tva / 100;

    pavTVA = prixVenteUnit + pvau;

    return Container(
        margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
        child: Text('PVU: ${pavTVA!.toStringAsFixed(2)} \$', style: bodyText1));
  }

  // HIstorique de ravitaillement
  void submit(StocksGlobalMOdel data) async {
    var qtyDisponible =
        double.parse(controllerquantity.text) + double.parse(data.quantity);

    // Add Achat history pour voir les entrés et sorties de chaque produit
    var qtyDifference =
        double.parse(data.quantityAchat) - double.parse(data.quantity);
    var priceDifference = pavTVA! - double.parse(data.priceAchatUnit);
    var margeBenMap = qtyDifference * priceDifference;

    final historyRavitaillementModel = HistoryRavitaillementModel(
        idProduct: data.idProduct,
        quantity: data.quantity,
        quantityAchat: data.quantityAchat,
        priceAchatUnit: data.priceAchatUnit,
        prixVenteUnit: data.prixVenteUnit,
        unite: data.unite,
        margeBen: margeBenMap.toString(),
        tva: data.tva,
        qtyRavitailler: data.qtyRavitailler,
        succursale: user!.succursale,
        signature: user!.matricule.toString(),
        created: data.created);
    await HistoryRavitaillementApi().insertData(historyRavitaillementModel);

    // Update Achat stock global
    final stocksGlobalMOdel = StocksGlobalMOdel(
        id: data.id!,
        idProduct: data.idProduct,
        quantity: qtyDisponible.toString(),
        quantityAchat: qtyDisponible.toString(),
        priceAchatUnit: controllerpriceAchatUnit.text,
        prixVenteUnit: pavTVA.toString(),
        unite: data.unite,
        modeAchat: modeAchat.toString(),
        tva: tva.toString(),
        qtyRavitailler: data.qtyRavitailler,
        signature: user!.matricule.toString(),
        created: DateTime.now());
    await StockGlobalApi().updateData(stocksGlobalMOdel);

    Navigator.of(context).pop();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${stocksGlobalMOdel.idProduct} mis à jour!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
