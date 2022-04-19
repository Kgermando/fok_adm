import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/table_anguin.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class AnguinAuto extends StatefulWidget {
  const AnguinAuto({Key? key}) : super(key: key);

  @override
  State<AnguinAuto> createState() => _AnguinAutoState();
}

class _AnguinAutoState extends State<AnguinAuto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          child: Row(
            children: const [
              Icon(Icons.add),
              Icon(Icons.car_rental),
            ],
          ),
          onPressed: () {
          Routemaster.of(context).replace(LogistiqueRoutes.logAddAnguinAuto);
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
                    children: const [
                      CustomAppbar(title: 'Geston des anguins'),
                      Expanded(child: TableAnguin())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
