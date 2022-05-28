import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/add_anguin_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/table_anguin.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class AnguinAuto extends StatefulWidget {
  const AnguinAuto({Key? key}) : super(key: key);

  @override
  State<AnguinAuto> createState() => _AnguinAutoState();
}

class _AnguinAutoState extends State<AnguinAuto> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.car_rental),
            onPressed: () {
              // Routemaster.of(context).push(LogistiqueRoutes.logAddAnguinAuto);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddAnguinAuto()));
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
                      CustomAppbar(title: 'Geston des enguins',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableAnguin())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
