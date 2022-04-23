
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/rh/table_agent_admin.dart';
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

  int agentInactifs = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    UserModel userLoggIn = await AuthApi().getUserId();
    // RH
    List<AgentModel> agents = await AgentsApi().getAllData();

    setState(() {
      agentInactifs =
          agents.where((element) => element.statutAgent == false).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                              color: const Color.fromARGB(255, 126, 170, 214),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                  title: Text('Dossier Salaires', style: headline6),
                                  subtitle: Text("Ces dossiers necessitent votre approbation", style: bodyMedium),
                                  initiallyExpanded: false,
                                  onExpansionChanged: (val) {
                                    setState(() {
                                      isOpenRh1 = !val;
                                    });
                                  },
                                  trailing: Row(
                                    children: [
                                      Badge(
                                        elevation: 10,
                                        badgeContent: Text(agentInactifs.toString()),
                                        position: const BadgePosition(top: 20.0),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                  children: const [
                                    TableSalaireAdmin()
                                  ],
                                ),
                              ),

                            Card(
                              color: const Color.fromARGB(255, 117, 190, 121),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title: Text('Dossier employés', style: headline6),
                                subtitle: Text(
                                    "Ces dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenRh2 = !val;
                                  });
                                },
                                trailing: Row(
                                  children: [
                                    Badge(
                                      elevation: 10,
                                      badgeContent:
                                          Text(agentInactifs.toString()),
                                      position: const BadgePosition(top: 20.0),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                children: const [
                                  TableAgentAdmin()
                                ],
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
