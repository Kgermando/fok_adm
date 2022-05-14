import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/restitution_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/restitution_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailRestitution extends StatefulWidget {
  const DetailRestitution({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailRestitution> createState() => _DetailRestitutionState();
}

class _DetailRestitutionState extends State<DetailRestitution> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  List<RestitutionModel> restitutionModelList = [];
  List<StocksGlobalMOdel> stockGlobal = [];
  bool isChecked = false;

  @override
  initState() {
    getData();
    super.initState();
  }

    UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    UserModel data = await AuthApi().getUserId();
    RestitutionModel restitutionModel =
        await RestitutionApi().getOneData(widget.id);
    List<StocksGlobalMOdel>? dataStocks = await StockGlobalApi().getAllData();
    setState(() {
      user = data;
      stockGlobal = dataStocks
          .where((element) => element.idProduct == restitutionModel.idProduct)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    child: FutureBuilder<RestitutionModel>(
                        future: RestitutionApi().getOneData(widget.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<RestitutionModel> snapshot) {
                          if (snapshot.hasData) {
                            RestitutionModel? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: p20,
                                      child: IconButton(
                                          onPressed: () =>
                                            Navigator.of(context).pop(),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: data!.idProduct,
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: Scrollbar(
                                        controller: _controllerScroll,
                                        isAlwaysShown: true,
                                        child: pageDetail(data)))
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

  Widget pageDetail(RestitutionModel data) {
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
                  const TitleWidget(title: "Bon de restitution"),
                  Column(
                    children: [
                     PrintWidget(
                        tooltip: 'Imprimer le document',
                        onPressed: () async {},
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(RestitutionModel data) {
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.succursale == user.succursale) accRecepetion(data),
          const SizedBox(height: p20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Produit :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.visible),
              ),
              Expanded(
                child: Text(data.idProduct,
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.visible),
              ),
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Quantité restutué :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(data.quantity))} ${data.unite}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget accRecepetion(RestitutionModel data) {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    return Card(
      child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Accusé reception:',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16)
                        : bodyText1),
                const SizedBox(
                  width: 10.0,
                ),
                (!data.accuseReception)
                    ? (isLoading)
                        ? loadingMini()
                        : checkboxRead(data)
                    : Text('OK',
                        style: Responsive.isDesktop(context)
                            ? const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.green)
                            : bodyText1!.copyWith(color: Colors.green)),
              ],
            ),
          )),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.green;
  }

  checkboxRead(RestitutionModel data) {
    isChecked = data.accuseReception;
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isLoading = true;
        });
        setState(() {
          isChecked = value!;
          transfertProduit(data);
        });
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  Future<void> transfertProduit(RestitutionModel data) async {
    var stockId = stockGlobal.map((e) => e.id).first;
    var achatQty = stockGlobal.map((e) => e.quantity).first;
    var quantityStockG = stockGlobal.map((e) => e.quantityAchat).first;
    var pAU = stockGlobal.map((e) => e.priceAchatUnit).first;
    var pVU = stockGlobal.map((e) => e.prixVenteUnit).first;
    var uniteStock = stockGlobal.map((e) => e.unite).first;
    var modeAchat = stockGlobal.map((e) => e.modeAchat).first;
    var dateAchat = stockGlobal.map((e) => e.created).first;
    var signatureAchat = stockGlobal.map((e) => e.signature).first;
    var tvaAchat = stockGlobal.map((e) => e.tva).first;
    var qtyRavitaillerStock = stockGlobal.map((e) => e.qtyRavitailler).first;

    // Stocks global + qty restitué
    var qtyTransfert = double.parse(achatQty) + double.parse(data.quantity);

    final stocksGlobalMOdel = StocksGlobalMOdel(
        id: stockId,
        idProduct: data.idProduct,
        quantity: qtyTransfert.toString(),
        quantityAchat: quantityStockG,
        priceAchatUnit: pAU,
        prixVenteUnit: pVU,
        unite: uniteStock,
        modeAchat: modeAchat,
        tva: tvaAchat,
        qtyRavitailler: qtyRavitaillerStock,
        signature: signatureAchat,
        created: dateAchat);
    await StockGlobalApi().updateData(stockId!, stocksGlobalMOdel);

    final restitutionModel = RestitutionModel(
        idProduct: data.idProduct,
        quantity: data.quantity,
        unite: data.unite,
        firstName: data.firstName,
        lastName: data.lastName,
        accuseReception: true,
        accuseReceptionFirstName: user.nom.toString(),
        accuseReceptionLastName: user.prenom.toString(),
        role: user.role.toString(),
        succursale: data.succursale,
        signature: user.matricule.toString(),
        created: DateTime.now());
    await RestitutionApi().updateData(data.id!, restitutionModel);
    Navigator.of(context).pop();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${restitutionModel.idProduct} transferé!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
