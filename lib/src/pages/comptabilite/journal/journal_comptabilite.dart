import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/components/add_journal_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/components/tabla_journal.dart';


class JournalComptabilite extends StatefulWidget {
  const JournalComptabilite({ Key? key }) : super(key: key);

  @override
  State<JournalComptabilite> createState() => _JournalComptabiliteState();
}

class _JournalComptabiliteState extends State<JournalComptabilite> {
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
                          title: 'Journal',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const SizedBox(
                        height: 400,
                        child: AddJournalComptabilite()),
                      const SizedBox(height: p20),
                      const Expanded(child: TableJournal()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
} 