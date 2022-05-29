import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/livraison_stock.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/ravitaillement_stock.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/table_history_ravitaillement_produit.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class DetailStockGlobal extends StatefulWidget {
  const DetailStockGlobal({Key? key, required this.stocksGlobalMOdel})
      : super(key: key);
  final StocksGlobalMOdel stocksGlobalMOdel;

  @override
  State<DetailStockGlobal> createState() => _DetailStockGlobalState();
}

class _DetailStockGlobalState extends State<DetailStockGlobal> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  @override
  initState() {
    getData();
    super.initState();
  }

  StocksGlobalMOdel? stocksGlobalMOdel;
  Future<void> getData() async {
    StocksGlobalMOdel data =
        await StockGlobalApi().getOneData(widget.stocksGlobalMOdel.id!);
    setState(() {
      stocksGlobalMOdel = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: speedialWidget(),
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
                    child: FutureBuilder<StocksGlobalMOdel>(
                        future: StockGlobalApi()
                            .getOneData(widget.stocksGlobalMOdel.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<StocksGlobalMOdel> snapshot) {
                          if (snapshot.hasData) {
                            StocksGlobalMOdel? data = snapshot.data;
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
                                          title: data!.idProduct,
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        controller: _controllerScroll,
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

  Widget pageDetail(StocksGlobalMOdel data) {
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
                  TitleWidget(title: widget.stocksGlobalMOdel.idProduct),
                  Column(
                    children: [
                      reporting(),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              // infosEditeurWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(StocksGlobalMOdel data) {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          achats(),
          const SizedBox(
            height: 20,
          ),
          disponiblesTitle(),
          disponibles(),
          const SizedBox(
            height: 30,
          ),
          achatHistorityTitle(),
          const SizedBox(
            height: 20,
          ),
          TableHistoryRavitaillementProduit(stocksGlobalMOdel: data),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget achats() {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    var prixAchatTotal = double.parse(widget.stocksGlobalMOdel.priceAchatUnit) *
        double.parse(widget.stocksGlobalMOdel.quantityAchat);

    var margeBenifice = double.parse(widget.stocksGlobalMOdel.prixVenteUnit) -
        double.parse(widget.stocksGlobalMOdel.priceAchatUnit);
    var margeBenificeTotal =
        margeBenifice * double.parse(widget.stocksGlobalMOdel.quantityAchat);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Quantités entrant',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.quantityAchat).toStringAsFixed(0)))} ${widget.stocksGlobalMOdel.unite}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Divider(
              color: Colors.amber.shade700,
            ),
            Row(
              children: [
                Text('Prix d\'achats unitaire',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.priceAchatUnit).toStringAsFixed(2)))} \$',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Divider(
              color: Colors.amber.shade700,
            ),
            Row(
              children: [
                Text('Prix d\'achats total',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(prixAchatTotal.toStringAsFixed(2)))} \$',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            if (double.parse(widget.stocksGlobalMOdel.tva) > 1)
              Divider(
                color: Colors.amber.shade700,
              ),
            if (double.parse(widget.stocksGlobalMOdel.tva) > 1)
              Row(
                children: [
                  Text('TVA',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText2,
                      overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Text('${widget.stocksGlobalMOdel.tva} %',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            Divider(
              color: Colors.amber.shade700,
            ),
            Row(
              children: [
                Text('Prix de vente unitaire',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.prixVenteUnit).toStringAsFixed(2)))} \$',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Divider(
              color: Colors.amber.shade700,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Responsive.isDesktop(context)
                ? Row(
                    children: [
                      Text('Marge bénéficiaire unitaire',
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.orange)
                              : bodyText2,
                          overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      Text(
                          '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} \$',
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.orange)
                              : bodyText2,
                          overflow: TextOverflow.ellipsis),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Marge bénéficiaire unitaire',
                          textAlign: TextAlign.left,
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.orange)
                              : bodyText2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} \$',
                          textAlign: TextAlign.left,
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.orange)
                              : bodyText2,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
            Divider(
              color: Colors.amber.shade700,
            ),
            Responsive.isDesktop(context)
                ? Row(
                    children: [
                      Text('Marge bénéficiaire total',
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xFFE64A19))
                              : bodyText1,
                          overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      Text(
                          '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} \$',
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xFFE64A19))
                              : bodyText1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Marge bénéficiaire total',
                          textAlign: TextAlign.left,
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xFFE64A19))
                              : bodyText1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} \$',
                          textAlign: TextAlign.left,
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xFFE64A19))
                              : bodyText1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget disponiblesTitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'DISPONIBLES',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget disponibles() {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    var prixTotalRestante = double.parse(widget.stocksGlobalMOdel.quantity) *
        double.parse(widget.stocksGlobalMOdel.prixVenteUnit);

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Restes des ${widget.stocksGlobalMOdel.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyText2),
              Text('Revenus',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyText2),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.quantity).toStringAsFixed(0)))} ${widget.stocksGlobalMOdel.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)
                      : bodyText1),
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(prixTotalRestante.toStringAsFixed(2)))} \$',
                  style: Responsive.isDesktop(context)
                      ? TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: Colors.green[800])
                      : bodyText1),
            ],
          ),
        ],
      ),
    ));
  }

  Widget achatHistorityTitle() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'FICHES DE STOCKS',
          textAlign: TextAlign.center,
          style: Responsive.isDesktop(context)
              ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
              : const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget reporting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            tooltip: 'Export Excel',
            onPressed: exportToExcel,
            icon: const Icon(
              Icons.download,
              color: Colors.green,
            )),
      ],
    );
  }

  Future<void> exportToExcel() async {}

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
          child: const Icon(Icons.monetization_on),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Ravitaillement',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RavitailleemntStock(
                    stocksGlobalMOdel: widget.stocksGlobalMOdel)));
          },
        ),
        SpeedDialChild(
            child: const Icon(Icons.content_paste_sharp),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade700,
            label: 'Livraison',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LivraisonStock(
                    stocksGlobalMOdel: widget.stocksGlobalMOdel)))),
      ],
    );
  }
}
