import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/priority_dropdown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddDevis extends StatefulWidget {
  const AddDevis({Key? key}) : super(key: key);

  @override
  State<AddDevis> createState() => _AddDevisState();
}

class _AddDevisState extends State<AddDevis> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final ScrollController _controllerScrollList = ScrollController();

  late List<Map<String, dynamic>> _values;
  late String result;

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
      result = '';
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
                                  title: 'Etat de besoin',
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
                        TitleWidget(title: "Ajout besion"),
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
                            style: Theme.of(context).textTheme.bodyText2),
                        if (count == 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      final nbreController =
                                          TextEditingController();
                                      final descriptionController =
                                          TextEditingController();
                                      final fraisController =
                                          TextEditingController();
                                      listNbreController.add(nbreController);
                                      listDescriptionController
                                          .add(descriptionController);
                                      listFraisController.add(fraisController);
                                      count++;
                                    });
                                  })
                            ],
                          ),
                      ],
                    ),
                    Flexible(
                      child: listDynamictWidget()),
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

  Widget listDynamictWidget() {
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            final nbreController = TextEditingController();
                            final descriptionController =
                                TextEditingController();
                            final fraisController = TextEditingController();
                            listNbreController.add(nbreController);
                            listDescriptionController
                                .add(descriptionController);
                            listFraisController.add(fraisController);
                            count++;
                            onUpdate(
                                index,
                                listNbreController[index].text,
                                listDescriptionController[index].text,
                                listFraisController[index].text);
                          });
                        },
                        icon: const Icon(Icons.add)),
                    if (count > 0)
                      IconButton(
                          onPressed: () {
                            setState(() {
                              final nbreController = TextEditingController();
                              final descriptionController =
                                  TextEditingController();
                              final fraisController = TextEditingController();
                              listNbreController.remove(nbreController);
                              listDescriptionController
                                  .remove(descriptionController);
                              listFraisController.remove(fraisController);
                              count--;
                            });
                          },
                          icon: const Icon(Icons.close)),
                  ],
                ),
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
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: const TextStyle(),
                            )))
                  ],
                ),
                if (count >= 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        // width: double.infinity,
                        child: Card(
                            elevation: 10,
                            color: Colors.red.shade700,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SelectableText(
                                "Note: Ajoutez un champ en plus (+1) pour enregistrer le precedent",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ),
                    ],
                  )
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
      result = _prettyPrint(_values);
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
        observation: false,
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
        created: DateTime.now());
    await DevisAPi().insertData(devisModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Envoyer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }


}