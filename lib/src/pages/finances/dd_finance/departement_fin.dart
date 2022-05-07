import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/dd_finance/components/table_campaign_fin.dart';
import 'package:fokad_admin/src/pages/finances/dd_finance/components/table_salaire_fin.dart';

class DepartementFin extends StatefulWidget {
  const DepartementFin({Key? key}) : super(key: key);

  @override
  State<DepartementFin> createState() => _DepartementFinState();
}

class _DepartementFinState extends State<DepartementFin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenRh1 = false;
  bool isOpenRh2 = false;
  bool isOpenCampaign = false;

  int nonPaye = 0;
  int campaignCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    // UserModel userLoggIn = await AuthApi().getUserId();
    List<PaiementSalaireModel?> dataList =
        await PaiementSalaireApi().getAllData();
    List<CampaignModel> campaign = await CampaignApi().getAllData();
    setState(() {
      nonPaye = dataList
          .where((element) => element!.approbationFin != '-')
          .toList()
          .length;
      campaignCount = campaign
          .where((element) => element.approbationFin != '-')
          .toList()
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
                          title: 'departement de finance',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
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
                                title:
                                    Text('Dossier Salaires', style: headline6),
                                subtitle: Text(
                                    "Ces dossiers necessitent votre approbation",
                                    style: bodyMedium),
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
                                      badgeContent: Text(nonPaye.toString()),
                                      position: const BadgePosition(top: 20.0),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                children: const [TableSalairesFIN()],
                              ),
                            ),
                            Card(
                              color: const Color.fromARGB(255, 126, 170, 214),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title:
                                    Text('Dossier Campaign', style: headline6),
                                subtitle: Text(
                                    "Ces dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenCampaign = !val;
                                  });
                                },
                                trailing: Row(
                                  children: [
                                    Badge(
                                      elevation: 10,
                                      badgeContent:
                                          Text(campaignCount.toString()),
                                      position: const BadgePosition(top: 20.0),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                children: const [TableCampaignFin()],
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
