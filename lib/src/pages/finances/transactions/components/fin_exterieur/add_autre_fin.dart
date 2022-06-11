import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/coupure_billet_api.dart';
import 'package:fokad_admin/src/api/finances/fin_exterieur_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/coupure_billet_model.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _coupureBillertKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isCoupureBilletLoading = false;

  final TextEditingController nomCompletController = TextEditingController();
  final TextEditingController pieceJustificativeController =
      TextEditingController();
  final TextEditingController libelleController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController deperatmentController = TextEditingController();

  TextEditingController coupureBilletController = TextEditingController();
  TextEditingController nombreBilletController = TextEditingController();

  String? resourceFin;
  String? typeOperation;

  Timer? timer; 

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getData();
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
    coupureBilletController.dispose();
    nombreBilletController.dispose();
    super.dispose();
  }

  String? matricule;
  int numberItem = 0;
  List<CoupureBilletModel> coupureBilletList = [];
  Future<void> getData() async {
    final userModel = await AuthApi().getUserId();
    final data = await FinExterieurApi().getAllData();
    var coupureBillets = await CoupureBilletApi().getAllData();
    setState(() {
      matricule = userModel.matricule;
      numberItem = data.length;
      coupureBilletList = coupureBillets
          .where((element) => element.reference == numberItem + 1)
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
    final headline6 = Theme.of(context).textTheme.headline6;
    return ListView(
      children: [
        for (var item in coupureBilletList)
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white24,
                  child: Text(item.nombreBillet,
                      textAlign: TextAlign.start, style: headline6),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white24,
                  child: SelectableText(item.coupureBillet,
                      textAlign: TextAlign.start, style: headline6),
                ),
              )
            ],
          ),
        const SizedBox(height: p20),
        Form(
          key: _coupureBillertKey,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(bottom: p20),
                      child: TextFormField(
                        controller: nombreBilletController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Nombre',
                        ),
                        keyboardType: TextInputType.text,
                        style: const TextStyle(),
                      ))),
              const SizedBox(width: p10),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(bottom: p20),
                      child: TextFormField(
                        controller: coupureBilletController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Coupure billet',
                        ),
                        keyboardType: TextInputType.text,
                        style: const TextStyle(),
                      ))),
              IconButton(
                  onPressed: () {
                    setState(() {
                      isCoupureBilletLoading = true;
                    });
                    final form = _coupureBillertKey.currentState!;
                    if (form.validate()) {
                      submitCoupureBillet();
                      form.reset();
                    }
                    // setState(() {
                    //   isCoupureBilletLoading = true;
                    // });
                  },
                  icon: Icon(Icons.save, color: Colors.red.shade700))
            ],
          ),
        ),
      ],
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

  Future submit() async { 
    final financeExterieurModel = FinanceExterieurModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text, 
        typeOperation: typeOperation.toString(),
        numeroOperation: 'Transaction-Fin-$resourceFin-${numberItem + 1}', 
        signature: matricule.toString(),
        createdRef: numberItem + 1,
        created: DateTime.now());

    await FinExterieurApi().insertData(financeExterieurModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future submitCoupureBillet() async {
    final coupureBillet = CoupureBilletModel(
      reference: numberItem + 1,
      nombreBillet: nombreBilletController.text,
      coupureBillet: coupureBilletController.text);
    await CoupureBilletApi().insertData(coupureBillet);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Ajouté!"),
      backgroundColor: Colors.green[700],
    ));
  }


}