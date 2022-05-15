import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/archives/archive_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddArchive extends StatefulWidget {
  const AddArchive({Key? key}) : super(key: key);

  @override
  State<AddArchive> createState() => _AddArchiveState();
}

class _AddArchiveState extends State<AddArchive> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final List<String> departementList = Dropdown().departement;

  TextEditingController nomDocumentController = TextEditingController();
  String? departement;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fichierController = TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    nomDocumentController.dispose();
    descriptionController.dispose();
    fichierController.dispose();

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
                                  title: 'Archive',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [TitleWidget(title: "Ajout archive")],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(child: nomDocumentWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: departementWidget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: fichierWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                    descriptionWidget(),
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

  Widget nomDocumentWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomDocumentController,
          readOnly: true,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom du document',
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

  Widget departementWidget() {
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
        validator: (value) => value == null ? "Select departement" : null,
        onChanged: (value) {
          setState(() {
            departement = value!;
          });
        },
      ),
    );
  }

  Widget descriptionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Description',
          ),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 3,
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

  Widget fichierWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: fichierController,
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 10,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Fichier',
          ),
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
    final archiveModel = ArchiveModel(
        nomDocument: nomDocumentController.text,
        departement: departement.toString(),
        description: descriptionController.text,
        fichier: fichierController.text,
        signature: signature.toString(),
        created: DateTime.now());
    await ArchiveApi().insertData(archiveModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
