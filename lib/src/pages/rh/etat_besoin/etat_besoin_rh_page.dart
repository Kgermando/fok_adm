import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/etat_besoin/components/table_etat_besoin_rh.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class EtatBesoinRHPage extends StatefulWidget {
  const EtatBesoinRHPage({Key? key}) : super(key: key);

  @override
  State<EtatBesoinRHPage> createState() => _EtatBesoinRHPageState();
}

class _EtatBesoinRHPageState extends State<EtatBesoinRHPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Ajout etat de besoin RH',
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, RhRoutes.rhEtatBesoinAdd);
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
                      // const Expanded(child: TableDevis())
                      const Expanded(child: TabvleEtatBesoinRH())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

}