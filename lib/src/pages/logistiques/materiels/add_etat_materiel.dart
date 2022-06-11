import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/api/logistiques/etat_materiel_api.dart';
import 'package:fokad_admin/src/api/logistiques/immobiler_api.dart';
import 'package:fokad_admin/src/api/logistiques/mobilier_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/anguin_model.dart';
import 'package:fokad_admin/src/models/logistiques/etat_materiel_model.dart';
import 'package:fokad_admin/src/models/logistiques/immobilier_model.dart';
import 'package:fokad_admin/src/models/logistiques/mobilier_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddEtatMateriel extends StatefulWidget {
  const AddEtatMateriel({Key? key}) : super(key: key);

  @override
  State<AddEtatMateriel> createState() => _AddEtatMaterielState();
}

class _AddEtatMaterielState extends State<AddEtatMateriel> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // final TextEditingController nomController = TextEditingController();
  // final TextEditingController modeleController = TextEditingController();
  // final TextEditingController marqueController = TextEditingController();
  String? typeObjet;
  String? nomMateriel;
  String? statut;

  List<String> nomMaterielList = [];
  List<AnguinModel> enginList = [];
  List<MobilierModel> mobilierList = [];
  List<ImmobilierModel> immobilierList = [];

  @override
  initState() {
    setState(() {
      getData();
    });
    super.initState();
  }

  String? signature;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var engins = await AnguinApi().getAllData();
    var mobiliers = await MobilierApi().getAllData();
    var immobiliers = await ImmobilierApi().getAllData();
    setState(() {
      signature = userModel.matricule;
      enginList = engins;
      mobilierList = mobiliers;
      immobilierList = immobiliers;
    });
  }

  @override
  void dispose() {
    _controllerScroll.dispose();

    // nomController.dispose();
    // modeleController.dispose();
    // marqueController.dispose();

    super.dispose();
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
                                  title: 'Ajout état materiel',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addAgentWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addAgentWidget() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleWidget(title: "Ajout Materiel"),
                        PrintWidget(onPressed: () {})
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(child: typeObjetWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: nomMaterielWidget())
                      ],
                    ),
                    statutListWidget(),
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

  // Widget nomWidget() {
  //   return Container(
  //       margin: const EdgeInsets.only(bottom: p20),
  //       child: TextFormField(
  //         controller: nomController,
  //         decoration: InputDecoration(
  //           border:
  //               OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
  //           labelText: 'Nom',
  //         ),
  //         keyboardType: TextInputType.text,
  //         style: const TextStyle(),
  //         validator: (value) {
  //           if (value != null && value.isEmpty) {
  //             return 'Ce champs est obligatoire';
  //           } else {
  //             return null;
  //           }
  //         },
  //       ));
  // }

  // Widget modeleWidget() {
  //   return Container(
  //       margin: const EdgeInsets.only(bottom: p20),
  //       child: TextFormField(
  //         controller: modeleController,
  //         decoration: InputDecoration(
  //           border:
  //               OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
  //           labelText: 'Modèle',
  //         ),
  //         keyboardType: TextInputType.text,
  //         style: const TextStyle(),
  //         validator: (value) {
  //           if (value != null && value.isEmpty) {
  //             return 'Ce champs est obligatoire';
  //           } else {
  //             return null;
  //           }
  //         },
  //       ));
  // }

  // Widget marqueWidget() {
  //   return Container(
  //       margin: const EdgeInsets.only(bottom: p20),
  //       child: TextFormField(
  //         controller: marqueController,
  //         decoration: InputDecoration(
  //           border:
  //               OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
  //           labelText: 'Marque',
  //         ),
  //         keyboardType: TextInputType.text,
  //         style: const TextStyle(),
  //         validator: (value) {
  //           if (value != null && value.isEmpty) {
  //             return 'Ce champs est obligatoire';
  //           } else {
  //             return null;
  //           }
  //         },
  //       ));
  // }

  Widget typeObjetWidget() {
    List<String> typeObjetList = ["Engin", "Mobilier", "Immobilier"];
    var enginsMap = enginList.map((e) => e.nom).toSet().toList();
    var mobilierMap = mobilierList.map((e) => e.nom).toSet().toList();
    var immobiliersMap =
        immobilierList.map((e) => e.numeroCertificat).toSet().toList();
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type d\'Objet',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: typeObjet,
        isExpanded: true,
        items: typeObjetList
            .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toSet()
            .toList(),
        onChanged: (value) {
          setState(() {
            typeObjet = value!;
            if (typeObjet == "Engin") {
              nomMaterielList = enginsMap;
            } else if (typeObjet == "Mobilier") {
              nomMaterielList = mobilierMap;
            } else if (typeObjet == "Immobilier") {
              nomMaterielList = immobiliersMap;
            }
            print('nomMaterielList $nomMaterielList');
          });
        },
      ),
    );
  }

  Widget nomMaterielWidget() {
    
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Materiel',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: typeObjet,
        isExpanded: true,
        items: nomMaterielList
            .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toSet()
            .toList(),
        onChanged: (value) {
          setState(() {
            nomMateriel = value!;
          });
        },
      ),
    );
  }

  Widget statutListWidget() {
    List<String> statutList = ["Actif", "Inactif", "Declaser"];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Statut',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: statut,
        isExpanded: true,
        items: statutList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            statut = value!;
          });
        },
      ),
    );
  }

  Future<void> submit() async {
    final etatMaterielModel = EtatMaterielModel(
        nom: nomMateriel.toString(),
        modele: '-',
        marque: '-',
        typeObjet: typeObjet.toString(),
        statut: statut.toString(),
        signature: signature.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now());
    await EtatMaterielApi().insertData(etatMaterielModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
