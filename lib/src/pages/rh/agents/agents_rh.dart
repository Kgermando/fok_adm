import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/table_agents.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class AgentsRh extends StatefulWidget {
  const AgentsRh({Key? key}) : super(key: key);

  @override
  State<AgentsRh> createState() => _AgentsRhState();
}

class _AgentsRhState extends State<AgentsRh> {
   final ScrollController _controllerScroll = ScrollController();
  
   @override
  void dispose() {
    _controllerScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed(RhRoutes.rhAgentAdd),
          child: const Icon(Icons.person_add),
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
                    children: const [
                      CustomAppbar(title: 'Liste des Agents'),
                      Expanded(
                          child: TableAgents()
                          
                        // Scrollbar(
                        //     controller: _controllerScroll,
                        //     child: ListView(
                        //       padding: const EdgeInsets.only(top: m20),
                        //       controller: _controllerScroll,
                        //       children: [tableWidget()],
                        //     ),
                        //   )
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
