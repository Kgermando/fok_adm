import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comptabilite/bilan/components/table_bilan.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class BilanComptabilite extends StatefulWidget {
  const BilanComptabilite({ Key? key }) : super(key: key);

  @override
  State<BilanComptabilite> createState() => _BilanComptabiliteState();
}

class _BilanComptabiliteState extends State<BilanComptabilite> {
 final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Routemaster.of(context).push(ComptabiliteRoutes.comptabiliteBilanAdd);
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
                          title: 'Bilan',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableBilan())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}