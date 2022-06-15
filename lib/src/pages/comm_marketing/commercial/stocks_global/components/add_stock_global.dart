import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/produit_model_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/regex.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';

class AddStockGlobal extends StatefulWidget {
  const AddStockGlobal({Key? key}) : super(key: key);

  @override
  State<AddStockGlobal> createState() => _AddStockGlobalState();
}

class _AddStockGlobalState extends State<AddStockGlobal> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<ProductModel> idProductDropdown = [];

  List<StocksGlobalMOdel> stocksGlobalList = [];

  final List<String> unites = Dropdown().unites;

  String? idProduct;
  String quantityAchat = '0.0';
  String priceAchatUnit = '0.0';
  double prixVenteUnit = 0.0;
  String? unite;
  bool modeAchat = true;
  DateTime? date;
  String? telephone;
  String? succursale;
  String? nameBusiness;
  double tva = 0.0;

  @override
  initState() {
    getData();
    super.initState();
  }

  String? signature;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var produitModel = await ProduitModelApi().getAllData();
    var stockGlobal = await StockGlobalApi().getAllData();
    var approbations = await ApprobationApi().getAllData();

    if (!mounted) return;
    setState(() {
      signature = userModel.matricule; 
    // Verifie les approbation si c'est la list es vide
    if (approbations.isNotEmpty) {
      List<ApprobationModel> isApproved = [];
      for (var item in produitModel) {
        isApproved = approbations
            .where((element) =>
                element.reference.microsecondsSinceEpoch ==
                item.created.microsecondsSinceEpoch)
            .toList();
      }
      // FIltre si le filtre donne des elements
      if (isApproved.isNotEmpty) {
        for (var item in approbations) {
          idProductDropdown = produitModel
              .where((element) =>
                  element.created.microsecondsSinceEpoch ==
                          item.reference.microsecondsSinceEpoch &&
                      item.fontctionOccupee == 'Directeur de departement' &&
                      item.approbation == "Approved" ||
                  element.signature == userModel.matricule)
              .toList();
        }
      } else {
        idProductDropdown = produitModel
            .where((element) => element.signature == userModel.matricule)
            .toList();
      }
    } else {
      idProductDropdown = produitModel
          .where((element) => element.signature == userModel.matricule)
          .toList();
    }
      stocksGlobalList = stockGlobal; // Permet de filtrer les doubons
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                  title: 'Ajout stock',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addPageWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget() {
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
                    Row(
                      children: [
                        Expanded(
                          child: idProductField(),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: uniteField(),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: quantityAchatField(),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: priceAchatUnitField(),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: prixVenteField(),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: tvaField(),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Soumettre',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submit();
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
        child: FlutterSwitch(
          width: 225.0,
          height: 55.0,
          inactiveColor: Colors.red,
          valueFontSize: 25.0,
          toggleSize: 45.0,
          value: modeAchat,
          borderRadius: 30.0,
          padding: 8.0,
          showOnOff: true,
          activeText: 'PAYE',
          inactiveText: 'NON PAYE',
          onToggle: (val) {
            setState(() {
              modeAchat = val;
            });
          },
        ));
  }

  Widget idProductField() {
    List<String> prod = [];
    List<String> stocks = [];
    List<String> catList = [];

    prod = idProductDropdown.map((e) => e.idProduct).toSet().toList();
    stocks = stocksGlobalList.map((e) => e.idProduct).toSet().toList();

    catList = prod.toSet().difference(stocks.toSet()).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Identifiant du produit',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: idProduct,
        isExpanded: true,
        // style: const TextStyle(color: Colors.deepPurple),
        items: catList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (produit) {
          setState(() {
            idProduct = produit;
          });
        },
      ),
    );
  }

  Widget uniteField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Choisissez votre Unité d\'achat',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: unite,
        isExpanded: true,
        // style: const TextStyle(color: Colors.deepPurple),
        items: unites.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            unite = value;
          });
        },
      ),
    );
  }

  Widget quantityAchatField() {
    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            labelText: 'Quantités entrant',
            labelStyle: const TextStyle(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'La Quantité total est obligatoire';
            } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
              return 'chiffres obligatoire';
            } else {
              return null;
            }
          },
          onChanged: (value) => setState(() {
            quantityAchat = value.trim();
          }),
        ));
  }

  Widget priceAchatUnitField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          labelText: 'Prix d\'achat unitaire',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Le Prix total d\'achat est obligatoire';
          } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
            return 'chiffres obligatoire';
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() {
          priceAchatUnit = value.trim();
        }),
      ),
    );
  }

  Widget prixVenteField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
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
          prixVenteUnit = (value == "") ? 1 : double.parse(value);
        }),
      ),
    );
  }

  Widget tvaField() {
    return Responsive.isDesktop(context)
        ? Row(
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
                child: tvaValeur(),
              )
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText: 'TVA en %',
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
              const SizedBox(
                width: 10.0,
              ),
              tvaValeur()
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

  Future<void> submit() async {
    final stocksGlobalMOdel = StocksGlobalMOdel(
        idProduct: idProduct.toString(),
        quantity: quantityAchat.toString(),
        quantityAchat: quantityAchat.toString(),
        priceAchatUnit: priceAchatUnit.toString(),
        prixVenteUnit: prixVenteUnit.toString(),
        unite: unite.toString(),
        modeAchat: 'false',
        tva: tva.toString(),
        qtyRavitailler: quantityAchat.toString(),
        signature: signature.toString(),
        created: DateTime.now());
    await StockGlobalApi().insertData(stocksGlobalMOdel);
    Navigator.of(context).pop();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${stocksGlobalMOdel.idProduct} ajouté!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
