import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/paiements/components/table_salaires.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class PaiementRh extends StatefulWidget {
  const PaiementRh({Key? key}) : super(key: key);

  @override
  State<PaiementRh> createState() => _PaiementRhState();
}

class _PaiementRhState extends State<PaiementRh> {
  final ScrollController _controllerScroll = ScrollController();

  int? id;

  @override
  void dispose() {
    _controllerScroll.dispose();
    super.dispose();
  }

  AgentModel? agentModel;

  Future<void> getData() async {
    AgentModel data = await AgentsApi().getOneData(id!);

    setState(() {
      agentModel = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Routemaster.of(context).replace(RhRoutes.rhPaiementAdd);
        //   },
        //   child: const Icon(Icons.add),
        // ),
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
                      CustomAppbar(title: 'Liste des paiements'),
                      Expanded(child: TableSalaires())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
