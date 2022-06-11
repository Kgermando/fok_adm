import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/banque_api.dart';
import 'package:fokad_admin/src/api/finances/coupure_billet_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/banque_model.dart';
import 'package:fokad_admin/src/models/finances/coupure_billet_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/type_operation.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddRetratBanque extends StatefulWidget {
  const AddRetratBanque({ Key? key }) : super(key: key);

  @override
  State<AddRetratBanque> createState() => _AddRetratBanqueState();
}

class _AddRetratBanqueState extends State<AddRetratBanque> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final controller = ScrollController(); 
  final _formKey = GlobalKey<FormState>();
  final _coupureBillertKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isCoupureBilletLoading = false;

TextEditingController nomCompletController = TextEditingController();
  TextEditingController pieceJustificativeController = TextEditingController();
  TextEditingController libelleController = TextEditingController();
  TextEditingController montantController = TextEditingController();
  TextEditingController deperatmentController = TextEditingController();
  String? departement;

  TextEditingController coupureBilletController = TextEditingController();
  TextEditingController nombreBilletController = TextEditingController();

  final List<String> typeBanque = TypeOperation().typeVereBanque;
  final List<String> typeBanqueRetraitDepot =
      TypeOperation().typeBanqueRetraitDepot;
  final List<String> departementList = Dropdown().departement;

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
    timer!.cancel();
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
    final data = await BanqueApi().getAllData();
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
                                  title: 'Banque',
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
                        TitleWidget(title: "Bordereau retrait"),
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
                    SizedBox(
                        height: 500,
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
                                submitRetrait();
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
 

  Future submitRetrait() async { 
    final banqueModel = BanqueModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text, 
        departement: departement.toString(),
        typeOperation: 'Retrait',
        numeroOperation: "Transaction-Banque-${numberItem + 1}",
        signature: matricule.toString(),
        createdRef: numberItem + 1,
        created: DateTime.now());
    await BanqueApi().insertData(banqueModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Retrait effectué avec succès!"),
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