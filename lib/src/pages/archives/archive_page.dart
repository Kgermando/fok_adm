import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
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


class ArchivePage extends StatefulWidget {
  const ArchivePage({ Key? key }) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

   @override
  void initState() {
    getData();
    super.initState();
  }

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '0',
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    var userModel = await AuthApi().getUserId();
    if (mounted) {
      setState(() {
      user = userModel;
    });
    }
  }

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
              Navigator.pushNamed(
                  context, ArchiveRoutes.addArcihves);
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
                          children: [
                            if (user.departement == 'Administration')
                            const AdministrationArchive(),
                            if (user.departement == 'Ressources Humaines' ||
                              user.departement == 'Administration')
                            const RHArchive(),
                            if (user.departement == 'Budgets' ||
                              user.departement == 'Administration')
                            const BudgetArchive(),
                            if (user.departement == 'Finances' ||
                              user.departement == 'Administration')
                            const FinanceArchive(),
                            if (user.departement == 'Comptabilites' ||
                              user.departement == 'Administration')
                            const ComptabiliteArchive(),
                            if (user.departement == 'Exploitations' ||
                              user.departement == 'Administration')
                            const ExploitationArchive(),
                            if (user.departement == 'Commercial et Marketing' ||
                              user.departement == 'Administration')
                            const CommMarketingArchive(),
                            if (user.departement == 'Logistique' ||
                              user.departement == 'Administration')
                            const LogistiqueArchive(),
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