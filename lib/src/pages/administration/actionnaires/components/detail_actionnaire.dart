import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/administration/actionnaire_api.dart';
import 'package:fokad_admin/src/api/administration/actionnaire_cotisation_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/administrations/actionnaire_cotisation_model.dart';
import 'package:fokad_admin/src/models/administrations/actionnaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

final _lightColors = [
  Colors.pinkAccent.shade700,
  Colors.tealAccent.shade700,
  Colors.amber.shade700,
  Colors.lightGreen.shade700,
  Colors.lightBlue.shade700,
  Colors.orange.shade700,
];

class DetailActionnaire extends StatefulWidget {
  const DetailActionnaire({Key? key}) : super(key: key);

  @override
  State<DetailActionnaire> createState() => _DetailActionnaireState();
}

class _DetailActionnaireState extends State<DetailActionnaire> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isLoadingCotisations = false;

  TextEditingController montantController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController moyenPayementController = TextEditingController();
  TextEditingController numeroTransactionController = TextEditingController();

  Timer? timer;

  @override
  initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getData();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();

    montantController.dispose();
    noteController.dispose();
    moyenPayementController.dispose();
    numeroTransactionController.dispose();

    super.dispose();
  }

  List<ActionnaireCotisationModel> actionnaireCotisationList = [];
  String? signature;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var actionnaireCotisations = await ActionnaireCotisationApi().getAllData();
      if(mounted) {
        setState(() {
          setState(() {
            isLoadingCotisations = true;
          });
          signature = userModel.matricule;
          actionnaireCotisationList = actionnaireCotisations;
          setState(() {
            isLoadingCotisations = false;
          });
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<ActionnaireModel>(
            future: ActionnaireApi().getOneData(id),
            builder: (BuildContext context,
                AsyncSnapshot<ActionnaireModel> snapshot) {
              if (snapshot.hasData) {
                ActionnaireModel? data = snapshot.data;
                return FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      newDialog(data!);
                    });
              } else {
                return loadingMini();
              }
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
                    child: FutureBuilder<ActionnaireModel>(
                        future: ActionnaireApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<ActionnaireModel> snapshot) {
                          if (snapshot.hasData) {
                            ActionnaireModel? data = snapshot.data;
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
                                          title: "Actionnaires",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: pageDetail(data!)))
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

  Widget pageDetail(ActionnaireModel data) {
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
                  TitleWidget(title: data.matricule),
                  SelectableText(
                      DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                      textAlign: TextAlign.start)
                ],
              ),
              dataWidget(data),
              const TitleWidget(title: "Cotisations"),
              SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: listRapportWidget(data)),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(ActionnaireModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    double total = 0.0;

    var cotisationList = actionnaireCotisationList
        .where((element) => element.reference == data.id)
        .toList();

    for (var element in cotisationList) {
      total += double.parse(element.montant);
    }

    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text('Nom :',
                  textAlign: TextAlign.start,
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
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
              flex: 1,
              child: Text('Post-Nom :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: SelectableText(data.postNom,
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
              flex: 1,
              child: Text('Prénom:',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: SelectableText(data.prenom,
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
              flex: 1,
              child: Text('Matricule :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: SelectableText(data.matricule,
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
              flex: 1,
              child: Text('Email :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: SelectableText(data.email,
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
              flex: 1,
              child: Text('Téléphone :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: SelectableText(data.telephone,
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
              flex: 1,
              child: Text('Adresse :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: SelectableText(data.adresse,
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
              flex: 1,
              child: Text('Sexe :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: SelectableText(data.sexe,
                  textAlign: TextAlign.start, style: bodyMedium),
            )
          ],
        ),
        const SizedBox(height: p20),
        Divider(
          color: Colors.red.shade700,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text('Montant total :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: SelectableText(
                  "${NumberFormat.decimalPattern('fr').format(total)} \$",
                  textAlign: TextAlign.start,
                  style: headline6!.copyWith(color: Colors.red.shade700)),
            )
          ],
        ),
        Divider(
          color: Colors.red.shade700,
        ),
      ]),
    );
  }

  Widget listRapportWidget(ActionnaireModel data) {
    var dataList = actionnaireCotisationList
        .where((element) => element.reference == data.id)
        .toList();
    return isLoadingCotisations
      ? loading()
      : dataList.isEmpty 
        ? const Center(child: Text("Pas encore de cotisations")) 
        : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final cotisation = dataList[index];
          return buildRapport(cotisation, index);
        }
      );
  }

  Widget buildRapport(ActionnaireCotisationModel data, int index) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final color = _lightColors[index % _lightColors.length];

    return Card(
      elevation: 2,
      child: ListTile(
        dense: true,
        onLongPress: () {
          detailDialog(data);
        },
        leading: Icon(Icons.monetization_on, color: color),
        title: SelectableText(timeago.format(data.created, locale: 'fr_short'),
            textAlign: TextAlign.start,
            style: bodyLarge!.copyWith(color: color)),
        subtitle: SelectableText(data.signature, style: bodyLarge),
        trailing: SelectableText(
            "${NumberFormat.decimalPattern('fr').format(double.parse(data.montant))} \$",
            textAlign: TextAlign.start,
            style: headline6!.copyWith(color: Colors.red.shade700)),
      ),
    );
  }

  detailDialog(ActionnaireCotisationModel data) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Ajout Cotisation'),
              content: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText("Nom",
                            style: bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(
                        child: SelectableText(data.nom, style: bodyLarge),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText("Post-Nom",
                            style: bodyLarge.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(
                        child: SelectableText(data.postNom, style: bodyLarge),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText("Prénom",
                            style: bodyLarge.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(
                        child: SelectableText(data.prenom, style: bodyLarge),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText("Matricule",
                            style: bodyLarge.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(
                        child: SelectableText(data.matricule, style: bodyLarge),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText("Montant",
                            style: bodyLarge.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(
                        child: SelectableText(
                            "${NumberFormat.decimalPattern('fr').format(double.parse(data.montant))} \$",
                            style: bodyLarge),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText("Note",
                            style: bodyLarge.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(
                        child: SelectableText(data.note, style: bodyLarge),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText("Moyen de Payement",
                            style: bodyLarge.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(
                        child: SelectableText(data.moyenPayement,
                            style: bodyLarge),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText("Numero Transaction",
                            style: bodyLarge.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(
                        child: SelectableText(data.numeroTransaction,
                            style: bodyLarge),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText("Signature",
                            style: bodyLarge.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(
                        child: SelectableText(data.signature, style: bodyLarge),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText("Date",
                            style: bodyLarge.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: p10,
                      ),
                      Expanded(
                        child: SelectableText(
                            DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                            style: bodyLarge),
                      )
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'ok'),
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  newDialog(ActionnaireModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Ajout Cotisation'),
              content: SizedBox(
                  height: 400,
                  width: 400,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(child: montantWidget()),
                                  const SizedBox(
                                    width: p10,
                                  ),
                                  Expanded(child: noteWidget())
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: moyenPayementWidget()),
                                  const SizedBox(
                                    width: p10,
                                  ),
                                  Expanded(child: numeroTransactionWidget())
                                ],
                              ),
                              const SizedBox(
                                height: p20,
                              ),
                            ],
                          ))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    isLoading = true;
                    submit(data);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget montantWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: montantController,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Montant',
              hintText: 'Montant'),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
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

  Widget noteWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: noteController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Note ou remarque',
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

  Widget moyenPayementWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: moyenPayementController,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Moyen de Payement',
              hintText: "PayPal, virement, mobile money"),
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

  Widget numeroTransactionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: numeroTransactionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Numéro de Transaction',
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

  Future<void> submit(ActionnaireModel data) async {
    final cotisation = ActionnaireCotisationModel(
        reference: data.id!,
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        matricule: data.matricule,
        montant: montantController.text,
        note: noteController.text,
        moyenPayement: moyenPayementController.text,
        numeroTransaction: numeroTransactionController.text,
        signature: signature.toString(),
        created: DateTime.now());
    await ActionnaireCotisationApi().insertData(cotisation);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
