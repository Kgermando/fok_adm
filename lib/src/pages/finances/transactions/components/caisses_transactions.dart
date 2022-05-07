import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/caisse_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/caisse_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/components/caisses/table_caisse.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/type_operation.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class CaisseTransactions extends StatefulWidget {
  const CaisseTransactions({Key? key}) : super(key: key);

  @override
  State<CaisseTransactions> createState() => _CaisseTransactionsState();
}

class _CaisseTransactionsState extends State<CaisseTransactions> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final controller = ScrollController();
  final ScrollController _controllerBillet = ScrollController();

  final _form = GlobalKey<FormState>();
  final _formEncaissement = GlobalKey<FormState>();

  bool isLoading = false;

  final TextEditingController nomCompletController = TextEditingController();
  final TextEditingController pieceJustificativeController =
      TextEditingController();
  final TextEditingController libelleController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController deperatmentController = TextEditingController();

  List<TextEditingController> coupureBilletControllerList = [];
  List<TextEditingController> nombreBilletControllerList = [];
  String? ligneBudgtaire;
  String? departement;
  // String? typeOperation;

  final List<String> typeCaisse = TypeOperation().typeVereCaisse;
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

  String? matricule;
  int numberItem = 0;

  Future<void> getData() async {
    final userModel = await AuthApi().getUserId();
    final data = await CaisseApi().getAllData();
    setState(() {
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
                          title: 'Livre de Caisse',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableCaisse())
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
          label: 'Décaissement',
          onPressed: () {
            setState(() {
              transactionsDialogDecaissement();
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.file_download),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Encaissement',
          onPressed: () => transactionsDialogEncaissement(),
        ),
      ],
    );
  }

  transactionsDialogEncaissement() {
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
                  key: _formEncaissement,
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
                                const TitleWidget(title: 'Bon d\'encaissement'),
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
                            ligneBudgtaireWidget(),
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
                                height: 300,
                                width: double.infinity,
                                child: coupureBilletWidget()),
                            const SizedBox(
                              height: p20,
                            ),
                            BtnWidget(
                                title: 'Soumettre',
                                isLoading: isLoading,
                                press: () {
                                  final form = _formEncaissement.currentState!;
                                  if (form.validate()) {
                                    submitEncaissement();
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

  transactionsDialogDecaissement() {
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
                                const TitleWidget(title: 'Bon de décaissement'),
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
                            Row(
                              children: [
                                Expanded(child: ligneBudgtaireWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: deperatmentWidget())
                              ],
                            ),
                            const SizedBox(
                              width: p10,
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
                                height: 300,
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
                                    submitDecaissement();
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Montant',
                ),
                keyboardType: TextInputType.text,
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

  Widget ligneBudgtaireWidget() {
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
        items: typeCaisse.map((String value) {
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

  Widget deperatmentWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'departement',
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

  Future submitEncaissement() async {
    final caisseModel = CaisseModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text,
        coupureBillet: [],
        ligneBudgtaire: '-',
        resources: '-',
        departement: '-',
        typeOperation: 'Encaissement',
        numeroOperation: 'Transaction-Caisse-${numberItem + 1}',
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
    await CaisseApi().insertData(caisseModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future submitDecaissement() async {
    final jsonList = _values.map((item) => jsonEncode(item)).toList();
    final caisseModel = CaisseModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text,
        coupureBillet: jsonList,
        ligneBudgtaire: '-',
        resources: '-',
        departement: '-',
        typeOperation: 'Decaissement',
        numeroOperation: 'Transaction-Caisse-${numberItem + 1}',
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
    await CaisseApi().insertData(caisseModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
