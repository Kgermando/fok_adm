import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:provider/provider.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  final ScrollController _controllerScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
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
                    child: Expanded(
                        child: FutureBuilder<AgentModel>(
                            future: AgentsApi().getOneData(widget.id!),
                            builder: (BuildContext context,
                                AsyncSnapshot<AgentModel> snapshot) {
                              if (snapshot.hasData) {
                                AgentModel? agentModel = snapshot.data;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomAppbar(
                                        title:
                                            'Matricule ${agentModel!.matricule} '),
                                    Expanded(child: pageDetail(agentModel))
                                  ],
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }))),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(AgentModel agentModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.all(10),
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Colors.blueGrey.shade700,
                width: 2.0,
              ),
            ),
            child: ListView(
              controller: _controllerScroll,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [PrintWidget(onPressed: () {})],
                ),
                identiteWidet(agentModel),
                serviceWidet(agentModel),
                competenceExperienceWidet(agentModel),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget identiteWidet(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Nom :', 
                textAlign: TextAlign.start,
                style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)
              ), 
              Text(
                agentModel.nom, 
                textAlign: TextAlign.start,
                style: bodyMedium
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Post-Nom :',
                textAlign: TextAlign.start,
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold)
              ),
              Text(agentModel.postNom, 
                textAlign: TextAlign.start,
                style: bodyMedium
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Prénom :',
                textAlign: TextAlign.start,
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              Text(agentModel.prenom, 
                textAlign: TextAlign.start,
                style: bodyMedium
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget serviceWidet(AgentModel agentModel) {
    return Row(
      children: [
        Container(),
      ],
    );
  }

  Widget competenceExperienceWidet(AgentModel agentModel) {
    return Row(
      children: [
        Container(),
      ],
    );
  }
}
