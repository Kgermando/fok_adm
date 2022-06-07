import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/etat_besoin/components/table_etat_besoin_log.dart';
import 'package:fokad_admin/src/utils/priority_dropdown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class EtatBesoinLogPage extends StatefulWidget {
  const EtatBesoinLogPage({Key? key}) : super(key: key);

  @override
  State<EtatBesoinLogPage> createState() => _EtatBesoinLogPageState();
}

class _EtatBesoinLogPageState extends State<EtatBesoinLogPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final List<String> priorityList = PriorityDropdown().priorityDropdown;
  final TextEditingController titleController = TextEditingController();
  String? priority;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
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
    final sized = MediaQuery.of(context).size;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Ajout etat de besoin Logistique',
            child: const Icon(Icons.add),
            onPressed: () {
              // Navigator.pushNamed(context, RhRoutes.rhEtatBesoinAdd);
              showModalBottomSheet<void>(
                context: context,
                constraints: BoxConstraints(
                  maxWidth: sized.width / 2,
                ),
                builder: (BuildContext context) {
                  return Container(
                    height: sized.height / 2,
                    color: Colors.amber.shade100,
                    padding: const EdgeInsets.all(p20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const TitleWidget(title: "Créez l'état de besoin"),
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
                          const SizedBox(
                            height: p20,
                          ),
                          BtnWidget(
                              title: 'Crée maintenant',
                              press: () {
                                final form = _formKey.currentState!;
                                if (form.validate()) {
                                  submit();
                                  form.reset();
                                }
                              },
                              isLoading: isLoading)
                        ],
                      ),
                    ),
                  );
                },
              );
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
                          title: 'Etat de besoin',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableEtatBesoinLog())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget titleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Intitulé',
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
        validator: (value) => value == null ? "Select Priorité" : null,
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

  Future submit() async {
    final devisModel = DevisModel(
        title: titleController.text,
        priority: priority.toString(),
        departement: "Logistique",
        observation: false,
        signature: matricule.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now(),
        isSubmit: false);
    await DevisAPi().insertData(devisModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Crée avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
