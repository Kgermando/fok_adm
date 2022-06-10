import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/fin_exterieur_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/fin_exterieur_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/type_operation.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddAutreFin extends StatefulWidget {
  const AddAutreFin({ Key? key }) : super(key: key);

  @override
  State<AddAutreFin> createState() => _AddAutreFinState();
}

class _AddAutreFinState extends State<AddAutreFin> {
   final GlobalKey<ScaffoldState> _key = GlobalKey();
  final controller = ScrollController();
  final ScrollController _controllerBillet = ScrollController();
  final _formKey = GlobalKey<FormState>();

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
  String? resourceFin;
  String? typeOperation;

  final List<String> typeCaisse = TypeOperation().typeVereCaisse;

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
    final data = await FinExterieurApi().getAllData();
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
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                            width: 20.0,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ),
                          const SizedBox(
                            width: p10,
                          ),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Autre Financement',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: addPageWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }


  Widget addPageWidget() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: SizedBox(
                width: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width / 1.5
                    : MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        TitleWidget(title: "Ajout Fin."),
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
                    typeOperationWidget(),
                    if (count == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Coupure billet", style: headline6),
                          IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  final coupureBillet = TextEditingController();
                                  final nombreBillet = TextEditingController();
                                  nombreBilletControllerList.add(nombreBillet);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BtnWidget(
                            title: 'Soumettre',
                            isLoading: isLoading,
                            press: () {
                              final form = _formKey.currentState!;
                              if (form.validate()) {
                                submit();
                                form.reset();
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
                if (count >= 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        // width: double.infinity,
                        child: Card(
                            elevation: 10,
                            color: Colors.red.shade700,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SelectableText(
                                "Note: Ajoutez un champ en plus (+1) pour enregistrer le precedent",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ),
                    ],
                  )
              ],
            );
          }),
    );
  }

  Widget resourcesWidget() {
    List<String> resourceList = ['finPropre', 'finExterieur'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Resources Financières',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: resourceFin,
        isExpanded: true,
        items: resourceList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            resourceFin = value!;
          });
        },
      ),
    );
  }

  Widget typeOperationWidget() {
    List<String> typeOperationList = ['Financement interne', 'Financement externe'];
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
        items: typeOperationList.map((String value) {
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

  Future submit() async {
    final jsonList = _values.map((item) => jsonEncode(item)).toList();
    final financeExterieurModel = FinanceExterieurModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text,
        coupureBillet: jsonList,
        ligneBudgtaire: '-',
        typeOperation: typeOperation.toString(),
        numeroOperation: 'Transaction-Fin-$resourceFin-${numberItem + 1}',
        ressourceFin: resourceFin.toString(),
        signature: matricule.toString(),
        created: DateTime.now());

    await FinExterieurApi().insertData(financeExterieurModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

}