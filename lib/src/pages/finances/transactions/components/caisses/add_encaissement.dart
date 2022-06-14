import 'dart:async'; 

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/caisse_api.dart';
import 'package:fokad_admin/src/api/finances/coupure_billet_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/caisse_model.dart';
import 'package:fokad_admin/src/models/finances/coupure_billet_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/utils/type_operation.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddEncaissement extends StatefulWidget {
  const AddEncaissement({ Key? key }) : super(key: key);

  @override
  State<AddEncaissement> createState() => _AddEncaissementState();
}

class _AddEncaissementState extends State<AddEncaissement> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final controller = ScrollController(); 
  final _formEncaissement = GlobalKey<FormState>();
  final _coupureBillertKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isCoupureBilletLoading = false;
  bool isLoadingDelete = false;

  TextEditingController nomCompletController = TextEditingController();
  TextEditingController pieceJustificativeController = TextEditingController();
  TextEditingController libelleController = TextEditingController();
  TextEditingController montantController = TextEditingController();
  TextEditingController deperatmentController = TextEditingController();
  String? departement;

  TextEditingController coupureBilletController = TextEditingController();
  TextEditingController nombreBilletController = TextEditingController();

  final List<String> typeCaisse = TypeOperation().typeVereCaisse;
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
    final data = await CaisseApi().getAllData();
    var coupureBillets = await CoupureBilletApi().getAllData();
    if(!mounted) return;
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
                                  title: 'Caisse',
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
      key: _formEncaissement,
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
                        TitleWidget(title: "Bon d'encaissement"),
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
                              final form = _formEncaissement.currentState!;
                              if (form.validate()) {
                                submitEncaissement();
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
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Form(
      key: _coupureBillertKey,
      child: ListView(
        children: [
          Table(
            border: TableBorder.all(color: Colors.amber.shade700),
            children: [
              TableRow(children: [
                Container(
                  padding: const EdgeInsets.all(p8),
                  child: Text("Nombre",
                      textAlign: TextAlign.center, style: headline6),
                ),
                Container(
                  padding: const EdgeInsets.all(p8),
                  child: Text("Billet",
                      textAlign: TextAlign.center, style: headline6),
                ),
                Container(
                  padding: const EdgeInsets.all(p8),
                  child: Text("Retirer",
                      textAlign: TextAlign.center, style: headline6),
                ),
              ]),
              for (var item in coupureBilletList)
                TableRow(children: [
                  Container(
                    padding: const EdgeInsets.all(p8),
                    child: Text(item.nombreBillet,
                        textAlign: TextAlign.center, style: bodyLarge),
                  ),
                  Container(
                    padding: const EdgeInsets.all(p8),
                    child: Text("${item.coupureBillet} \$",
                        textAlign: TextAlign.center, style: bodyLarge),
                  ),
                  Container(
                      padding: const EdgeInsets.all(p8),
                      child: (isLoadingDelete)
                          ? SizedBox(
                              height: p20, width: p20, child: loadingMini())
                          : IconButton(
                              onPressed: () async {
                                setState(() {
                                  isLoadingDelete = true;
                                });
                                await CoupureBilletApi().deleteData(item.id!).then((value) {
                                  setState(() {
                                    isLoadingDelete = false;
                                  });
                                });
                              },
                              icon: const Icon(Icons.close, color: Colors.red)))
                ]),
              TableRow(children: [
                Container(
                    padding: const EdgeInsets.all(p8),
                    child: TextFormField(
                      controller: nombreBilletController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        labelText: 'Ajoutez le nombre ici',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: const TextStyle(),
                    )),
                Container(
                    padding: const EdgeInsets.all(p8),
                    child: TextFormField(
                      controller: coupureBilletController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        labelText: 'Ajoutez la coupure de billet ici',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: const TextStyle(),
                    )),
                Container(
                    padding: const EdgeInsets.all(p8),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            isCoupureBilletLoading = true;
                          });
                          final form = _coupureBillertKey.currentState!;
                          if (form.validate()) {
                            submitCoupureBillet();
                            form.reset();
                          }
                        },
                        icon: Icon(Icons.save,
                            size: 40.0, color: Colors.red.shade700))),
              ]),
            ],
          ),
          const SizedBox(height: p20),
        ],
      ),
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

  

  Future submitEncaissement() async { 
    final caisseModel = CaisseModel(
      nomComplet: nomCompletController.text,
      pieceJustificative: pieceJustificativeController.text,
      libelle: libelleController.text,
      montant: montantController.text, 
      departement: '-',
      typeOperation: 'Encaissement',
      numeroOperation: 'Transaction-Caisse-${numberItem + 1}',
      signature: matricule.toString(),
      createdRef: numberItem + 1,
      created: DateTime.now());
    await CaisseApi().insertData(caisseModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Encaissement effectué avec succès!"),
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