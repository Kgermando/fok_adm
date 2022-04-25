import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/devis/components/table_devis.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/priority_dropdown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class DevisPage extends StatefulWidget {
  const DevisPage({Key? key}) : super(key: key);

  @override
  State<DevisPage> createState() => _DevisPageState();
}

class _DevisPageState extends State<DevisPage> {
  final _form = GlobalKey<FormState>();
  bool isLoading = false;

  final ScrollController _controllerScrollList = ScrollController();

  late List<Map<String, dynamic>> _values;
  late String _result;

  final List<String> departementList = Dropdown().departement;
  final List<String> priorityList = PriorityDropdown().priorityDropdown;

  final TextEditingController titleController = TextEditingController();
  String? priority;
  String? departement;

  List<TextEditingController> listNbreController = [];
  List<TextEditingController> listDescriptionController = [];
  List<TextEditingController> listFraisController = [];

  late int count;

  @override
  void initState() {
    setState(() {
      getData();
      count = 0;
      _result = '';
      _values = [];
    });
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    for (final controller in listNbreController) {
      controller.dispose();
    }
    for (final controller in listDescriptionController) {
      controller.dispose();
    }
    for (final controller in listFraisController) {
      controller.dispose();
    }
    super.dispose();
  }

  String? matricule;

  Future<void> getData() async {
    final userModel = await AuthApi().getUserId();
    setState(() {
      matricule = userModel.matricule;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Nouveau devis',
            child: const Icon(Icons.add),
            onPressed: () => devisDialog()),
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
                    children: const [
                      CustomAppbar(title: 'Etat de besoin'),
                      Expanded(child: TableDevis())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  devisDialog() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(p8),
                ),
                backgroundColor: Colors.transparent,
                child: Form(
                  key: _form,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(p16),
                      child: SizedBox(
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.width,
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TitleWidget(title: 'Etat de besoin'),
                                PrintWidget(onPressed: () {})
                              ],
                            ),
                            const SizedBox(
                              height: p20,
                            ),
                            Row(
                              children: [
                                Expanded(child: titleWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: priorityWidget())
                              ],
                            ),
                            departmentWidget(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SelectableText('Devis',
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            final nbreController =
                                                TextEditingController();
                                            final descriptionController =
                                                TextEditingController();
                                            final fraisController =
                                                TextEditingController();
                                            listNbreController
                                                .add(nbreController);
                                            listDescriptionController
                                                .add(descriptionController);
                                            listFraisController
                                                .add(fraisController);
                                            count++;
                                          });
                                        },
                                        icon: const Icon(Icons.add)),
                                    if (count > 0)
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              final nbreController =
                                                  TextEditingController();
                                              final descriptionController =
                                                  TextEditingController();
                                              final fraisController =
                                                  TextEditingController();
                                              listNbreController
                                                  .remove(nbreController);
                                              listDescriptionController.remove(
                                                  descriptionController);
                                              listFraisController
                                                  .remove(fraisController);
                                              count--;
                                            });
                                          },
                                          icon: const Icon(Icons.close)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 400,
                                width: double.infinity,
                                child: coupureBilletWidget()),
                            const SizedBox(
                              height: p20,
                            ),
                            BtnWidget(
                                title: 'Soumettre',
                                isLoading: isLoading,
                                press: () {
                                  final form = _form.currentState!;
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
                ));
          });
        });
  }

  Widget titleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Titre',
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

  Widget priorityWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Priorité',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: priority,
        isExpanded: true,
        items: priorityList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            priority = value!;
          });
        },
      ),
    );
  }

  Widget departmentWidget() {
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

  Widget coupureBilletWidget() {
    return Scrollbar(
      controller: _controllerScrollList,
      isAlwaysShown: true,
      child: ListView.builder(
          controller: _controllerScrollList,
          itemCount: count,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: listNbreController[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: '${index + 1}. Nombre',
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Ce champs est obligatoire';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(),
                            ))),
                    const SizedBox(width: p10),
                    Expanded(
                        flex: 4,
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: listDescriptionController[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: '${index + 1}. Désignation',
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Ce champs est obligatoire';
                                } else {
                                  return null;
                                }
                              },
                              onEditingComplete: () {
                                onUpdate(
                                    index,
                                    listNbreController[index].text,
                                    listDescriptionController[index].text,
                                    listFraisController[index].text);
                              },
                            ))),
                    const SizedBox(width: p10),
                    Expanded(
                        flex: 2,
                        child: Container(
                            margin: const EdgeInsets.only(bottom: p20),
                            child: TextFormField(
                              controller: listFraisController[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: '${index + 1}. Montant',
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Ce champs est obligatoire';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(),
                            )))
                  ],
                ),
              ],
            );
          }),
    );
  }

  onUpdate(int key, String nombre, String description, String frais) {
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
      'nombre': nombre,
      'description': description,
      'frais': frais
    };
    _values.add(json);
    setState(() {
      _result = _prettyPrint(_values);
      print('_values $_values');
    });
  }

  String _prettyPrint(jsonObject) {
    var encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(jsonObject);
  }

  Future submit() async {
    final jsonList = _values.map((item) => jsonEncode(item)).toList();
    final devisModel = DevisModel(
        title: titleController.text,
        priority: priority.toString(),
        departement: departement.toString(),
        list: jsonList,
        ligneBudgtaire: '-',
        resources: '-',
        approbationDG: '-',
        signatureDG: '-',
        signatureJustificationDG: '-',
        approbationFin: '-',
        signatureFin: '-',
        signatureJustificationFin: '-',
        approbationBudget: '-',
        signatureBudget: '-',
        signatureJustificationBudget: '-',
        approbationDD: '-',
        signatureDD: '-',
        signatureJustificationDD: '-',
        signature: matricule.toString(),
        created: DateTime.now()
    );
    await DevisAPi().insertData(devisModel);
    Routemaster.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Envoyer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
