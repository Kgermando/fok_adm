import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/finances/banque_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/finances/banque_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/components/banques/table_banque.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/type_operation.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class BanqueTransactions extends StatefulWidget {
  const BanqueTransactions({Key? key}) : super(key: key);

  @override
  State<BanqueTransactions> createState() => _BanqueTransactionsState();
}

class _BanqueTransactionsState extends State<BanqueTransactions> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final controller = ScrollController();
  final ScrollController _controllerBillet = ScrollController();
  final _form = GlobalKey<FormState>();
  final _formRetrait = GlobalKey<FormState>();

  bool isLoading = false;

  final TextEditingController nomCompletController = TextEditingController();
  final TextEditingController pieceJustificativeController =
      TextEditingController();
  final TextEditingController libelleController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController deperatmentController = TextEditingController();

  List<TextEditingController> coupureBilletControllerList = [];
  List<TextEditingController> nombreBilletControllerList = [];
  // String? ligneBudgtaire;
  String? departement;
  String? typeOperation;
  // String? resources;

  final List<String> typeCaisse = TypeOperation().typeVereCaisse;
  final List<String> typeBanque = TypeOperation().typeVereBanque;
  final List<String> typeBanqueRetraitDepot =
      TypeOperation().typeBanqueRetraitDepot;
  final List<String> departementList = Dropdown().departement;

  late List<Map<String, dynamic>> _values;
  late String result;

  late int count;

  @override
  void initState() {
    setState(() {
      getData();
      count = 0;
      result = '';
      _values = [];
    });
    super.initState();
  }

  @override
  void dispose() {
    nomCompletController.dispose();
    pieceJustificativeController.dispose();
    libelleController.dispose();
    montantController.dispose();
    deperatmentController.dispose();
    for (final controller in coupureBilletControllerList) {
      controller.dispose();
    }
    for (final controller in nombreBilletControllerList) {
      controller.dispose();
    }
    super.dispose();
  }

  List<LigneBudgetaireModel> ligneBudgetaireList = [];
  String? matricule;
  int numberItem = 0;

  Future<void> getData() async {
    final userModel = await AuthApi().getUserId();
    final data = await BanqueApi().getAllData();
    final ligneBudgetaire = await LIgneBudgetaireApi().getAllData();
    setState(() {
      ligneBudgetaireList = ligneBudgetaire;
      matricule = userModel.matricule;
      numberItem = data.length;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppbar(
                          title: 'Transactions Banque',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableBanque())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

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
          child: const Icon(Icons.upload),
          foregroundColor: Colors.black,
          backgroundColor: Colors.yellow.shade700,
          label: 'Retrait',
          onPressed: () {
            setState(() {
              transactionsDialogRetrait();
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.file_download),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Dépôt',
          onPressed: () => transactionsDialogDepot(),
        ),
      ],
    );
  }

  transactionsDialogDepot() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(p8),
                ),
                backgroundColor: Colors.transparent,
                child: Form(
                  key: _form,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(p16),
                      child: SizedBox(
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.width,
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TitleWidget(
                                    title: 'Bordereau de versement'),
                                PrintWidget(onPressed: () {})
                              ],
                            ),
                            const SizedBox(
                              height: p20,
                            ),
                            Row(
                              children: [
                                Expanded(child: nomCompletWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: pieceJustificativeWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: libelleWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: montantWidget())
                              ],
                            ),
                            if (count == 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          final coupureBillet =
                                              TextEditingController();
                                          final nombreBillet =
                                              TextEditingController();
                                          nombreBilletControllerList
                                              .add(nombreBillet);
                                          coupureBilletControllerList
                                              .add(coupureBillet);
                                          count++;
                                        });
                                      })
                                ],
                              ),
                            SizedBox(
                                height: 400,
                                width: double.infinity,
                                child: coupureBilletWidget()),
                            const SizedBox(
                              height: p20,
                            ),
                            BtnWidget(
                                title: 'Soumettre',
                                isLoading: isLoading,
                                press: () {
                                  final form = _form.currentState!;
                                  if (form.validate()) {
                                    submitDepot();
                                    form.reset();
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  transactionsDialogRetrait() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(p8),
                ),
                backgroundColor: Colors.transparent,
                child: Form(
                  key: _formRetrait,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(p16),
                      child: SizedBox(
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.width,
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TitleWidget(
                                    title: 'Bordereau de retrait'),
                                PrintWidget(onPressed: () {})
                              ],
                            ),
                            const SizedBox(
                              height: p20,
                            ),
                            Row(
                              children: [
                                Expanded(child: nomCompletWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: pieceJustificativeWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: libelleWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: montantWidget())
                              ],
                            ),
                            deperatmentWidget(),
                            // Row(
                            //   children: [
                            //     Expanded(child: ligneBudgtaireWidget()),
                            //     const SizedBox(
                            //       width: p10,
                            //     ),
                            //     Expanded(child: resourcesWidget())
                            //   ],
                            // ),
                            if (count == 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          final coupureBillet =
                                              TextEditingController();
                                          final nombreBillet =
                                              TextEditingController();
                                          nombreBilletControllerList
                                              .add(nombreBillet);
                                          coupureBilletControllerList
                                              .add(coupureBillet);
                                          count++;
                                        });
                                      })
                                ],
                              ),
                            SizedBox(
                                height: 400,
                                width: double.infinity,
                                child: coupureBilletWidget()),
                            const SizedBox(
                              height: p20,
                            ),
                            BtnWidget(
                                title: 'Soumettre',
                                isLoading: isLoading,
                                press: () {
                                  final form = _formRetrait.currentState!;
                                  if (form.validate()) {
                                    submitRetrait();
                                    form.reset();
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  Widget nomCompletWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomCompletController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom complet',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget pieceJustificativeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: pieceJustificativeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'N° de la pièce justificative',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget libelleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: libelleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Libellé',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget montantWidget() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: TextFormField(
                controller: montantController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Montant',
                ),
                validator: (value) => value != null && value.isEmpty
                    ? 'Ce champs est obligatoire.'
                    : null,
                style: const TextStyle(),
              ),
            ),
            const SizedBox(width: p20),
            Expanded(
                flex: 1,
                child: Text(
                  "\$",
                  style: headline6!,
                ))
          ],
        ));
  }

  Widget coupureBilletWidget() {
    return Scrollbar(
      controller: _controllerBillet,
      isAlwaysShown: true,
      child: ListView.builder(
          controller: _controllerBillet,
          itemCount: count,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectableText('Coupure de billet',
                        style: Theme.of(context).textTheme.bodyText2),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                final coupureBillet = TextEditingController();
                                final nombreBillet = TextEditingController();
                                nombreBilletControllerList.add(nombreBillet);
                                coupureBilletControllerList.add(coupureBillet);
                                count++;
                                onUpdate(
                                    index,
                                    nombreBilletControllerList[index].text,
                                    coupureBilletControllerList[index].text);
                              });
                            },
                            icon: const Icon(Icons.add)),
                        if (count > 0)
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  final coupureBillet = TextEditingController();
                                  final nombreBillet = TextEditingController();
                                  nombreBilletControllerList
                                      .remove(nombreBillet);
                                  coupureBilletControllerList
                                      .remove(coupureBillet);
                                  count--;
                                });
                              },
                              icon: const Icon(Icons.close)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: nombreBilletControllerList[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: '${index + 1}. Nombre',
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(),
                            ))),
                    const SizedBox(width: p10),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: coupureBilletControllerList[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: '${index + 1}. Coupure billet',
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(),
                            )))
                  ],
                ),
              ],
            );
          }),
    );
  }

  Widget deperatmentWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Département',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: departement,
        isExpanded: true,
        items: departementList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            departement = value!;
          });
        },
      ),
    );
  }

  Widget typeOperationWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type d\'Operation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: typeOperation,
        isExpanded: true,
        items: typeBanque.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            typeOperation = value!;
          });
        },
      ),
    );
  }

  Widget typeOperationWidgetRetrait() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type d\'Operation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: typeOperation,
        isExpanded: true,
        items: typeBanque.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            typeOperation = value!;
          });
        },
      ),
    );
  }

  onUpdate(int key, String nombreBillet, String coupureBillet) {
    int foundKey = -1;
    for (var map in _values) {
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundKey = key;
          break;
        }
      }
    }

    if (-1 != foundKey) {
      _values.removeWhere((map) {
        return map['id'] == foundKey;
      });
    }
    Map<String, dynamic> json = { 
      'id': key,
      'nombreBillet': nombreBillet,
      'coupureBillet': coupureBillet
    };
    _values.add(json);
    setState(() {
      result = _prettyPrint(_values);
    });
  }

  String _prettyPrint(jsonObject) {
    var encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(jsonObject);
  }

  Future submitDepot() async {
    final jsonList = _values.map((item) => jsonEncode(item)).toList();
    final banqueModel = BanqueModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text,
        coupureBillet: jsonList,
        ligneBudgtaire: '-',
        resources: '-',
        departement: '-',
        typeOperation: 'Depot',
        numeroOperation: 'FOKAD-Banque-${numberItem + 1}',
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
        signature: matricule.toString(),
        created: DateTime.now());
    await BanqueApi().insertData(banqueModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Dépôt effectué avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future submitRetrait() async {
    final jsonList = _values.map((item) => jsonEncode(item)).toList();
    final banqueModel = BanqueModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text,
        coupureBillet: jsonList,
        ligneBudgtaire: '-',
        resources: '-',
        departement: departement.toString(),
        typeOperation: 'Retrait',
        numeroOperation: 'Transaction-Banque-${numberItem + 1}',
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
        signature: matricule.toString(),
        created: DateTime.now());
    await BanqueApi().insertData(banqueModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Retrait soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
