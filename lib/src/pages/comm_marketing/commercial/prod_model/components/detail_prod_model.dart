import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/produit_model_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/components/update_prod_model.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class DetailProdModel extends StatefulWidget {
  const DetailProdModel({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailProdModel> createState() => _DetailProdModelState();
}

class _DetailProdModelState extends State<DetailProdModel> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

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

  @override
  initState() {
    getData();
    super.initState();
  }

  List<StocksGlobalMOdel> stockGlobalList = [];
  ProductModel? productModel;
  UserModel? user = UserModel(
      nom: '-',
      prenom: '-',
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
    UserModel userModel = await AuthApi().getUserId();
    ProductModel data = await ProduitModelApi().getOneData(widget.id);
    List<StocksGlobalMOdel> stoksGlobal = await StockGlobalApi().getAllData();
    setState(() {
      productModel = data;
      stockGlobalList = stoksGlobal;
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      UpdateProModel(productModel: productModel!)));
            }),
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
                    child: FutureBuilder<ProductModel>(
                        future: ProduitModelApi().getOneData(widget.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<ProductModel> snapshot) {
                          if (snapshot.hasData) {
                            ProductModel? data = snapshot.data;
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
                                          title: data!.categorie,
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

  Widget pageDetail(ProductModel data) {
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
                  TitleWidget(title: data.categorie),
                  Column(
                    children: [
                      Row(
                        children: [
                          // if (!deleteIdProduct) editButton(data),
                          // if (!deleteIdProduct) deleteButton(data),
                          PrintWidget(
                              tooltip: 'Imprimer le document', onPressed: () {})
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              infosEditeurWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget editButton(ProductModel data) {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.red.shade700),
      tooltip: "Modification",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de modifier ceci?'),
          content:
              const Text('Cette action permet de supprimer définitivement.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UpdateProModel(productModel: data)));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteButton(ProductModel data) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade700),
      tooltip: "Supprimer",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de modifier ceci?'),
          content:
              const Text('Cette action permet de supprimer définitivement.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await ProduitModelApi().deleteData(data.id!);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Supprimer avec succès!"),
                  backgroundColor: Colors.red[700],
                ));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataWidget(ProductModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Identifiant Produit :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.idProduct,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Categorie Produit :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.categorie,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Sous Categorie 1:',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.sousCategorie1,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Sous Categorie 2:',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.sousCategorie2,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Sous Categorie 3:',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.sousCategorie3,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Sous Categorie 4:',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.sousCategorie4,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
          Row(
            children: [
              Expanded(
                child: Text('Signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: Colors.amber.shade700),
        ],
      ),
    );
  }

  Widget infosEditeurWidget(ProductModel data) {
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
            if (user!.departement != "Commercial et Marketing")
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
                                    user!.fonctionOccupe ==
                                        'Directeur générale')
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
                                if (data.approbationDG == 'Unapproved' &&
                                    data.signatureDG != '-')
                                  SelectableText(
                                    data.signatureJustificationDG.toString(),
                                    style: bodyMedium,
                                  ),
                                if (data.approbationDG == 'Unapproved' &&
                                    user!.fonctionOccupe ==
                                        'Directeur générale')
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
                                          labelText: 'Motifs...',
                                          hintText: 'Motifs...',
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
            if (user!.departement != "Commercial et Marketing")
              Divider(
                color: Colors.amber.shade700,
              ),
            if (user!.departement != "Commercial et Marketing")
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Text('Directeur de Finance',
                          style: bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700))),
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
                                      .copyWith(color: Colors.green.shade700),
                                ),
                                if (data.approbationFin != '-')
                                  SelectableText(
                                    data.approbationFin.toString(),
                                    style: bodyMedium.copyWith(
                                        color: Colors.green.shade700),
                                  ),
                                if (data.approbationFin == '-' &&
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
                                  style: bodySmall.copyWith(
                                      color: Colors.green.shade700),
                                ),
                                SelectableText(
                                  data.signatureFin.toString(),
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
                                      color: Colors.green.shade700),
                                ),
                                if (data.approbationFin == 'Unapproved' &&
                                    data.signatureFin != '-')
                                  SelectableText(
                                    data.signatureJustificationFin.toString(),
                                    style: bodyMedium,
                                  ),
                                if (data.approbationFin == 'Unapproved' &&
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
                                          labelText: 'Motifs...',
                                          hintText: 'Motifs...',
                                        ),
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(),
                                      )),
                                if (data.approbationFin == 'Unapproved')
                                  IconButton(
                                      onPressed: () {
                                        submitUpdateFIN(data);
                                      },
                                      icon: const Icon(Icons.send))
                              ],
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            if (user!.departement != "Commercial et Marketing")
              Divider(
                color: Colors.amber.shade700,
              ),
            if (user!.departement != "Commercial et Marketing")
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Text('Budget',
                          style: bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700))),
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
                                      .copyWith(color: Colors.orange.shade700),
                                ),
                                if (data.approbationBudget != '-')
                                  SelectableText(
                                    data.approbationBudget.toString(),
                                    style: bodyMedium.copyWith(
                                        color: Colors.orange.shade700),
                                  ),
                                if (data.approbationBudget == '-' &&
                                    user!.fonctionOccupe ==
                                        'Directeur de budget')
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
                              ],
                            )),
                        Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  'Signature',
                                  style: bodySmall.copyWith(
                                      color: Colors.orange.shade700),
                                ),
                                SelectableText(
                                  data.signatureBudget.toString(),
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
                                      color: Colors.orange.shade700),
                                ),
                                if (data.approbationBudget == 'Unapproved' &&
                                    data.signatureBudget != '-')
                                  SelectableText(
                                    data.signatureJustificationBudget
                                        .toString(),
                                    style: bodyMedium,
                                  ),
                                if (data.approbationBudget == 'Unapproved' &&
                                    user!.fonctionOccupe ==
                                        'Directeur de budget')
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
                                          labelText: 'Motifs...',
                                          hintText: 'Motifs...',
                                        ),
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(),
                                      )),
                                if (data.approbationBudget == 'Unapproved')
                                  IconButton(
                                      onPressed: () {
                                        submitUpdateBudget(data);
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
                        style: bodyMedium!.copyWith(
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
                                style: bodySmall!
                                    .copyWith(color: Colors.blue.shade700),
                              ),
                              if (data.approbationDD != '-')
                                SelectableText(
                                  data.approbationDD.toString(),
                                  style: bodyMedium,
                                ),
                              if (data.approbationDD == '-')
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: p10, left: p5),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
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
                              // if (data.approbationDD == 'Approved')
                              SelectableText(
                                data.signatureJustificationDD.toString(),
                                style: bodyMedium,
                              ),
                              if (approbationDDController == 'Unapproved' &&
                                  user!.fonctionOccupe ==
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
                                        labelText: 'Motifs...',
                                        hintText: 'Motifs...',
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(),
                                    )),
                              if (approbationDDController == 'Unapproved' &&
                                  user!.fonctionOccupe ==
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

  Future<void> submitUpdateDG(ProductModel data) async {
    final productModel = ProductModel(
        categorie: data.categorie,
        sousCategorie1: data.sousCategorie1,
        sousCategorie2: data.sousCategorie2,
        sousCategorie3: data.sousCategorie3,
        sousCategorie4: data.sousCategorie4,
        idProduct: data.idProduct,
        approbationDG: approbationDGController.toString(),
        signatureDG: user!.matricule.toString(),
        signatureJustificationDG:
            (signatureJustificationDGController.text == "")
                ? '-'
                : signatureJustificationDGController.text,
        approbationFin: data.approbationFin.toString(),
        signatureFin: data.signatureFin.toString(),
        signatureJustificationFin: data.signatureJustificationFin.toString(),
        approbationBudget: data.approbationBudget.toString(),
        signatureBudget: data.signatureBudget.toString(),
        signatureJustificationBudget:
            data.signatureJustificationBudget.toString(),
        approbationDD: data.approbationDD.toString(),
        signatureDD: data.signatureDD.toString(),
        signatureJustificationDD: data.signatureJustificationDD.toString(),
        signature: data.signature,
        created: data.created);
    await ProduitModelApi().updateData(data.id!, productModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateFIN(ProductModel data) async {
    final productModel = ProductModel(
        categorie: data.categorie,
        sousCategorie1: data.sousCategorie1,
        sousCategorie2: data.sousCategorie2,
        sousCategorie3: data.sousCategorie3,
        sousCategorie4: data.sousCategorie4,
        idProduct: data.idProduct,
        approbationDG: data.approbationDG.toString(),
        signatureDG: data.signatureDG.toString(),
        signatureJustificationDG: data.signatureJustificationDG.toString(),
        approbationFin: approbationFinController.toString(),
        signatureFin: user!.matricule.toString(),
        signatureJustificationFin:
            (signatureJustificationFinController.text == "")
                ? '-'
                : signatureJustificationFinController.text,
        approbationBudget: data.approbationBudget.toString(),
        signatureBudget: data.signatureBudget.toString(),
        signatureJustificationBudget:
            data.signatureJustificationBudget.toString(),
        approbationDD: data.approbationDD.toString(),
        signatureDD: data.signatureDD.toString(),
        signatureJustificationDD: data.signatureJustificationDD.toString(),
        signature: data.signature,
        created: data.created);
    await ProduitModelApi().updateData(data.id!, productModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateBudget(ProductModel data) async {
    final productModel = ProductModel(
        categorie: data.categorie,
        sousCategorie1: data.sousCategorie1,
        sousCategorie2: data.sousCategorie2,
        sousCategorie3: data.sousCategorie3,
        sousCategorie4: data.sousCategorie4,
        idProduct: data.idProduct,
        approbationDG: data.approbationDG.toString(),
        signatureDG: data.signatureDG.toString(),
        signatureJustificationDG: data.signatureJustificationDG.toString(),
        approbationFin: data.approbationFin.toString(),
        signatureFin: data.signatureFin.toString(),
        signatureJustificationFin: data.signatureJustificationFin.toString(),
        approbationBudget: approbationBudgetController.toString(),
        signatureBudget: user!.matricule.toString(),
        signatureJustificationBudget:
            (signatureJustificationBudgetController.text == "")
                ? '-'
                : signatureJustificationBudgetController.text,
        approbationDD: data.approbationDD.toString(),
        signatureDD: data.signatureDD.toString(),
        signatureJustificationDD: data.signatureJustificationDD.toString(),
        signature: data.signature,
        created: data.created);
    await ProduitModelApi().updateData(data.id!, productModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitUpdateDD(ProductModel data) async {
    final productModel = ProductModel(
        categorie: data.categorie,
        sousCategorie1: data.sousCategorie1,
        sousCategorie2: data.sousCategorie2,
        sousCategorie3: data.sousCategorie3,
        sousCategorie4: data.sousCategorie4,
        idProduct: data.idProduct,
        approbationDG: data.approbationDG.toString(),
        signatureDG: data.signatureDG.toString(),
        signatureJustificationDG: data.signatureJustificationDG.toString(),
        approbationFin: data.approbationFin.toString(),
        signatureFin: data.signatureFin.toString(),
        signatureJustificationFin: data.signatureJustificationFin.toString(),
        approbationBudget: data.approbationBudget.toString(),
        signatureBudget: data.signatureBudget.toString(),
        signatureJustificationBudget:
            data.signatureJustificationBudget.toString(),
        approbationDD: approbationDDController.toString(),
        signatureDD: user!.matricule.toString(),
        signatureJustificationDD:
            (signatureJustificationDDController.text == "")
                ? '-'
                : signatureJustificationDDController.text,
        signature: data.signature.toString(),
        created: data.created);

    await ProduitModelApi().updateData(data.id!, productModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
