import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/archives/components/administration_archive.dart';
import 'package:fokad_admin/src/pages/archives/components/budget_archive.dart';
import 'package:fokad_admin/src/pages/archives/components/comm_marketing_archive.dart';
import 'package:fokad_admin/src/pages/archives/components/comptabilite_archive.dart';
import 'package:fokad_admin/src/pages/archives/components/exploitations_archive.dart';
import 'package:fokad_admin/src/pages/archives/components/finance_archive.dart';
import 'package:fokad_admin/src/pages/archives/components/logistique_archive.dart';
import 'package:fokad_admin/src/pages/archives/components/rh_archive.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({ Key? key }) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.brown.shade700,
            child: const Icon(Icons.add),
            onPressed: () {
              Routemaster.of(context).push(ArchiveRoutes.addArcihves);
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
                          title: 'Gestion des archives',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                        child: ListView(
                          children: const [
                            AdministrationArchive(),
                            RHArchive(),
                            BudgetArchive(),
                            ComptabiliteArchive(),
                            FinanceArchive(),
                            ExploitationArchive(),
                            CommMarketingArchive(),
                            LogistiqueArchive(),
                          ],
                        )
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