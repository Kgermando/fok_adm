import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/devis/departements/administration_dep.dart';
import 'package:fokad_admin/src/pages/devis/departements/budget_dep.dart';
import 'package:fokad_admin/src/pages/devis/departements/comm_marketing_dep.dart';
import 'package:fokad_admin/src/pages/devis/departements/comptabilite_dep.dart';
import 'package:fokad_admin/src/pages/devis/departements/exploitations_dep.dart';
import 'package:fokad_admin/src/pages/devis/departements/finance_dep.dart';
import 'package:fokad_admin/src/pages/devis/departements/logistique_dep.dart';
import 'package:fokad_admin/src/pages/devis/departements/rh_dep.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class DevisPage extends StatefulWidget {
  const DevisPage({Key? key}) : super(key: key);

  @override
  State<DevisPage> createState() => _DevisPageState();
}

class _DevisPageState extends State<DevisPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
        }
      ),
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
                    Expanded(
                      child: ListView(
                        children: const [
                          AdministrationDep(),
                          RHDep(),
                          BudgetDep(),
                          ComptabiliteDep(),
                          FinanceDep(),
                          ExploitationDep(),
                          CommMarketingDep(),
                          LogistiqueDep(),
                        ],
                      ))
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
