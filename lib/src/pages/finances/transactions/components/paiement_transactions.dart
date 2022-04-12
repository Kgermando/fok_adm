import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:provider/provider.dart';

import 'components/salaires/table_salaire_fin.dart';

class PaiementTransaction extends StatefulWidget {
  const PaiementTransaction({ Key? key }) : super(key: key);

  @override
  State<PaiementTransaction> createState() => _PaiementTransactionState();
}

class _PaiementTransactionState extends State<PaiementTransaction> {
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
                    CustomAppbar(title: 'Liste des paiements salaire'),
                    Expanded(child: TableSalaireFin())
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
  }
}