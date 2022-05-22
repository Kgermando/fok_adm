import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/components/salaires/table_salaires_dd.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/components/users/table_users.dart';

class DepartementRH extends StatefulWidget {
  const DepartementRH({Key? key}) : super(key: key);

  @override
  State<DepartementRH> createState() => _DepartementRHState();
}

class _DepartementRHState extends State<DepartementRH> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isOpen1 = false;
  bool isOpen2 = false;

  int salairesCpunt = 0;
  int userAcount = 0;

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      getData();
      timer.cancel();
    }));

    super.initState();
  }

  Future<void> getData() async {
    // RH
    var salaires = await PaiementSalaireApi().getAllData();
    List<UserModel> users = await UserApi().getAllData();

    setState(() {
      salairesCpunt =
          salaires
          .where((element) =>
              element.createdAt.month == DateTime.now().month &&
              element.createdAt.year == DateTime.now().year &&
              element.approbationDD == "-")
          .length;
      userAcount = users.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
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
                          title: 'Directeur de departement RH',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              color: Colors.red.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder, color: Colors.white),
                                title:
                                    Text('Dossier Salaires', style: headline6!.copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous $salairesCpunt dossiers necessitent votre approbation",
                                    style: bodyMedium!.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableSalairesDD()],
                              ),
                            ),
                            Card(
                              color: Colors.green.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder, color: Colors.white),
                                title: Text('Dossier utilisateurs actifs',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
                                // subtitle: Text(
                                //     "Vous $userAcount dossiers necessitent votre approbation",
                                //     style: bodyMedium.copyWith(
                                //         color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen2 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down, 
                                  color: Colors.white),
                                children: const [TableUsers()],
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
}
