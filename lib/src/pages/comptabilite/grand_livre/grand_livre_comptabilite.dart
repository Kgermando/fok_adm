import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comptabilite/grand_livre/components/search_grand_livre.dart';
import 'package:fokad_admin/src/pages/comptabilite/grand_livre/components/table_grand_livre.dart';


class GrandLivreComptabilite extends StatefulWidget {
  const GrandLivreComptabilite({ Key? key }) : super(key: key);

  @override
  State<GrandLivreComptabilite> createState() => _GrandLivreComptabiliteState();
}

class _GrandLivreComptabiliteState extends State<GrandLivreComptabilite> {
 final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
                          title: 'Grand livre',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(
                        child: SearchGrandLivre()
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}