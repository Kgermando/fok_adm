import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
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
              borderRadius: BorderRadius.circular(p10),
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
                  children: [
                    IconButton(
                        tooltip: 'Changer le statut agent',
                        onPressed: () {},
                        color: Colors.red.shade700,
                        icon: const Icon(Icons.person)),
                    PrintWidget(
                      tooltip: 'Imprimer le document',
                      onPressed: () {}
                    )
                  ],
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                  radius: 50,
                  child: (agentModel.photo == null)
                    ? Image.asset(
                        'assets/images/logo.png',
                        width: 150,
                        height: 150,
                      )
                    : Image.network(
                        agentModel.photo!,
                        width: 150,
                        height: 150,
                      )
                ),
              Column(
                children: [
                  Row(
                    children: [
                      Text('Statut agent :',
                          textAlign: TextAlign.start,
                          style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                      (agentModel.statutAgent)
                          ? Text('Actif',
                              textAlign: TextAlign.start,
                              style:
                                  bodyMedium.copyWith(color: Colors.green.shade700))
                          : Text('Inactif',
                              textAlign: TextAlign.start,
                              style: bodyMedium.copyWith(
                                  color: Colors.orange.shade700))
                    ],
                  ),
                  Text("Créé le. ${DateFormat.yMMMd().format(agentModel.createdAt)}",
                      textAlign: TextAlign.start, style: bodyMedium),
                ],
              )
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.nom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Post-Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.postNom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Prénom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.prenom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Email :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.email,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Téléphone :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.telephone,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Genre :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.sexe,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Niveau d\'accréditation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.role,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Matricule :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.matricule,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Lieu de naissance :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.lieuNaissance,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Date de naissance :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(DateFormat.yMMMd().format(agentModel.dateNaissance),
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Nationalité :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.nationalite,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Adresse :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.adresse,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget serviceWidet(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Type de Contrat :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.typeContrat,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Fonction occupée :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.fonctionOccupe,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Département :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.departement,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Services d\'affectation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(agentModel.servicesAffectation,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Date de début du contrat :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(
                    DateFormat.yMMMd().format(agentModel.dateDebutContrat),
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          if (agentModel.typeContrat == 'CDD')
            Row(
              children: [
                Expanded(
                  child: Text('Date de fin du contrat :',
                      textAlign: TextAlign.start,
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Text(
                      DateFormat.yMMMd().format(agentModel.dateFinContrat),
                      textAlign: TextAlign.start,
                      style: bodyMedium),
                )
              ],
            ),
        ],
      ),
    );
  }

  Widget competenceExperienceWidet(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Formation :',
                style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)
              ),
              
              Text(
                agentModel.competance!,
                textAlign: TextAlign.justify,
                style: bodyMedium
              )
            ],
          ),
          const SizedBox(height: p30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text('Experience :',
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              Text(
                agentModel.experience!,
                textAlign: TextAlign.justify,
                style: bodyMedium
              )
            ],
          ),
        ],
      ),
    );
  }
}
