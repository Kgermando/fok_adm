import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';

class ArchiveFolder extends StatefulWidget {
  const ArchiveFolder({Key? key}) : super(key: key);

  @override
  State<ArchiveFolder> createState() => _ArchiveFolderState();
}

class _ArchiveFolderState extends State<ArchiveFolder> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController folderNameController = TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    folderNameController.dispose();
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
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        // floatingActionButton: FloatingActionButton(
        //     foregroundColor: Colors.white,
        //     backgroundColor: Colors.brown.shade700,
        //     child: const Icon(Icons.add),
        //     onPressed: () {
        //       Navigator.pushNamed(context, ArchiveRoutes.addArcihves);
        //     }),
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
                          title: 'Gestion des archives',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(p30),
                        child: ContextMenuArea(
                            builder: (context) => [
                                  ListTile(
                                    title: const Text('Nouveau dossier'),
                                    onTap: () {
                                      detailAgentDialog();
                                    },
                                  ),
                                ],
                            child: const Card(
                              // color: Theme.of(context).primaryColor,
                              child: Center(
                                child: Text(
                                  'Cliquer pour crée un dossier.',
                                  style: TextStyle(
                                    // color:Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            )),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  detailAgentDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Nouveau dossier'),
              content: SizedBox(
                  height: 100,
                  width: 200,
                  child: Form(key: _formKey, child: nomWidget())),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      submit();
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
          controller: folderNameController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom du dossier',
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

  Future<void> submit() async {
    final archiveFolderModel = ArchiveFolderModel(
      departement: user.departement,
      folderName: folderNameController.text,
      signature: user.matricule,
      created: DateTime.now()
    );
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Ajouté avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
