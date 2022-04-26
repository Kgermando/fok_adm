import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/agenda_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/agenda_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';

class AddUpdateAgenda extends StatefulWidget {
  const AddUpdateAgenda({Key? key, this.agendaModel}) : super(key: key);
  final AgendaModel? agendaModel;

  @override
  State<AddUpdateAgenda> createState() => _AddUpdateAgendaState();
}

class _AddUpdateAgendaState extends State<AddUpdateAgenda> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int? id;
  int? number;

  @override
  void initState() {
    getData();
    setState(() {
      id = widget.agendaModel!.id;
      titleController = TextEditingController(text: widget.agendaModel!.title);
      descriptionController =
          TextEditingController(text: widget.agendaModel!.description);
    });
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  UserModel? user;
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
        floatingActionButton: FloatingActionButton(
            tooltip: 'Nouveau devis',
            child: const Icon(Icons.add),
            onPressed: () => {}),
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
                          title: (widget.agendaModel!.title == '')
                              ? 'Ajout note'
                              : widget.agendaModel!.title,
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
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
                    buildNumber(),
                    buildTitle(context),
                    const SizedBox(height: 8),
                    buildDescription(context),
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

  Widget buildNumber() {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: (number ?? 0).toDouble(),
            label: 'Niveau d\'importance',
            min: 0,
            max: 5,
            divisions: 5,
            onChanged: (value) => setState(() {
              number = value.toInt();
            }),
          ),
        )
      ],
    );
  }

  Widget buildTitle(BuildContext context) {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    return TextFormField(
      maxLines: 1,
      style: bodyText1,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Titre',
        // hintStyle: TextStyle(color: Colors.black54),
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

  Widget buildDescription(BuildContext context) {
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    return TextFormField(
      maxLines: 10,
      style: bodyText2,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Ecrivez quelque chose...',
        // hintStyle: TextStyle(color: Colors.black54),
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
        number: number!,
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
        signature: user!.matricule.toString(),
        created: DateTime.now());
    if (id != null) {
      await AgendaApi().updateData(id!, agendaModel);
    } else {
      await AgendaApi().insertData(agendaModel);
    }
  }
}
