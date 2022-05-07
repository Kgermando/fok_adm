import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/bon_livraison_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/bon_livraison.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/regex.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:routemaster/routemaster.dart';

class LivraisonStock extends StatefulWidget {
  const LivraisonStock({Key? key, required this.stocksGlobalMOdel})
      : super(key: key);
  final StocksGlobalMOdel stocksGlobalMOdel;
  @override
  State<LivraisonStock> createState() => _LivraisonStockState();
}

class _LivraisonStockState extends State<LivraisonStock> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<SuccursaleModel> succursaleList = [];
  // List<AchatModel> achatList = [];

  int? id;
  String? quantityStock;
  double remise = 0.0;
  double qtyRemise = 0.0;
  double prixVenteUnit = 0.0;
  String? telephone;
  String? succursale;
  String? nameBusiness;

  String? monnaie;
  String? firstName;
  String? lastName;

  TextEditingController controllerQuantity = TextEditingController();
  TextEditingController controllerPrixVenteUnit = TextEditingController();

  @override
  void initState() {
    loadData();
    getData();
    setState(() {
      id = widget.stocksGlobalMOdel.id;
      controllerPrixVenteUnit =
          TextEditingController(text: widget.stocksGlobalMOdel.prixVenteUnit);
    });
    super.initState();
  }

  @override
  void dispose() {
    controllerPrixVenteUnit.dispose();
    super.dispose();
  }

  void loadData() async {
    List<SuccursaleModel>? data = await SuccursaleApi().getAllData();
    setState(() {
      succursaleList = data;
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
                                  Routemaster.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ),
                          const SizedBox(
                            height: p10,
                          ),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Livraison',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TitleWidget(title: "Livraison à $succursale"),
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    succursaleField(),
                    quantityField(),
                    prixVenteField(),
                    Row(
                      children: [
                        Expanded(
                          child: qtyRemiseField(),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: remiseField(),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Livré à $succursale',
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

  Widget succursaleField() {
    var succ = succursaleList.map((e) => e.name).toList().toSet();
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Selectionner la succursale',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: succursale,
        isExpanded: true,
        items: succ.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value != null && value.isEmpty
            ? 'La succursale est obligatoire'
            : null,
        onChanged: (value) {
          setState(() {
            succursale = value;
          });
        },
      ),
    );
  }

  Widget quantityField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        // controller: controllerQuantity, // Ce champ doit etre vide pour permettre a l'admin de saisir la qty
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText:
              'Qtés disponible est de ${widget.stocksGlobalMOdel.quantity} ${widget.stocksGlobalMOdel.unite}',
          suffixStyle: const TextStyle(color: Colors.red),
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value == null) {
            return 'La Qtés à livrer est obligatoire';
          } else if (value.isEmpty) {
            return 'Qtés ne peut pas être nulle';
          } else if (value.contains(RegExp(r'[A-Z]'))) {
            return 'Que les chiffres svp!';
          } else if (double.parse(value) >
              double.parse(widget.stocksGlobalMOdel.quantity)) {
            return 'La Qtés à livrer ne peut pas être superieur à la Qtés actuelle';
          }
          return null;
        },
        onChanged: (value) => setState(() => quantityStock = value),
      ),
    );
  }

  Widget prixVenteField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controllerPrixVenteUnit,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Prix de vente unitaire',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Le Prix de vente unitaires est obligatoire';
          }
          return null;
        },
        onChanged: (value) => setState(() {
          prixVenteUnit = (value == "") ? 0.0 : double.parse(value);
        }),
      ),
    );
  }

  Widget remiseField() {
    return Responsive.isDesktop(context)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    // controller: priceController,
                    keyboardType: TextInputType.number,
                    // initialValue: '1',
                    decoration: InputDecoration(
                      labelText: 'Remise en % (Facultatif) ',
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
                      remise = (value == "") ? 1 : double.parse(value);
                    }),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: remiseValeur(),
              )
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  // controller: priceController,
                  keyboardType: TextInputType.number,
                  // initialValue: '1',
                  decoration: InputDecoration(
                    labelText: 'Remise en % (Facultatif) ',
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
                    remise = (value == "") ? 1 : double.parse(value);
                  }),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              remiseValeur()
            ],
          );
  }

  Widget qtyRemiseField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        // initialValue: '1',
        decoration: InputDecoration(
          labelText: 'Quantités pour la remise (Facultatif) ',
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
          qtyRemise = (value == "") ? 1 : double.parse(value);
        }),
      ),
    );
  }

  double? pavTVARemise;

  remiseValeur() {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    var remiseEnPourcent = (prixVenteUnit * remise) / 100;

    pavTVARemise = prixVenteUnit - remiseEnPourcent;

    return Container(
      margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
      child: Text('R: ${pavTVARemise!.toStringAsFixed(2)} $monnaie',
          style: bodyText1),
    );
  }

  // Livraison vers succursale
  void submit() async {
    var qtyRestanteStockGlobal =
        double.parse(widget.stocksGlobalMOdel.quantity) -
            double.parse(quantityStock.toString());

    var remisePourcent =
        (prixVenteUnit * double.parse(remise.toString())) / 100;
    var remisePourcentToMontant = prixVenteUnit - remisePourcent;

    // Update quantity stock global
    final stocksGlobalMOdel = StocksGlobalMOdel(
        idProduct: widget.stocksGlobalMOdel.idProduct,
        quantity: qtyRestanteStockGlobal.toString(),
        quantityAchat: widget.stocksGlobalMOdel.quantityAchat,
        priceAchatUnit: widget.stocksGlobalMOdel.priceAchatUnit,
        prixVenteUnit: widget.stocksGlobalMOdel.prixVenteUnit,
        unite: widget.stocksGlobalMOdel.unite,
        modeAchat: widget.stocksGlobalMOdel.modeAchat,
        tva: widget.stocksGlobalMOdel.tva,
        qtyRavitailler: widget.stocksGlobalMOdel.qtyRavitailler,
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
        signature: widget.stocksGlobalMOdel.signature,
        created: widget.stocksGlobalMOdel.created);
    await StockGlobalApi()
        .updateData(widget.stocksGlobalMOdel.id!, stocksGlobalMOdel);

    // Generer le bon de livraison pour la succursale
    final bonLivraisonModel = BonLivraisonModel(
        idProduct: widget.stocksGlobalMOdel.idProduct,
        quantityAchat: quantityStock.toString(),
        priceAchatUnit: widget.stocksGlobalMOdel.priceAchatUnit,
        prixVenteUnit: prixVenteUnit.toString(),
        unite: widget.stocksGlobalMOdel.unite,
        firstName: user!.prenom.toString(),
        lastName: user!.nom.toString(),
        tva: widget.stocksGlobalMOdel.tva,
        remise: remisePourcentToMontant.toString(),
        qtyRemise: qtyRemise.toString(),
        accuseReception: false,
        accuseReceptionFirstName: '-',
        accuseReceptionLastName: '-',
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
        succursale: succursale.toString(),
        signature: user!.matricule.toString(),
        created: DateTime.now());
    await BonLivraisonApi().insertData(bonLivraisonModel);
    Routemaster.of(context).pop();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${bonLivraisonModel.idProduct} livré!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
