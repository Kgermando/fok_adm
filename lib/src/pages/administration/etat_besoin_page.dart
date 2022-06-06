import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/etat_besoin/components/table_etat_besoin_admin.dart';
import 'package:fokad_admin/src/pages/administration/components/etat_besoin/components/table_etat_besoin_departement.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/utils/priority_dropdown.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class EtatBesoinAdmin extends StatefulWidget {
  const EtatBesoinAdmin({Key? key}) : super(key: key);

  @override
  State<EtatBesoinAdmin> createState() => _EtatBesoinAdminState();
}

class _EtatBesoinAdminState extends State<EtatBesoinAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpen = false;

  int itemCount = 0;

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

  String? matricule;
  Future<void> getData() async {
    var data = await DevisAPi().getAllData();
    var approbations = await ApprobationApi().getAllData();
    setState(() {
      // itemCount = data.toList().length;

      for (var item in approbations) {
        bool isApprove = data
            .map((e) =>
                e.createdRef.microsecondsSinceEpoch == item.reference.microsecondsSinceEpoch &&
                item.fontctionOccupee == 'Directeur générale')
            .first;
        if (!isApprove) {
          itemCount = data.toList().length;
        }

        // itemCount = data
        //  .where((element) => element.createdRef == ).toList().length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final sized = MediaQuery.of(context).size;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Ajout etat de besoin RH',
            child: const Icon(Icons.add),
            onPressed: () {
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
                          ElevatedButton(
                            child: (isLoading)
                                ? loadingMini()
                                : const Text('Crée maintenant'),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              final form = _formKey.currentState!;
                              if (form.validate()) {
                                submit();
                                form.reset();
                              }
                            },
                          )
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
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                              color: Colors.orange.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text(
                                    'Dossier Etat de besoin departements',
                                    style: headline6!
                                        .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $itemCount dossiers necessitent votre approbation",
                                    style: bodyMedium!
                                        .copyWith(color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [
                                  TabvleEtatBesoinDepartement(),
                                ],
                              ),
                            ),
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text(
                                    'Dossier Etat de besoin administration',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TabvleEtatBesoinAdmin()],
                              ),
                            ),
                          ],
                        ),
                      ))
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
        departement: "Administration",
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
