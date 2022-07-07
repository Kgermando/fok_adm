import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/produit_model_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddProModel extends StatefulWidget {
  const AddProModel({Key? key}) : super(key: key);

  @override
  State<AddProModel> createState() => _AddProModelState();
}

class _AddProModelState extends State<AddProModel> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController categorieController = TextEditingController();
  TextEditingController sousCategorie1Controller = TextEditingController();
  TextEditingController sousCategorie2Controller = TextEditingController();
  TextEditingController sousCategorie3Controller = TextEditingController();
  TextEditingController sousCategorie4Controller = TextEditingController();

  @override
  initState() {
    getData();

    super.initState();
  }

  @override
  void dispose() {
    categorieController.dispose();
    sousCategorie1Controller.dispose();
    sousCategorie2Controller.dispose();
    sousCategorie3Controller.dispose();
    sousCategorie4Controller.dispose();

    super.dispose();
  }

  String? signature;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      signature = userModel.matricule;
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
                          const SizedBox(width: p10),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Nouveau projet',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
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
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width,
                child: ListView(
                  controller: _controllerScroll,
                  children: [
                    const TitleWidget(title: "Ajout un modèle produit"),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [PrintWidget(onPressed: () {})],
                    // ),
                    const SizedBox(
                      height: p20,
                    ),
                    categorieWidget(),
                    Row(
                      children: [
                        Expanded(child: sousCategorie1Widget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: sousCategorie2Widget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: sousCategorie3Widget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: sousCategorie4Widget())
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Soumettre',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submit();
                            form.reset();
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categorieWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: categorieController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Categorie',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget sousCategorie1Widget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: sousCategorie1Controller,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Sous Categorie 1',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget sousCategorie2Widget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: sousCategorie2Controller,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Sous Categorie 2',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget sousCategorie3Widget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: sousCategorie3Controller,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'sous Categorie 3',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget sousCategorie4Widget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: sousCategorie4Controller,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Sous Categorie 4',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Future<void> submit() async {
    final idProductform =
        "${categorieController.text}-${sousCategorie1Controller.text}-${sousCategorie2Controller.text}-${sousCategorie3Controller.text}-${sousCategorie4Controller.text}";
    final productModel = ProductModel(
      categorie: categorieController.text,
      sousCategorie1: sousCategorie1Controller.text,
      sousCategorie2: sousCategorie2Controller.text,
      sousCategorie3: sousCategorie3Controller.text,
      sousCategorie4: sousCategorie4Controller.text,
      idProduct: idProductform,
      signature: signature.toString(),
      created: DateTime.now(),
      approbationDD: '-',
      motifDD: '-',
      signatureDD: '-'
    );
    await ProduitModelApi().insertData(productModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
