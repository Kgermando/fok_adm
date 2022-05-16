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
import 'package:fokad_admin/src/pages/devis/components/table_devis.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/priority_dropdown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:routemaster/routemaster.dart';

class DevisPage extends StatefulWidget {
  const DevisPage({Key? key}) : super(key: key);

  @override
  State<DevisPage> createState() => _DevisPageState();
}

class _DevisPageState extends State<DevisPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _form = GlobalKey<FormState>();
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
      floatingActionButton: FloatingActionButton(
          tooltip: 'Nouveau devis',
          child: const Icon(Icons.add),
          onPressed: () {
            Routemaster.of(context).replace(DevisRoutes.devisAdd);
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
                    const Expanded(child: TableDevis())
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  
}
