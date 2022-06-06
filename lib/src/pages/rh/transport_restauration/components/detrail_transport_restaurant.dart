import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/trans_rest_agents_api.dart';
import 'package:fokad_admin/src/api/rh/transport_restaurant_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailTransportRestaurant extends StatefulWidget {
  const DetailTransportRestaurant({Key? key}) : super(key: key);

  @override
  State<DetailTransportRestaurant> createState() =>
      _DetailTransportRestaurantState();
}

class _DetailTransportRestaurantState extends State<DetailTransportRestaurant> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isChecked = false;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController montantController = TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    matriculeController.dispose();
    montantController.dispose();
    super.dispose();
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
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  List<TransRestAgentsModel> transRestAgentsList = [];
  List<TransRestAgentsModel> transRestAgentsFilter = [];
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var transRestAgents = await TransRestAgentsApi().getAllData();
    setState(() {
      user = userModel;
      transRestAgentsFilter = transRestAgents;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<TransportRestaurationModel>(
            future: TransportRestaurationApi().getOneData(id),
            builder: (BuildContext context,
                AsyncSnapshot<TransportRestaurationModel> snapshot) {
              if (snapshot.hasData) {
                TransportRestaurationModel? data = snapshot.data;
                return FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      detailAgentDialog(data!);
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
                    child: FutureBuilder<TransportRestaurationModel>(
                        future: TransportRestaurationApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<TransportRestaurationModel>
                                snapshot) {
                          if (snapshot.hasData) {
                            TransportRestaurationModel? data = snapshot.data;
                            transRestAgentsList = transRestAgentsFilter
                                .where((element) =>
                                    element.reference.microsecondsSinceEpoch ==
                                    data!.createdRef.microsecondsSinceEpoch)
                                .toList();
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
                                          title: "Liste des payements",
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

  Widget pageDetail(TransportRestaurationModel data) {
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
                  TitleWidget(title: data.title),
                  Column(                                                                         
                    children: [
                      Row(
                        children: [
                          // IconButton(
                          //     onPressed: () {
                          //       Navigator.pushNamed(
                          //           context, RhRoutes.rhTransportRest);
                          //     },
                          //     icon: const Icon(Icons.refresh)),
                          PrintWidget(
                              tooltip: 'Imprimer le document', onPressed: () {}),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              tableListAgents(data)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(TransportRestaurationModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Intitlé :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.title,
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
                child: Text(
                  'Observation',
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: p10,
              ),
              if (!data.observation && user.departement == "Finances")
              Expanded(
                  flex: 3, child: checkboxRead(data)),
              Expanded(
                flex: 3,
                  child: (data.observation)
                      ? SelectableText(
                          'Payé',
                          style: bodyMedium.copyWith(
                              color: Colors.greenAccent.shade700),
                        )
                      : SelectableText(
                          'Non payé',
                          style: bodyMedium.copyWith(
                              color: Colors.redAccent.shade700),
                        ))
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Signature:',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.amber.shade700,
          ),
        ],
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.green;
  }

  checkboxRead(TransportRestaurationModel data) {
    isChecked = data.observation;
    return ListTile(
      leading: Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isLoading = true;
          });
          setState(() {
            isChecked = value!;
            submitObservation(data);
          });
          setState(() {
            isLoading = false;
          });
        },
      ),
      title: const Text("Confirmation de payement"),
    );
  }

  Widget tableListAgents(TransportRestaurationModel data) {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Table(
        border: TableBorder.all(),
        children: [
          tableRowHeader(),
          for (var item in transRestAgentsList) tableRow(item)
        ],
      ),
    );
  }

  TableRow tableRowHeader() {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Nom"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Prenom"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Matricule"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Montant"),
      ),
    ]);
  }

  TableRow tableRow(TransRestAgentsModel item) {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText(item.nom),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText(item.prenom),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText(item.matricule),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(double.parse(item.montant))} \$"),
      ),
    ]);
  }

  detailAgentDialog(TransportRestaurationModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Infos detail'),
              content: SizedBox(
                  height: 200,
                  width: 500,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: nomWidget()),
                            const SizedBox(
                              width: p10,
                            ),
                            Expanded(child: prenomWidget())
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: matriculeWidget()),
                            const SizedBox(
                              width: p10,
                            ),
                            Expanded(child: matriculeWidget())
                          ],
                        ),
                      ],
                    ),
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                     final form = _formKey.currentState!;
                    if (form.validate()) {
                      submitTransRestAgents(data);
                      form.reset();
                    }
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
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget prenomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: prenomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Prenom',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget matriculeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: matriculeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Matricule',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
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
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Future<void> submitObservation(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        title: data.title,
        observation: isChecked,
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now());
    await TransportRestaurationApi().updateData(data.id!, transRest);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Soumis avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }

  Future<void> submitTransRestAgents(TransportRestaurationModel data) async {
    final transRest = TransRestAgentsModel(
      reference: data.createdRef,
      nom: nomController.text,
      prenom: prenomController.text,
      matricule: matriculeController.text,
      montant: montantController.text
    );
    await TransRestAgentsApi().insertData(transRest);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Ajouté avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
