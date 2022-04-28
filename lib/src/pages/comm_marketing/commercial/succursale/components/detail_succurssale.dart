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
import 'package:fokad_admin/src/widgets/button_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class DetailSuccursale extends StatefulWidget {
  const DetailSuccursale({Key? key, required this.succursaleModel})
      : super(key: key);
  final SuccursaleModel succursaleModel;

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

  UserModel? user;
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
      achatList = dataAchat
          .where((element) => element.succursale == widget.succursaleModel.name)
          .toList();
      creanceList = dataCreance
          .where((element) => element.succursale == widget.succursaleModel.name)
          .toList();
      venteList = dataVente
          .where((element) => element.succursale == widget.succursaleModel.name)
          .toList();
      gainList = dataGain
          .where((element) => element.succursale == widget.succursaleModel.name)
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
                    child: Column(
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
                                  title: widget.succursaleModel.name,
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer()),
                            ),
                          ],
                        ),
                        Expanded(
                            child: Scrollbar(
                                controller: _controllerScroll,
                                isAlwaysShown: true,
                                child: pageDetail()))
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail() {
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
                          PrintWidget(
                            tooltip: 'Imprimer le document',
                            onPressed: () async {},
                          )
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yy")
                              .format(widget.succursaleModel.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(),
              infosEditeurWidget(),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget() {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: dataRangeFilter(),
          ),
          const SizedBox(
            height: 10.0,
          ),
          statsSuccursaleWidgetTitle(),
          StatsSuccursale(succursaleModel: widget.succursaleModel),
          const SizedBox(
            height: 40.0,
          ),
        ],
      ),
    );
  }

  Widget headerTitle() {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    // Achat global
    double sumAchat = 0;
    var dataAchat = achatList
        .map((e) => double.parse(e.priceAchatUnit) * double.parse(e.quantity))
        .toList();
    for (var data in dataAchat) {
      sumAchat += data;
    }

    // Revenues
    double sumAchatRevenue = 0;
    var dataAchatRevenue = achatList
        .map((e) => double.parse(e.prixVenteUnit) * double.parse(e.quantity))
        .toList();

    for (var data in dataAchatRevenue) {
      sumAchatRevenue += data;
    }

    // Marge beneficaires
    double sumAchatMarge = 0;
    var dataAchatMarge = achatList
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
            Text(widget.succursaleModel.name.toUpperCase(),
                style: Responsive.isDesktop(context)
                    ? const TextStyle(fontWeight: FontWeight.w600, fontSize: 30)
                    : headline6!.copyWith(color: Colors.teal)),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Text('Province:',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText1,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                AutoSizeText(widget.succursaleModel.province,
                    maxLines: 2,
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            if (!widget.succursaleModel.adresse.contains('null'))
              Row(
                children: [
                  Text('Adresse:',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText1,
                      overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  AutoSizeText(widget.succursaleModel.adresse,
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
                        ? const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: primaryColor)
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
                            color: Colors.purple.shade700)
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

  Widget dataRangeFilter() {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      child: ButtonWidget(
        text: getPlageDate(),
        onClicked: () => setState(() {
          pickDateRange(context);
          FocusScope.of(context).requestFocus(FocusNode());
        }),
      ),
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }

  Widget statsSuccursaleWidgetTitle() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'STATISTIQUES GLOBAL',
            textAlign: TextAlign.center,
            style: Responsive.isDesktop(context)
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
                : const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  Widget infosEditeurWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    List<String> dataList = ['Approved', 'Unapproved'];
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Directeur Générale',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
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
                              style: bodySmall,
                            ),
                            if (widget.succursaleModel.approbationDG != '-')
                              SelectableText(
                                widget.succursaleModel.approbationDG.toString(),
                                style: bodyMedium.copyWith(
                                    color: Colors.red.shade700),
                              ),
                            if (widget.succursaleModel.approbationDG == '-' &&
                                user!.fonctionOccupe == 'Directeur générale')
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
                              style: bodySmall,
                            ),
                            SelectableText(
                              widget.succursaleModel.signatureDG.toString(),
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
                              style: bodySmall,
                            ),
                            if (widget.succursaleModel.approbationDG ==
                                    'Unapproved' &&
                                widget.succursaleModel.signatureDG != '-')
                              SelectableText(
                                widget.succursaleModel.signatureJustificationDG
                                    .toString(),
                                style: bodyMedium,
                              ),
                            if (widget.succursaleModel.approbationDG ==
                                    'Unapproved' &&
                                user!.fonctionOccupe == 'Directeur générale')
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
                            if (widget.succursaleModel.approbationDG ==
                                'Unapproved')
                              IconButton(
                                  onPressed: () {
                                    submitUpdateDG();
                                  },
                                  icon: const Icon(Icons.send))
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Directeur de Finance',
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold))),
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
                              style: bodySmall,
                            ),
                            if (widget.succursaleModel.approbationFin != '-')
                              SelectableText(
                                widget.succursaleModel.approbationFin
                                    .toString(),
                                style: bodyMedium.copyWith(
                                    color: Colors.green.shade700),
                              ),
                            if (widget.succursaleModel.approbationFin == '-' &&
                                user!.fonctionOccupe ==
                                    'Directeur des finances')
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
                                  value: approbationFinController,
                                  isExpanded: true,
                                  items: dataList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      approbationFinController = value!;
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
                              style: bodySmall,
                            ),
                            SelectableText(
                              widget.succursaleModel.signatureFin.toString(),
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
                              style: bodySmall,
                            ),
                            if (widget.succursaleModel.approbationFin ==
                                    'Unapproved' &&
                                widget.succursaleModel.signatureFin != '-')
                              SelectableText(
                                widget.succursaleModel.signatureJustificationFin
                                    .toString(),
                                style: bodyMedium,
                              ),
                            if (widget.succursaleModel.approbationFin ==
                                    'Unapproved' &&
                                user!.fonctionOccupe ==
                                    'Directeur des finances')
                              Container(
                                  margin: const EdgeInsets.only(
                                      bottom: p10, left: p5),
                                  child: TextFormField(
                                    controller:
                                        signatureJustificationFinController,
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
                            if (widget.succursaleModel.approbationFin ==
                                'Unapproved')
                              IconButton(
                                  onPressed: () {
                                    submitUpdateFIN();
                                  },
                                  icon: const Icon(Icons.send))
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Budget',
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold))),
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
                              style: bodySmall,
                            ),
                            if (widget.succursaleModel.approbationBudget != '-')
                              SelectableText(
                                widget.succursaleModel.approbationBudget
                                    .toString(),
                                style: bodyMedium.copyWith(
                                    color: Colors.orange.shade700),
                              ),
                            if (widget.succursaleModel.approbationBudget ==
                                    '-' &&
                                user!.fonctionOccupe == 'Directeur de budget')
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
                                  value: approbationBudgetController,
                                  isExpanded: true,
                                  items: dataList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      approbationBudgetController = value!;
                                    });
                                  },
                                ),
                              ),
                            if (widget.succursaleModel.approbationBudget ==
                                    '-' &&
                                user!.fonctionOccupe == 'Directeur de budget')
                              Row(
                                children: [
                                  Expanded(child: ligneBudgtaireWidget()),
                                  Expanded(child: ligneBudgtaireWidget())
                                ],
                              )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'Signature',
                              style: bodySmall,
                            ),
                            SelectableText(
                              widget.succursaleModel.signatureBudget.toString(),
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
                              style: bodySmall,
                            ),
                            if (widget.succursaleModel.approbationBudget ==
                                    'Unapproved' &&
                                widget.succursaleModel.signatureBudget != '-')
                              SelectableText(
                                widget.succursaleModel
                                    .signatureJustificationBudget
                                    .toString(),
                                style: bodyMedium,
                              ),
                            if (widget.succursaleModel.approbationBudget ==
                                    'Unapproved' &&
                                user!.fonctionOccupe == 'Directeur de budget')
                              Container(
                                  margin: const EdgeInsets.only(
                                      bottom: p10, left: p5),
                                  child: TextFormField(
                                    controller:
                                        signatureJustificationBudgetController,
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
                            if (widget.succursaleModel.approbationBudget ==
                                'Unapproved')
                              IconButton(
                                  onPressed: () {
                                    submitUpdateBudget();
                                  },
                                  icon: const Icon(Icons.send))
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Directeur de département',
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold))),
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
                              style: bodySmall,
                            ),
                            if (widget.succursaleModel.approbationDD != '-' &&
                                user!.fonctionOccupe ==
                                    'Directeur de département')
                              SelectableText(
                                widget.succursaleModel.approbationDD.toString(),
                                style: bodyMedium.copyWith(
                                    color: Colors.blue.shade700),
                              ),
                            if (widget.succursaleModel.approbationDD == '-')
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
                              style: bodySmall,
                            ),
                            SelectableText(
                              widget.succursaleModel.signatureDD.toString(),
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
                              style: bodySmall,
                            ),
                            if (widget.succursaleModel.approbationDD ==
                                    'Unapproved' &&
                                widget.succursaleModel.signatureDD != '-')
                              SelectableText(
                                widget.succursaleModel.signatureJustificationDD
                                    .toString(),
                                style: bodyMedium,
                              ),
                            if (widget.succursaleModel.approbationDD ==
                                    'Unapproved' &&
                                user!.fonctionOccupe ==
                                    'Directeur de département')
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
                            if (widget.succursaleModel.approbationDD ==
                                'Unapproved')
                              IconButton(
                                  onPressed: () {
                                    submitUpdateDD();
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
    );
  }

  Widget ligneBudgtaireWidget() {
    var dataList =
        ligneBudgetaireList.map((e) => e.nomLigneBudgetaire).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Ligne Budgetaire',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: ligneBudgtaire,
        isExpanded: true,
        items: dataList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            ligneBudgtaire = value!;
          });
        },
      ),
    );
  }

  Widget resourcesWidget() {
    List<String> dataList = ['caisse', 'banque', 'finPropre', 'finExterieur'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Ligne Budgetaire',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: resource,
        isExpanded: true,
        items: dataList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            resource = value!;
          });
        },
      ),
    );
  }

  Future<void> submitUpdateDG() async {
    final succursaleModel = SuccursaleModel(
        name: widget.succursaleModel.name,
        adresse: widget.succursaleModel.adresse,
        province: widget.succursaleModel.province,
        approbationDG: approbationDGController.toString(),
        signatureDG: user!.matricule.toString(),
        signatureJustificationDG: signatureJustificationDGController.text,
        approbationFin: widget.succursaleModel.approbationFin.toString(),
        signatureFin: widget.succursaleModel.signatureFin.toString(),
        signatureJustificationFin:
            widget.succursaleModel.signatureJustificationFin.toString(),
        approbationBudget: widget.succursaleModel.approbationBudget.toString(),
        signatureBudget: widget.succursaleModel.signatureBudget.toString(),
        signatureJustificationBudget:
            widget.succursaleModel.signatureJustificationBudget.toString(),
        approbationDD: widget.succursaleModel.approbationDD.toString(),
        signatureDD: widget.succursaleModel.signatureDD.toString(),
        signatureJustificationDD:
            widget.succursaleModel.signatureJustificationDD.toString(),
        signature: widget.succursaleModel.signature,
        created: widget.succursaleModel.created);
    await SuccursaleApi().updateData(widget.succursaleModel.id!, succursaleModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateFIN() async {
    final succursaleModel = SuccursaleModel(
        name: widget.succursaleModel.name,
        adresse: widget.succursaleModel.adresse,
        province: widget.succursaleModel.province,
       approbationDG: widget.succursaleModel.approbationDG.toString(),
        signatureDG: widget.succursaleModel.signatureDG.toString(),
        signatureJustificationDG:
            widget.succursaleModel.signatureJustificationDG.toString(),
        approbationFin: approbationFinController.toString(),
        signatureFin: user!.matricule.toString(),
        signatureJustificationFin: signatureJustificationFinController.text,
        approbationBudget: widget.succursaleModel.approbationBudget.toString(),
        signatureBudget: widget.succursaleModel.signatureBudget.toString(),
        signatureJustificationBudget:
            widget.succursaleModel.signatureJustificationBudget.toString(),
        approbationDD: widget.succursaleModel.approbationDD.toString(),
        signatureDD: widget.succursaleModel.signatureDD.toString(),
        signatureJustificationDD:
            widget.succursaleModel.signatureJustificationDD.toString(),
        signature: widget.succursaleModel.signature,
        created: widget.succursaleModel.created);
    await SuccursaleApi().updateData(widget.succursaleModel.id!, succursaleModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateBudget() async {
    final succursaleModel = SuccursaleModel(
        name: widget.succursaleModel.name,
        adresse: widget.succursaleModel.adresse,
        province: widget.succursaleModel.province,
        approbationDG: widget.succursaleModel.approbationDG.toString(),
        signatureDG: widget.succursaleModel.signatureDG.toString(),
        signatureJustificationDG:
            widget.succursaleModel.signatureJustificationDG.toString(),
        approbationFin: widget.succursaleModel.approbationFin.toString(),
        signatureFin: widget.succursaleModel.signatureFin.toString(),
        signatureJustificationFin:
            widget.succursaleModel.signatureJustificationFin.toString(),
        approbationBudget: approbationBudgetController.toString(),
        signatureBudget: user!.matricule.toString(),
        signatureJustificationBudget:
            signatureJustificationBudgetController.text,
        approbationDD: widget.succursaleModel.approbationDD.toString(),
        signatureDD: widget.succursaleModel.signatureDD.toString(),
        signatureJustificationDD:
            widget.succursaleModel.signatureJustificationDD.toString(),
        signature: widget.succursaleModel.signature,
        created: widget.succursaleModel.created);
    await SuccursaleApi().updateData(widget.succursaleModel.id!, succursaleModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateDD() async {
    final succursaleModel = SuccursaleModel(
        name: widget.succursaleModel.name,
        adresse: widget.succursaleModel.adresse,
        province: widget.succursaleModel.province,
        approbationDG: widget.succursaleModel.approbationDG.toString(),
        signatureDG: widget.succursaleModel.signatureDG.toString(),
        signatureJustificationDG:
            widget.succursaleModel.signatureJustificationDG.toString(),
        approbationFin: widget.succursaleModel.approbationFin.toString(),
        signatureFin: widget.succursaleModel.signatureFin.toString(),
        signatureJustificationFin:
            widget.succursaleModel.signatureJustificationFin.toString(),
        approbationBudget: widget.succursaleModel.approbationBudget.toString(),
        signatureBudget: widget.succursaleModel.signatureBudget.toString(),
        signatureJustificationBudget:
            widget.succursaleModel.signatureJustificationBudget.toString(),
        approbationDD: approbationDDController.toString(),
        signatureDD: user!.matricule.toString(),
        signatureJustificationDD: signatureJustificationDDController.text,
        signature: widget.succursaleModel.signature,
        created: widget.succursaleModel.created);
    await SuccursaleApi().updateData(widget.succursaleModel.id!, succursaleModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
