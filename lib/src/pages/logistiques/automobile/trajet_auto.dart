import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/table_trajet.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class TrajetAuto extends StatefulWidget {
  const TrajetAuto({ Key? key }) : super(key: key);

  @override
  State<TrajetAuto> createState() => _TrajetAutoState();
}

class _TrajetAutoState extends State<TrajetAuto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<Controller>().scaffoldKey,
      drawer: const DrawerMenu(),
      // floatingActionButton: FloatingActionButton(
      //     child: const Icon(Icons.add),
      //     onPressed: () {
      //       Routemaster.of(context)
      //           .replace(LogistiqueRoutes.logAddTrajetAuto);
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
                  children: const [
                    CustomAppbar(title: 'Geston des trajets'),
                    Expanded(child: TableTrajet())
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
  }
}