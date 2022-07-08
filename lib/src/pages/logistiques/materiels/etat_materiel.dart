import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/etat_materiel_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/etat_materiel_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/components/table_etat_materiels.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class EtatMateriel extends StatefulWidget {
  const EtatMateriel({Key? key}) : super(key: key);

  @override
  State<EtatMateriel> createState() => _EtatMaterielState();
}

class _EtatMaterielState extends State<EtatMateriel> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController modeleController = TextEditingController();
  final TextEditingController marqueController = TextEditingController();
  String? typeObjet;
  String? statut;

  @override
  initState() {
    date();
    super.initState();
  }

  String? signature;
  Future<void> date() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      signature = userModel.matricule;
    });
  }

  @override
  void dispose() {
    _controllerScroll.dispose();

    nomController.dispose();
    modeleController.dispose();
    marqueController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const DrawerMenu(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            newFicheDialog();
            // Navigator.pushNamed(context, LogistiqueRoutes.logAddEtatMateriel);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppbar(
                        title: 'Etat des materiels',
                        controllerMenu: () =>
                            _key.currentState!.openDrawer()),
                    const Expanded(child: TableEtatMateriel())
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
  }

  newFicheDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Ajout Materiel'),
              content: SizedBox(
                  height: 400,
                  width: 500,
                  child: isLoading
                  ? loading()
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: nomWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: modeleWidget())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: marqueWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: typeObjetWidget())
                            ],
                          ),
                          statutListWidget(),
                          const SizedBox(
                            height: p20,
                          ),
                        ],
                      )
                    )
                  ),

              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    
                    submit();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  } 

  Widget nomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom',
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

  Widget modeleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: modeleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Modèle',
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

  Widget marqueWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: marqueController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Marque',
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

  Widget typeObjetWidget() {
    List<String> typeObjetList = ["Mobilier", "Immobilier"];
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
        items: typeObjetList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            typeObjet = value!;
          });
        },
      ),
    );
  }

  Widget statutListWidget() {
    List<String> statutList = ["Actif", "Inactif", "Déclasser"];
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
        nom: nomController.text,
        modele: modeleController.text,
        marque: marqueController.text,
        typeObjet: typeObjet.toString(),
        statut: statut.toString(),
        signature: signature.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now(), 
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await EtatMaterielApi().insertData(etatMaterielModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
