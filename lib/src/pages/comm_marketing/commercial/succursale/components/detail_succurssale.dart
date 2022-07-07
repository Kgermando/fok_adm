import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/creance_facture_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/gain_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/vente_cart_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/creance_cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/gain_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/vente_cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/stats_succusale.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailSuccursale extends StatefulWidget {
  const DetailSuccursale({Key? key}) : super(key: key);

  @override
  State<DetailSuccursale> createState() => _DetailSuccursaleState();
}

class _DetailSuccursaleState extends State<DetailSuccursale> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  DateTimeRange? dateRange;

  String getPlageDate() {
    if (dateRange == null) {
      return 'Filtre par plage de date';
    } else {
      return '${DateFormat('dd/MM/yyyy').format(dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(dateRange!.end)}';
    }
  }

  // Approbations
  String approbationDG = '-';
  String approbationDD = '-';
  TextEditingController motifDGController = TextEditingController();
  TextEditingController motifDDController = TextEditingController();

  @override
  void initState() {
    getData();
    getPlageDate();
    super.initState();
  }

  @override
  void dispose() {
    motifDGController.dispose();
    motifDDController.dispose();
    super.dispose();
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
      role: '5',
      isOnline: 'false',
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
    setState(() {
      user = data;
      achatList = dataAchat;
      venteList = dataVente;
      creanceList = dataCreance;
      gainList = dataGain;
    });
  }

  @override
  Widget build(BuildContext context) {
    SuccursaleModel succursaleModel =
        ModalRoute.of(context)!.settings.arguments as SuccursaleModel;
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
                        future: SuccursaleApi().getOneData(succursaleModel.id!),
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
                                              Navigator.pop(context),
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
                                    child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      pageDetail(data),
                                      const SizedBox(height: p10),
                                      approbationWidget(data)
                                    ],
                                  ),
                                ))
                              ],
                            );
                          } else {
                            return Center(child: loading());
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
          child: Column(
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
                            onPressed: () {},
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

  Widget approbationWidget(SuccursaleModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          height: 200,
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add_task, color: Colors.green.shade700)),
                ],
              ),
              const SizedBox(height: p20),
              Row(
                children: [
                  const Expanded(flex: 1, child: Text("Directeur générale")),
                  const SizedBox(width: p20),
                  if (data.approbationDG != '-')
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Approbation"),
                                  const SizedBox(height: p20),
                                  Text(data.approbationDG),
                                ],
                              )),
                          if (data.approbationDG == "Unapproved")
                            Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    const Text("Motif"),
                                    const SizedBox(height: p20),
                                    Text(data.motifDG),
                                  ],
                                )),
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Signature"),
                                  const SizedBox(height: p20),
                                  Text(data.signatureDG),
                                ],
                              )),
                        ])),
                  if (data.approbationDG == '-' &&
                      user.fonctionOccupe == "Directeur générale")
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(child: approbationDGWidget(data)),
                          Expanded(child: motifDGWidget(data))
                        ])),
                ],
              ),
              const SizedBox(height: p20),
              Row(
                children: [
                  const Expanded(
                      flex: 1, child: Text("Directeur de departement")),
                  const SizedBox(width: p20),
                  if (data.approbationDD != '-')
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Approbation"),
                                  const SizedBox(height: p20),
                                  Text(data.approbationDD),
                                ],
                              )),
                          if (data.approbationDD == "Unapproved")
                            Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    const Text("Motif"),
                                    const SizedBox(height: p20),
                                    Text(data.motifDD),
                                  ],
                                )),
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Signature"),
                                  const SizedBox(height: p20),
                                  Text(data.signatureDD),
                                ],
                              )),
                        ])),
                  if (data.approbationDD == '-' &&
                      user.fonctionOccupe == "Directeur de departement")
                    Expanded(
                        flex: 4,
                        child: Row(children: [
                          Expanded(child: approbationDDWidget(data)),
                          Expanded(child: motifDDWidget(data))
                        ])),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget approbationDGWidget(SuccursaleModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Approbation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: approbationDG,
        isExpanded: true,
        items: approbationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            approbationDG = value!;
            if (approbationDG == "Approved") {
              submitDG(data);
            }
          });
        },
      ),
    );
  }

  Widget motifDGWidget(SuccursaleModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifDGController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ecrivez le motif...',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: 'Soumettre le Motif',
                  onPressed: () {
                    submitDG(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  Widget approbationDDWidget(SuccursaleModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Approbation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: approbationDD,
        isExpanded: true,
        items: approbationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            approbationDD = value!;
            if (approbationDD == "Approved") {
              submitDD(data);
            }
          });
        },
      ),
    );
  }

  Widget motifDDWidget(SuccursaleModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifDDController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ecrivez le motif...',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: 'Soumettre le Motif',
                  onPressed: () {
                    submitDD(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  Future<void> submitDG(SuccursaleModel data) async {
    final succursale = SuccursaleModel(
      id: data.id!,
        name: data.name,
        adresse: data.adresse,
        province: data.province,
        signature: data.signature,
        created: data.created,
        approbationDG: approbationDG,
        motifDG: (motifDGController.text == '') ? '-' : motifDGController.text,
        signatureDG: user.matricule,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD
    ); 
    await SuccursaleApi().updateData(succursale);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitDD(SuccursaleModel data) async {
    final succursale = SuccursaleModel(
      id: data.id!,
        name: data.name,
        adresse: data.adresse,
        province: data.province,
        signature: data.signature,
        created: data.created,
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: approbationDD,
        motifDD: (motifDDController.text == '') ? '-' : motifDDController.text,
        signatureDD: user.matricule
      ); 
    await SuccursaleApi().updateData(succursale);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
