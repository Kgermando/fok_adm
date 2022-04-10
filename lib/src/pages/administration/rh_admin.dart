import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/rh/table_salaire_admin.dart';

class RhAdmin extends StatefulWidget {
  const RhAdmin({ Key? key }) : super(key: key);

  @override
  State<RhAdmin> createState() => _RhAdminState();
}

class _RhAdminState extends State<RhAdmin> {
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenRh1 = false;
  bool isOpenRh2 = false;

  

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Scaffold(
        // key: context.read<Controller>().scaffoldKey,
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
                      const CustomAppbar(title: 'RH Admin'),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                              color: Colors.red.shade700,
                              child: ExpansionTile(
                                leading: Badge(
                                    badgeColor: Colors.blue,
                                    badgeContent: const Text('1',
                                        style: TextStyle(fontSize: 10.0, color: Colors.white)),
                                    child: const Icon(Icons.notifications),
                                  ),
                                  title: Text('Dossier Salaire', style: headline6),
                                  initiallyExpanded: false,
                                  onExpansionChanged: (val) {
                                    setState(() {
                                      isOpenRh1 = !val;
                                    });
                                  },
                                  trailing: const Icon(Icons.arrow_drop_down),
                                  children: const [
                                    TableSalaireAdmin()
                                  ],
                                ),
                              ),

                            Card(
                              color: Colors.green..shade700,
                              child: ExpansionTile(
                                leading: Badge(
                                  badgeColor: Colors.blue,
                                  badgeContent: const Text('1',
                                      style: TextStyle(
                                          fontSize: 10.0, color: Colors.white)),
                                  child: const Icon(Icons.notifications),
                                ),
                                title: Text('Dossier Dépenses', style: headline6),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenRh2 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: [],
                              ),
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
