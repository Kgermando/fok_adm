import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/components/table_etat_materiels.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class EtatMateriel extends StatefulWidget {
  const EtatMateriel({Key? key}) : super(key: key);

  @override
  State<EtatMateriel> createState() => _EtatMaterielState();
}

class _EtatMaterielState extends State<EtatMateriel> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, LogistiqueRoutes.logAddEtatMateriel);
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
                      CustomAppbar(title: 'Etat des materiels',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableEtatMateriel())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
