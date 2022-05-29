import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/bon_livraison_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/livraison_history_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/helpers/pdf_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/bon_livraison.dart';
import 'package:fokad_admin/src/models/comm_maketing/livraiason_history_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/bon_livraison/pdf/bon_livraison_pdf.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailBonLivraison extends StatefulWidget {
  const DetailBonLivraison({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailBonLivraison> createState() => _DetailBonLivraisonState();
}

class _DetailBonLivraisonState extends State<DetailBonLivraison> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  List<BonLivraisonModel> bonLivraisonList = [];
  List<AchatModel> achatList = [];
  bool isChecked = false;

  @override
  initState() {
    getData();
    super.initState();
  }

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
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    BonLivraisonModel? bonLivraison =
        await BonLivraisonApi().getOneData(widget.id);
    List<AchatModel>? dataAchat = await AchatApi().getAllData();
    setState(() {
      user = userModel;
      achatList = dataAchat
          .where((element) => element.idProduct == bonLivraison.idProduct)
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
                    child: FutureBuilder<BonLivraisonModel>(
                        future: BonLivraisonApi().getOneData(widget.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<BonLivraisonModel> snapshot) {
                          if (snapshot.hasData) {
                            BonLivraisonModel? data = snapshot.data;
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

  Widget pageDetail(BonLivraisonModel data) {
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
                  const TitleWidget(title: "Bon de livraison"),
                  Column(
                    children: [
                      PrintWidget(
                        tooltip: 'Imprimer le document',
                        onPressed: () async {
                          final pdfFile =
                              await BonLivraisonPDF.generate(data, "\$");

                          PdfApi.openFile(pdfFile);
                        },
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

  Widget dataWidget(BonLivraisonModel data) {
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
                child: Text('Quantité Entrée :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(data.quantityAchat))} ${data.unite}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
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
                child: Text('TVA :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text('${data.tva} %',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Prix de vente unitaire :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(data.prixVenteUnit))} \$',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          if (double.parse(data.qtyRemise) >= 1)
            Divider(
              color: Colors.amber.shade700,
            ),
          if (double.parse(data.qtyRemise) >= 1)
            Row(
              children: [
                Expanded(
                  child: Text('Prix de Remise :',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText2,
                      overflow: TextOverflow.ellipsis),
                ),
                Expanded(
                  child: Text(
                      '${NumberFormat.decimalPattern('fr').format(double.parse(data.remise))} \$',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText2,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          if (double.parse(data.qtyRemise) >= 1)
            Divider(
              color: Colors.amber.shade700,
            ),
          if (double.parse(data.qtyRemise) >= 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('Qtés pour la remise :',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText2,
                      overflow: TextOverflow.ellipsis),
                ),
                Expanded(
                  child: Text('${data.qtyRemise} ${data.unite}',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText2,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget accRecepetion(BonLivraisonModel data) {
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

  checkboxRead(BonLivraisonModel data) {
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
          bonLivraisonStock(data);
        });
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  // Livraison vers succursale
  void bonLivraisonStock(BonLivraisonModel data) async {
    // Update Bon livraison
    final bonLivraisonModel = BonLivraisonModel(
        idProduct: data.idProduct,
        quantityAchat: data.quantityAchat,
        priceAchatUnit: data.priceAchatUnit,
        prixVenteUnit: data.prixVenteUnit,
        unite: data.unite,
        firstName: data.firstName,
        lastName: data.lastName,
        tva: data.tva,
        remise: data.remise,
        qtyRemise: data.qtyRemise,
        accuseReception: isChecked,
        accuseReceptionFirstName: user.nom.toString(),
        accuseReceptionLastName: user.prenom.toString(),
        succursale: data.succursale,
        signature: user.matricule,
        created: DateTime.now());
    await BonLivraisonApi().updateData(data.id!, bonLivraisonModel);

    if (achatList.isNotEmpty) {
      // Filter de la QuantityAchat de stock succursale
      // var achatQtyId = achatList.map((e) => e.id).first;
      var achatQty = achatList.map((e) => e.quantityAchat).first;
      var achatQtyRestante = achatList.map((e) => e.quantity).first;
      var pAU = achatList.map((e) => e.priceAchatUnit).first;
      var pVU = achatList.map((e) => e.prixVenteUnit).first;
      var dateAchat = achatList.map((e) => e.created).first;
      var succursaleAchat = achatList.map((e) => e.succursale).first;
      var tvaAchat = achatList.map((e) => e.tva).first;
      var remiseAchat = achatList.map((e) => e.remise).first;
      var qtyRemiseAchat = achatList.map((e) => e.qtyRemise).first;
      var qtyLivreAchat = achatList.map((e) => e.qtyLivre).first;

      // LA qtyAchatRestante est additionner à la qty de livraison de stocks global
      double qtyAchatDisponible =
          double.parse(achatQtyRestante) + double.parse(data.quantityAchat);

      // Add Livraison history si la succursale == la succursale de ravitaillement
      var margeBenMap = (double.parse(pVU) - double.parse(pAU)) *
          double.parse(achatQtyRestante);

      var margeBenRemise = (double.parse(remiseAchat) - double.parse(pAU)) *
          double.parse(achatQtyRestante);

      // Insert to Historique de Livraisons Stocks au comptant
      final livraisonHistoryModel = LivraisonHistoryModel(
          idProduct: data.idProduct,
          quantityAchat: achatQty.toString(),
          quantity: achatQtyRestante.toString(),
          priceAchatUnit: pAU.toString(),
          prixVenteUnit: pVU.toString(),
          unite: data.unite,
          margeBen: margeBenMap.toString(),
          tva: tvaAchat.toString(),
          remise: remiseAchat.toString(),
          qtyRemise: qtyRemiseAchat.toString(),
          margeBenRemise: margeBenRemise.toString(),
          qtyLivre: qtyLivreAchat,
          succursale: succursaleAchat.toString(),
          signature: data.signature,
          created: dateAchat);
      await LivraisonHistoryApi().insertData(livraisonHistoryModel);

      // Update AchatModel
      final achatModel = AchatModel(
          idProduct: data.idProduct,
          quantity: qtyAchatDisponible.toString(),
          quantityAchat: qtyAchatDisponible
              .toString(), // Qty Achat est additionné à la qty livré
          priceAchatUnit: data.priceAchatUnit,
          prixVenteUnit: data.prixVenteUnit,
          unite: data.unite,
          tva: data.tva,
          remise: data.remise,
          qtyRemise: data.qtyRemise,
          qtyLivre: data.quantityAchat,
          succursale: data.succursale,
          signature: user.matricule,
          created: DateTime.now());
      await AchatApi().updateData(data.id!, achatModel);
      // Navigator.of(context).pop();
      Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${achatModel.idProduct} mis à jour!"),
        backgroundColor: Colors.green[700],
      ));
    } else {
      // add to Stocks au comptant
      final achatModel = AchatModel(
          idProduct: data.idProduct,
          quantity: data.quantityAchat,
          quantityAchat: data.quantityAchat, // Qty de livraison (entrant)
          priceAchatUnit: data.priceAchatUnit,
          prixVenteUnit: data.prixVenteUnit,
          unite: data.unite,
          tva: data.tva,
          remise: data.remise,
          qtyRemise: data.qtyRemise,
          qtyLivre: data.quantityAchat,
          succursale: data.succursale,
          signature: user.matricule,
          created: DateTime.now());
      await AchatApi().insertData(achatModel);
      // Navigator.of(context).pop();
      Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${achatModel.idProduct} a été ajouté!"),
        backgroundColor: Colors.green[700],
      ));
    }
  }
}
