import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/exploitations/projets_api.dart';
import 'package:fokad_admin/src/api/finances/creance_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/dd_finance/components/table_campaign_fin.dart';
import 'package:fokad_admin/src/pages/finances/dd_finance/components/table_devis_fin.dart';
import 'package:fokad_admin/src/pages/finances/dd_finance/components/table_projet_fin.dart';
import 'package:fokad_admin/src/pages/finances/dd_finance/components/table_salaire_fin.dart';

class DepartementFin extends StatefulWidget {
  const DepartementFin({Key? key}) : super(key: key);

  @override
  State<DepartementFin> createState() => _DepartementFinState();
}

class _DepartementFinState extends State<DepartementFin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpen1 = false;
  bool isOpen2 = false;
  bool isOpen3 = false;
  bool isOpen4 = false;

  int creanceCount = 0;
  int detteCount = 0;

  int salaireCount = 0;
  int campaignCount = 0;
  int devisCount = 0;
  int projetCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    var creances = await CreanceApi().getAllData();
    var dettes = await DetteApi().getAllData();
    var salaires = await PaiementSalaireApi().getAllData();
    var campaigns = await CampaignApi().getAllData();
    var devis = await DevisAPi().getAllData();
    var projets = await ProjetsApi().getAllData();

    setState(() {
      creanceCount = creances
          .where((element) =>
              element.statutPaie == 'false' && element.approbationDD == '-')
          .toList()
          .length;

      detteCount = dettes
          .where((element) =>
              element.statutPaie == 'false' && element.approbationDD == '-')
          .toList()
          .length;

      salaireCount = salaires
          .where((element) =>
              element.createdAt.month == DateTime.now().month &&
              element.createdAt.year == DateTime.now().year &&
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == 'Approved' &&
              element.approbationFin == "-")
          .length;

      campaignCount = campaigns
          .where((element) =>
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == 'Approved' &&
              element.approbationFin == "-")
          .length;

      devisCount = devis
          .where((element) =>
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == 'Approved' &&
              element.approbationFin == "-")
          .length;

      projetCount = projets
          .where((element) =>
              element.approbationDG == 'Approved' &&
              element.approbationDD == 'Approved' &&
              element.approbationBudget == 'Approved' &&
              element.approbationFin == "-")
          .length;
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
                      CustomAppbar(
                          title: 'Département de finance',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                              color: Colors.red.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Salaires',
                                    style: headline6!
                                        .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $salaireCount dossiers necessitent votre approbation",
                                    style: bodyMedium!
                                        .copyWith(color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen1 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableSalairesFIN()],
                              ),
                            ),
                            Card(
                              color: Colors.yellow.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Campaigns',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $campaignCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen2 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableCampaignFin()],
                              ),
                            ),
                            Card(
                              color: Colors.grey.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Etat de besoins',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $devisCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen3 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableDevisFin()],
                              ),
                            ),
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Projets',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $projetCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen4 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableProjetFin()],
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
