import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/components/salaires/table_salaires_dd.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/components/users/table_users.dart';

class DepartementRH extends StatefulWidget {
  const DepartementRH({Key? key}) : super(key: key);

  @override
  State<DepartementRH> createState() => _DepartementRHState();
}

class _DepartementRHState extends State<DepartementRH> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isOpenRh1 = false;
  bool isOpenRh2 = false;

  int agentInactifs = 0;
  int userAcount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    // RH
    List<AgentModel> agents = await AgentsApi().getAllData();
    List<UserModel> users = await UserApi().getAllData();

    setState(() {
      agentInactifs =
          agents.where((element) => element.statutAgent == false).length;
      userAcount = users.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                      CustomAppbar(title: 'Directeur de Département RH',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              color: const Color.fromARGB(255, 126, 170, 214),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title:
                                    Text('Dossier Salaires', style: headline6),
                                subtitle: Text(
                                    "Vous $agentInactifs dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenRh1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: const [TableSalairesDD()],
                              ),
                            ),
                            Card(
                              color: const Color.fromARGB(255, 238, 56, 32),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title:
                                    Text('Dossier utilisateurs actifs', style: headline6),
                                subtitle: Text(
                                    "Vous $userAcount dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenRh1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: const [TableUsers()],
                              ),
                            ),
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
