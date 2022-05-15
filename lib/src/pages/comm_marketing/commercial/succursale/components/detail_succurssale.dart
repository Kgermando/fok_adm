import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/creance_facture_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/gain_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/vente_cart_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/creance_cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/gain_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/vente_cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/stats_succusale.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailSuccursale extends StatefulWidget {
  const DetailSuccursale({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailSuccursale> createState() => _DetailSuccursaleState();
}

class _DetailSuccursaleState extends State<DetailSuccursale> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  DateTimeRange? dateRange;

  String getPlageDate() {
    if (dateRange == null) {
      return 'Filtre par plage de date';
    } else {
      return '${DateFormat('dd/MM/yyyy').format(dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(dateRange!.end)}';
    }
  }

  String approbationDGController = '-';
  String approbationFinController = '-';
  String approbationBudgetController = '-';
  String approbationDDController = '-';
  TextEditingController signatureJustificationDGController =
      TextEditingController();
  TextEditingController signatureJustificationFinController =
      TextEditingController();
  TextEditingController signatureJustificationBudgetController =
      TextEditingController();
  TextEditingController signatureJustificationDDController =
      TextEditingController();
  String? ligneBudgtaire;
  String? resource;
  List<LigneBudgetaireModel> ligneBudgetaireList = [];

  @override
  void initState() {
    getData();
    getPlageDate();
    super.initState();
  }

  // Stocks par succursale
  List<AchatModel> achatList = [];
  // Ventes par succursale
  List<VenteCartModel> venteList = [];
  // Créance par succursale
  List<CreanceCartModel> creanceList = [];
  // Gain par succursale
  List<GainModel> gainList = [];

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '-',
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');

  Future<void> getData() async {
    UserModel data = await AuthApi().getUserId();
    List<AchatModel>? dataAchat = await AchatApi().getAllData();
    List<CreanceCartModel>? dataCreance =
        await CreanceFactureApi().getAllData();
    List<VenteCartModel>? dataVente = await VenteCartApi().getAllData();
    List<GainModel>? dataGain = await GainApi().getAllData();
    var budgets = await LIgneBudgetaireApi().getAllData();
    setState(() {
      user = data;
      ligneBudgetaireList = budgets;
      achatList = dataAchat;
      venteList = dataVente;
      creanceList = dataCreance;
      gainList = dataGain;
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
                    child: FutureBuilder<SuccursaleModel>(
                        future: SuccursaleApi().getOneData(widget.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<SuccursaleModel> snapshot) {
                          if (snapshot.hasData) {
                            SuccursaleModel? data = snapshot.data;
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
                                          title: data!.name,
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

  Widget pageDetail(SuccursaleModel data) {
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
                  TitleWidget(title: data.name.toUpperCase()),
                  Column(
                    children: [
                      Row(
                        children: [
                          PrintWidget(
                            tooltip: 'Imprimer le document',
                            onPressed: () async {},
                          )
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
              Divider(color: Colors.amber.shade700),
              infosEditeurWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(SuccursaleModel data) {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTitle(data),
          StatsSuccursale(succursaleModel: data),
          const SizedBox(
            height: 40.0,
          ),
        ],
      ),
    );
  }

  Widget headerTitle(SuccursaleModel data) {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    var dataAchatList =
        achatList.where((element) => element.succursale == data.name).toList();
    // var dataCreanceList = creanceList.where((element) => element.succursale == data.name).toList();
    // var dataVenteList = venteList.where((element) => element.succursale == data.name).toList();
    // var dataGainList = gainList.where((element) => element.succursale == data.name).toList();

    // Achat global
    double sumAchat = 0;
    var dataAchat = dataAchatList
        .map((e) => double.parse(e.priceAchatUnit) * double.parse(e.quantity))
        .toList();
    for (var data in dataAchat) {
      sumAchat += data;
    }

    // Revenues
    double sumAchatRevenue = 0;
    var dataAchatRevenue = dataAchatList
        .map((e) => double.parse(e.prixVenteUnit) * double.parse(e.quantity))
        .toList();

    for (var data in dataAchatRevenue) {
      sumAchatRevenue += data;
    }

    // Marge beneficaires
    double sumAchatMarge = 0;
    var dataAchatMarge = dataAchatList
        .map((e) =>
            (double.parse(e.prixVenteUnit) - double.parse(e.priceAchatUnit)) *
            double.parse(e.quantity))
        .toList();
    for (var data in dataAchatMarge) {
      sumAchatMarge += data;
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Province:',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText1,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                AutoSizeText(data.province,
                    maxLines: 2,
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            if (!data.adresse.contains('null'))
              Row(
                children: [
                  Text('Adresse:',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText1,
                      overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  AutoSizeText(data.adresse,
                      maxLines: 3,
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            Row(
              children: [
                Text('Investissement:',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText1,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text('${NumberFormat.decimalPattern('fr').format(sumAchat)} \$',
                    style: Responsive.isDesktop(context)
                        ? TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.pink.shade700)
                        : bodyText1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Row(
              children: [
                Text('Revenus attendus:',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText1,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(sumAchatRevenue)} \$',
                    style: Responsive.isDesktop(context)
                        ? TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.blue.shade700)
                        : bodyText1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Row(
              children: [
                Text('Marge bénéficiaires:',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText1,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(sumAchatMarge)} \$',
                    style: Responsive.isDesktop(context)
                        ? TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.green.shade700)
                        : bodyText1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Widget infosEditeurWidget(SuccursaleModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyLarge;
    final bodySmall = Theme.of(context).textTheme.bodyMedium;
    List<String> dataList = ['Approved', 'Unapproved', '-'];
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(p10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text('Directeur Générale',
                        style: bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700))),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text(
                                'Approbation',
                                style: bodySmall!
                                    .copyWith(color: Colors.red.shade700),
                              ),
                              if (data.approbationDG != '-')
                                SelectableText(
                                  data.approbationDG.toString(),
                                  style: bodyMedium.copyWith(
                                      color: Colors.red.shade700),
                                ),
                              if (data.approbationDG == '-' &&
                                  user.fonctionOccupe == 'Directeur générale')
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: p10, left: p5),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Approbation',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    ),
                                    value: approbationDGController,
                                    isExpanded: true,
                                    items: dataList.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        approbationDGController = value!;
                                        if (approbationDGController ==
                                            "Approved") {
                                          submitUpdateDG(data);
                                        }
                                      });
                                    },
                                  ),
                                )
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                'Signature',
                                style: bodySmall.copyWith(
                                    color: Colors.red.shade700),
                              ),
                              SelectableText(
                                data.signatureDG.toString(),
                                style: bodyMedium,
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                'Justification',
                                style: bodySmall.copyWith(
                                    color: Colors.red.shade700),
                              ),
                              SelectableText(
                                data.signatureJustificationDG.toString(),
                                style: bodyMedium,
                              ),
                              if (data.approbationDG == 'Unapproved' &&
                                  user.fonctionOccupe == 'Directeur générale')
                                Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p10, left: p5),
                                    child: TextFormField(
                                      controller:
                                          signatureJustificationDGController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        labelText: 'Quelque chose à dire',
                                        hintText: 'Quelque chose à dire',
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(),
                                    )),
                              if (data.approbationDG == 'Unapproved')
                                IconButton(
                                    onPressed: () {
                                      submitUpdateDG(data);
                                    },
                                    icon: const Icon(Icons.send))
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.amber.shade700,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text('Directeur de departement',
                        style: bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700))),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text(
                                'Approbation',
                                style: bodySmall.copyWith(
                                    color: Colors.blue.shade700),
                              ),
                              SelectableText(
                                data.approbationDD.toString(),
                                style: bodyMedium.copyWith(
                                    color: Colors.blue.shade700),
                              ),
                              if (data.approbationDD == '-')
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: p10, left: p5),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      // labelText: 'Approbation',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    ),
                                    value: approbationDDController,
                                    isExpanded: true,
                                    items: dataList.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        approbationDDController = value!;
                                        if (approbationDDController ==
                                            "Approved") {
                                          submitUpdateDD(data);
                                        }
                                      });
                                    },
                                  ),
                                )
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                'Signature',
                                style: bodySmall.copyWith(
                                    color: Colors.blue.shade700),
                              ),
                              SelectableText(
                                data.signatureDD.toString(),
                                style: bodyMedium,
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                'Justification',
                                style: bodySmall.copyWith(
                                    color: Colors.blue.shade700),
                              ),
                              SelectableText(
                                data.signatureJustificationDD.toString(),
                                style: bodyMedium,
                              ),
                              if (approbationDDController == 'Unapproved' &&
                                  user.fonctionOccupe ==
                                      'Directeur de departement')
                                Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p10, left: p5),
                                    child: TextFormField(
                                      controller:
                                          signatureJustificationDDController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        labelText: 'Quelque chose à dire',
                                        hintText: 'Quelque chose à dire',
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(),
                                    )),
                              if (approbationDDController == 'Unapproved' &&
                                  user.fonctionOccupe ==
                                      'Directeur de departement')
                                IconButton(
                                    onPressed: () {
                                      submitUpdateDD(data);
                                    },
                                    icon: const Icon(Icons.send))
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitUpdateDG(SuccursaleModel data) async {
    final succursale = SuccursaleModel(
        name: data.name,
        adresse: data.adresse,
        province: data.province,
        approbationDG: approbationDGController.toString(),
        signatureDG: user.matricule.toString(),
        signatureJustificationDG: signatureJustificationDGController.text,
        approbationDD: data.approbationDD.toString(),
        signatureDD: data.signatureDD.toString(),
        signatureJustificationDD: data.signatureJustificationDD.toString(),
        signature: data.signature,
        created: data.created);
    await SuccursaleApi().updateData(data.id!, succursale);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateDD(SuccursaleModel data) async {
    final succursale = SuccursaleModel(
        name: data.name,
        adresse: data.adresse,
        province: data.province,
        approbationDG: data.approbationDG.toString(),
        signatureDG: data.signatureDG.toString(),
        signatureJustificationDG: data.signatureJustificationDG.toString(),
        approbationDD: approbationDDController.toString(),
        signatureDD: user.matricule.toString(),
        signatureJustificationDD: signatureJustificationDDController.text,
        signature: data.signature,
        created: data.created);
    await SuccursaleApi().updateData(data.id!, succursale);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
