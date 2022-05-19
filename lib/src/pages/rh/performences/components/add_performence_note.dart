import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/performence_note_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/perfomence_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';


class AddPerformenceNote extends StatefulWidget {
  const AddPerformenceNote({Key? key, required this.performenceModel})
      : super(key: key);
  final PerformenceModel performenceModel;

  @override
  State<AddPerformenceNote> createState() => _AddPerformenceNoteState();
}

class _AddPerformenceNoteState extends State<AddPerformenceNote> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController hospitaliteController = TextEditingController();
  final TextEditingController ponctualiteController = TextEditingController();
  final TextEditingController travailleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  void dispose() {
    hospitaliteController.dispose();
    ponctualiteController.dispose();
    travailleController.dispose();

    super.dispose();
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
                                  title: 'Agent performence',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
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
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                    const TitleWidget(title: "Ajout performence"),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('Nom :',
                              textAlign: TextAlign.start,
                              style: bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: SelectableText(
                              widget.performenceModel.hospitalite,
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
                              style: bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: SelectableText(
                              widget.performenceModel.ponctualite,
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
                              style: bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: SelectableText(
                              widget.performenceModel.travaille,
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
                          child: Text('Agent :',
                              textAlign: TextAlign.start,
                              style: bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: SelectableText(widget.performenceModel.agent,
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
                          child: Text('Départemznt :',
                              textAlign: TextAlign.start,
                              style: bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: SelectableText(
                              widget.performenceModel.departement,
                              textAlign: TextAlign.start, style: bodyMedium),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.amber.shade700,
                    ),
                    Row(
                      children: [
                        Expanded(child: hospitaliteWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: ponctualiteWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: travailleWidget())
                      ],
                    ),
                    noteWidget(),
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

  Widget hospitaliteWidget() {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: hospitaliteController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Hospitalite',
                ),
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
              ),
            ),
            Expanded(flex: 1, child: Text("/10", style: headlineMedium))
          ],
        ));
  }

  Widget ponctualiteWidget() {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: ponctualiteController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ponctualite',
                ),
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
              ),
            ),
            Expanded(flex: 1, child: Text("/10", style: headlineMedium))
          ],
        ));
  }

  Widget travailleWidget() {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: travailleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Travaille',
                ),
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
              ),
            ),
            Expanded(flex: 1, child: Text("/10", style: headlineMedium))
          ],
        ));
  }

  Widget noteWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: noteController,
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Note',
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
    final performenceNoteModel = PerformenceNoteModel(
        agent: widget.performenceModel.agent,
        departement: widget.performenceModel.departement,
        hospitalite: hospitaliteController.text,
        ponctualite: ponctualiteController.text,
        travaille: travailleController.text,
        note: noteController.text,
        signature: user!.matricule.toString(),
        created: DateTime.now());
    await PerformenceNoteApi().insertData(performenceNoteModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregistrer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
