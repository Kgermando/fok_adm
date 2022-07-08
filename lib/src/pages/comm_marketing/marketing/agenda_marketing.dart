import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/agenda_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/agenda_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/agenda_card_widget.dart'; 
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class AgendaMarketing extends StatefulWidget {
  const AgendaMarketing({Key? key}) : super(key: key);

  @override
  State<AgendaMarketing> createState() => _AgendaMarketingState();
}

class _AgendaMarketingState extends State<AgendaMarketing> {
  Timer? timer;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateRappelController = TextEditingController();

  @override
  initState() {
    timer = Timer.periodic(const Duration(seconds: 1), ((timer) {
      getData();
    }));
    super.initState();
  }

  @override
  dispose() {
    timer!.cancel();
    titleController.dispose();
    descriptionController.dispose();
    dateRappelController.dispose();
    super.dispose();
  }

  List<AgendaModel> agendaList = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var agenda = await AgendaApi().getAllData();
    setState(() {
      user = userModel;
      agendaList = agenda
          .where((element) => element.signature == user!.matricule)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Nouvel agenda',
            child: const Icon(Icons.add),
            onPressed: () {
              newFicheDialog();
              // Navigator.of(context)
              //     .pushNamed(ComMarketingRoutes.comMarketingAgendaAdd);
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
                          title: 'Agenda',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(child: buildAgenda())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildAgenda() {
    return (agendaList.isEmpty)
      ? const Center(child: Text("Ajouter quelque chose... 😊!"))
      :  StaggeredGrid.count(
      crossAxisCount: 6,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: List.generate(agendaList.length, (index) {
        final agenda = agendaList[index];
        final color = _lightColors[index % _lightColors.length];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
                ComMarketingRoutes.comMarketingAgendaDetail,
                arguments: AgendaColor(agendaModel: agenda, color: color));
          },
          child:
              AgendaCardWidget(agendaModel: agenda, index: index, color: color),
        );
      }),
    );
  }


  newFicheDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Ajout Materiel'),
              content: SizedBox(
                  height: 400,
                  width: 500,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: p20),
                              dateRappelWidget(),
                              const SizedBox(height: p16),
                              buildTitle(),
                              const SizedBox(height: p16),
                              buildDescription(),
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
                    setState(() {
                      isLoading = true;
                    });

                    submit();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

   Widget buildTitle() {
    return TextFormField(
      maxLength: 50,
      controller: titleController,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Objet...',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Ce champs est obligatoire';
        } else {
          return null;
        }
      },
    );
  }

  Widget dateRappelWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Rappel',
          ),
          controller: dateRappelController,
          firstDate: DateTime(1930),
          lastDate: DateTime(2100),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget buildDescription() {
    return TextFormField(
      maxLines: 5,
      keyboardAppearance: Brightness.dark,
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        labelText: 'Ecrivez quelque chose...',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Ce champs est obligatoire';
        } else {
          return null;
        }
      },
    );
  }

  Future<void> submit() async {
    final agendaModel = AgendaModel(
        title: titleController.text,
        description: descriptionController.text,
        dateRappel: DateTime.parse(dateRappelController.text),
        signature: user!.matricule.toString(),
        created: DateTime.now());
    await AgendaApi().insertData(agendaModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Enregister avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
