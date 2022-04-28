import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/vente_cart_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/vente_cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class DetailAchat extends StatefulWidget {
  const DetailAchat({Key? key, required this.achat}) : super(key: key);
  final AchatModel achat;

  @override
  State<DetailAchat> createState() => _DetailAchatState();
}

class _DetailAchatState extends State<DetailAchat> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  @override
  initState() {
    getData();
    super.initState();
  }

  // All ventes
  List<VenteCartModel> venteCartList = [];

  AchatModel? achatModel;
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    AchatModel data = await AchatApi().getOneData(widget.achat.id!);
    var ventes = await VenteCartApi().getAllData();
    setState(() {
      user = userModel;
      achatModel = data;
      venteCartList = ventes;
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
                    child: FutureBuilder<AchatModel>(
                        future: AchatApi().getOneData(widget.achat.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<AchatModel> snapshot) {
                          if (snapshot.hasData) {
                            AchatModel? data = snapshot.data;
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

  Widget pageDetail(AchatModel data) {
    var roleAgent = int.parse(user!.role) <= 3;
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          reporting(),
                          if (roleAgent)
                            if (double.parse(widget.achat.quantity) > 0)
                              transfertProduit()
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yy").format(data.created),
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

  Widget dataWidget(AchatModel data) {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          header(),
          headerTitle(),
          const SizedBox(
            height: 20,
          ),
          achatTitle(),
          achats(),
          const SizedBox(
            height: 20,
          ),
          ventetitle(),
          ventes(),
          const SizedBox(
            height: 20,
          ),
          benficesTitle(),
          benfices(),
          const SizedBox(
            height: 30,
          ),
          achatHistorityTitle(),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget header() {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Ajouté le ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              Text(DateFormat("dd.MM.yy HH:mm").format(widget.achat.created),
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 16)),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text('Succursale: ${widget.achat.succursale.toUpperCase()}',
              style: Responsive.isDesktop(context) ? bodyText1 : bodyText2),
        ],
      ),
    ));
  }

  Widget headerTitle() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return SizedBox(
      width: double.infinity,
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(widget.achat.idProduct,
            style: Responsive.isDesktop(context)
                ? const TextStyle(fontWeight: FontWeight.w600, fontSize: 30)
                : headline6),
      )),
    );
  }

  Widget achatTitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'ACHATS',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget achats() {
    var roleAgent = int.parse(user!.role) <= 3;

    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    var prixAchatTotal = double.parse(widget.achat.priceAchatUnit) *
        double.parse(widget.achat.quantityAchat);
    var margeBenifice = double.parse(widget.achat.prixVenteUnit) -
        double.parse(widget.achat.priceAchatUnit);
    var margeBenificeTotal =
        margeBenifice * double.parse(widget.achat.quantityAchat);

    var margeBenificeRemise = double.parse(widget.achat.remise) -
        double.parse(widget.achat.priceAchatUnit);
    var margeBenificeTotalRemise =
        margeBenificeRemise * double.parse(widget.achat.quantityAchat);

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
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.achat.qtyLivre).toStringAsFixed(2)))} ${widget.achat.unite}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            if (roleAgent)
              const Divider(
                color: Colors.black87,
              ),
            if (roleAgent)
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
                      '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.achat.priceAchatUnit).toStringAsFixed(2)))} \$',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            if (roleAgent)
              const Divider(
                color: Colors.black87,
              ),
            if (roleAgent)
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
            const Divider(
              color: Colors.black87,
            ),
            Row(
              children: [
                Text('TVA',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text('${widget.achat.tva} %',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            const Divider(
              color: Colors.black87,
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
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.achat.prixVenteUnit).toStringAsFixed(2)))} \$',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            const Divider(
              color: Colors.black87,
            ),
            Row(
              children: [
                Text('Prix de Remise',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${double.parse(widget.achat.remise).toStringAsFixed(2)} \$',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            const Divider(
              color: Colors.black87,
            ),
            Row(
              children: [
                Text('Qtés pour la remise',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text('${widget.achat.qtyRemise} ${widget.achat.unite}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            if (roleAgent)
              const Divider(
                color: Colors.black87,
              ),
            if (roleAgent)
              const SizedBox(
                height: 20.0,
              ),
            if (roleAgent)
              Responsive.isDesktop(context)
                  ? Row(
                      children: [
                        Text('Marge bénéficiaire unitaire / Remise',
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.orange)
                                : bodyText2,
                            overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        Text(
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} \$ / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeRemise.toStringAsFixed(2)))} \$',
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
                        Text('Marge bénéficiaire unitaire / Remise',
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
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} \$ / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeRemise.toStringAsFixed(2)))} \$',
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
            if (roleAgent)
              const Divider(
                color: Colors.black87,
              ),
            if (roleAgent)
              Responsive.isDesktop(context)
                  ? Row(
                      children: [
                        Text('Marge bénéficiaire total / Remise',
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Color(0xFFE64A19))
                                : bodyText1,
                            overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        Text(
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} \$ / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotalRemise.toStringAsFixed(2)))} \$',
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
                        Text('Marge bénéficiaire total / Remise',
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
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} \$ / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotalRemise.toStringAsFixed(2)))} \$',
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

  Widget ventetitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'VENTES',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget ventes() {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    double qtyVendus = 0;
    double prixTotalVendu = 0;

    var ventesQty = venteCartList
        .where((element) {
          String v1 = element.idProductCart;
          String v2 = widget.achat.idProduct;
          int date1 = element.created.millisecondsSinceEpoch;
          int date2 = widget.achat.created.millisecondsSinceEpoch;
          return v1 == v2 && date2 >= date1;
        })
        .map((e) => double.parse(e.quantityCart))
        .toList();

    for (var item in ventesQty) {
      qtyVendus += item;
    }

    var ventesPrix = venteCartList
        .where((element) {
          var v1 = element.idProductCart;
          var v2 = widget.achat.idProduct;
          var date1 = element.created.millisecondsSinceEpoch;
          var date2 = widget.achat.created.millisecondsSinceEpoch;
          return v1 == v2 && date2 >= date1;
        })
        .map((e) => double.parse(e.priceTotalCart))
        .toList();

    for (var item in ventesPrix) {
      prixTotalVendu += item;
    }

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantités vendus',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyText2),
              Text('Montant vendus',
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
                  '${NumberFormat.decimalPattern('fr').format(double.parse(qtyVendus.toStringAsFixed(0)))} ${widget.achat.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)
                      : bodyText1),
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(prixTotalVendu.toStringAsFixed(2)))} \$',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)
                      : bodyText1),
            ],
          ),
        ],
      ),
    ));
  }

  Widget benficesTitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'STOCKS',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget benfices() {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    var prixTotalRestante = double.parse(widget.achat.quantity) *
        double.parse(widget.achat.prixVenteUnit);

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Restes des ${widget.achat.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyText2),
              Text('Revenues',
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
                  '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.achat.quantity).toStringAsFixed(0)))} ${widget.achat.unite}',
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
          'HISTORIQUE DES PRODUITS RECUS',
          textAlign: TextAlign.center,
          style: Responsive.isDesktop(context)
              ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
              : const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget transfertProduit() {
    return IconButton(
      color: Colors.red,
      icon: const Icon(Icons.assistant_direction),
      tooltip: 'Restitution de la quantité en stocks',
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de vouloir restituer la quantité?'),
          content: const Text(
              'Cette action permet de restitutuer la quantité chez l\'expediteur.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Annuler'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Routemaster.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
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
}