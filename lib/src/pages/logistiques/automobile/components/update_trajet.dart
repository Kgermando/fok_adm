import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/trajet_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/trajet_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';

class UpdateTrajet extends StatefulWidget {
  const UpdateTrajet({Key? key, required this.trajetModel}) : super(key: key);
  final TrajetModel trajetModel;

  @override
  State<UpdateTrajet> createState() => _UpdateTrajetState();
}

class _UpdateTrajetState extends State<UpdateTrajet> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController nomeroEntrepriseController = TextEditingController();
  TextEditingController nomUtilisateurController = TextEditingController();
  TextEditingController trajetDeController = TextEditingController();
  TextEditingController trajetAController = TextEditingController();
  TextEditingController missionController = TextEditingController();
  TextEditingController kilometrageSoriteController = TextEditingController();
  TextEditingController kilometrageRetourController = TextEditingController();

  @override
  initState() {
    getData();
    nomeroEntrepriseController =
        TextEditingController(text: widget.trajetModel.nomeroEntreprise);
    nomUtilisateurController = TextEditingController(text: widget.trajetModel.nomUtilisateur);
    trajetDeController = TextEditingController(text: widget.trajetModel.trajetDe);
    trajetAController = TextEditingController(text: widget.trajetModel.trajetA);
    missionController = TextEditingController(text: widget.trajetModel.mission);
    kilometrageSoriteController =
        TextEditingController(text: widget.trajetModel.kilometrageSorite);
    super.initState();
  }

  @override
  void dispose() {
    nomeroEntrepriseController.dispose();
    nomUtilisateurController.dispose();
    trajetDeController.dispose();
    trajetAController.dispose();
    missionController.dispose();
    kilometrageSoriteController.dispose();
    kilometrageRetourController.dispose();

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
    // final data = ModalRoute.of(context)!.settings.arguments as TrajetModel;
    
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
                                  title: 'Ajout KM retour',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: addAgentWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addAgentWidget() {
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [PrintWidget(onPressed: () {})],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(child: nomeroEntrepriseWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: nomUtilisateurWidget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: trajetDeWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: trajetAWidget())
                      ],
                    ),
                    missionWidget(),
                    Row(
                      children: [
                        Expanded(child: kilometrageSoriteWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: kilometrageRetourWidget())
                      ],
                    ),
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

  Widget nomeroEntrepriseWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomeroEntrepriseController,
          readOnly: true,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Numero de l\'anguin',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget nomUtilisateurWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          readOnly: true,
          controller: nomUtilisateurController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom de l\'utilisateur',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget trajetDeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          readOnly: true,
          controller: trajetDeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'De...',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget trajetAWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          readOnly: true,
          controller: trajetAController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'A...',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget missionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          readOnly: true,
          controller: missionController,
          keyboardType: TextInputType.multiline,
          minLines: 2,
          maxLines: 5,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Mission',
          ),
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget kilometrageSoriteWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          readOnly: true,
          controller: kilometrageSoriteController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Kilometrage sorite',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget kilometrageRetourWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: kilometrageRetourController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'kilometrage retour',
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

  Future<void> submit() async {
    final trajetModel = TrajetModel(
        id: widget.trajetModel.id!,
        nomeroEntreprise: widget.trajetModel.nomeroEntreprise,
        nomUtilisateur: widget.trajetModel.nomUtilisateur,
        trajetDe: widget.trajetModel.trajetDe,
        trajetA: widget.trajetModel.trajetA,
        mission: widget.trajetModel.mission,
        kilometrageSorite: widget.trajetModel.kilometrageSorite,
        kilometrageRetour: kilometrageRetourController.text,
        signature: signature.toString(),
        createdRef: widget.trajetModel.createdRef,
        created: DateTime.now(),
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await TrajetApi().updateData(trajetModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succ??s!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
