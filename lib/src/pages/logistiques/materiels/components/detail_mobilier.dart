import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/mobilier_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/mobilier_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart'; 
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailMobilier extends StatefulWidget {
  const DetailMobilier({Key? key}) : super(key: key);

  @override
  State<DetailMobilier> createState() => _DetailMobilierState();
}

class _DetailMobilierState extends State<DetailMobilier> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  // Approbations
  String approbationDD = '-';
  TextEditingController motifDDController = TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: 'false',
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');

  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
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
                    child: FutureBuilder<MobilierModel>(
                        future: MobilierApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<MobilierModel> snapshot) {
                          if (snapshot.hasData) {
                            MobilierModel? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: p20,
                                      child: IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: data!.nom,
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: Column(
                                  children: [
                                    pageDetail(data),
                                    const SizedBox(height: p10),
                                    approbationWidget(data)
                                  ],
                                )))
                              ],
                            );
                          } else {
                            return Center(child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(MobilierModel data) {
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: data.modele),
                  Column(
                    children: [
                      if (int.parse(user.role) <= 3)
                      Row(
                        children: [
                          // IconButton(
                          //     tooltip: 'Modifier',
                          //     onPressed: () {
                          //       Navigator.pushNamed(
                          //           context,
                          //           LogistiqueRoutes
                          //               .logMobilierMaterielUpdate,
                          //           arguments: data);
                          //     },
                          //     icon: const Icon(Icons.edit)),
                          IconButton(
                              tooltip: 'Supprimer',
                              onPressed: () async { 
                                alertDeleteDialog(data);
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red.shade700),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data)
            ],
          ),
        ),
      ),
    ]);
  }

  alertDeleteDialog(MobilierModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Etes-vous s??r de vouloir faire ceci ?'),
              content: const SizedBox(
                  height: 100,
                  width: 100,
                  child: Text("Cette action permet de supprimer le document")),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () async {
                    await MobilierApi().deleteData(data.id!);
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget dataWidget(MobilierModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Nom Complet :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.nom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Mod??le :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.modele,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Marque :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.marque,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Description :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.descriptionMobilier,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Nombre :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.nombre,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
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
        ],
      ),
    );
  }

  Widget approbationWidget(MobilierModel data) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        color: Colors.red[50],
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.red.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add_task, color: Colors.green.shade700)),
                ],
              ),
              const SizedBox(height: p20),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                            Text("Directeur de departement", style: bodyLarge)),
                    const SizedBox(width: p20),
                    Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Approbation"),
                                      const SizedBox(height: p20),
                                      Text(data.approbationDD,
                                          style: bodyLarge!.copyWith(
                                              color: Colors.green.shade700)),
                                    ],
                                  )),
                              if (data.approbationDD == "Unapproved")
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        const Text("Motif"),
                                        const SizedBox(height: p20),
                                        Text(data.motifDD),
                                      ],
                                    )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Signature"),
                                      const SizedBox(height: p20),
                                      Text(data.signatureDD),
                                    ],
                                  )),
                            ]),
                            if (data.approbationDD == '-' &&
                                user.fonctionOccupe ==
                                    "Directeur de departement")
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Row(children: [
                                  Expanded(child: approbationDDWidget(data)),
                                  const SizedBox(width: p20),
                                  if (approbationDD == "Unapproved")
                                    Expanded(child: motifDDWidget(data))
                                ]),
                              ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget approbationDDWidget(MobilierModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Approbation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: approbationDD,
        isExpanded: true,
        items: approbationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            approbationDD = value!;
            if (approbationDD == "Approved") {
              submitDD(data);
            }
          });
        },
      ),
    );
  }

  Widget motifDDWidget(MobilierModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifDDController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ecrivez le motif...',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: 'Soumettre le Motif',
                  onPressed: () {
                    submitDD(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  Future<void> submitDD(MobilierModel data) async {
    final mobilierModel = MobilierModel(
      id: data.id!,
        nom: data.nom,
        modele: data.modele,
        marque: data.marque,
        descriptionMobilier: data.descriptionMobilier,
        nombre: data.nombre,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        approbationDD: approbationDD,
        motifDD: (motifDDController.text == '') ? '-' : motifDDController.text,
        signatureDD: user.matricule); 
    await MobilierApi().updateData(mobilierModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succ??s!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
