import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/comm_marketing/table_campaign_dg.dart';
import 'package:fokad_admin/src/pages/administration/components/comm_marketing/table_succursale_dg.dart';

class CommMarketingAdmin extends StatefulWidget {
  const CommMarketingAdmin({ Key? key }) : super(key: key);

  @override
  State<CommMarketingAdmin> createState() => _CommMarketingAdminState();
}

class _CommMarketingAdminState extends State<CommMarketingAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenCom1 = false;
  bool isOpenCom2 = false;

  int campaignCount = 0;
  int succursaleCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    UserModel userLoggIn = await AuthApi().getUserId();
    // RH
    List<CampaignModel> campaign = await CampaignApi().getAllData();
    List<SuccursaleModel> succursale = await SuccursaleApi().getAllData();
    setState(() {
      campaignCount =
          campaign.where((element) => element.approbationDG == '-').length;
      succursaleCount =
          succursale.where((element) => element.approbationDG == '-').length;
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
                          title: 'Commercial & Marketing', controllerMenu: () => _key.currentState!.openDrawer()),
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
                                    Text('Dossier Campagnes', style: headline6),
                                subtitle: Text(
                                    "Ces dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenCom1 = !val;
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
                                children: const [TableCampaignDG()],
                              ),
                            ),
                            Card(
                              color: const Color.fromARGB(255, 126, 170, 214),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title: Text('Dossier Succursale',
                                    style: headline6),
                                subtitle: Text(
                                    "Ces dossiers necessitent votre approbation",
                                    style: bodyMedium),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenCom2 = !val;
                                  });
                                },
                                trailing: Row(
                                  children: [
                                    Badge(
                                      elevation: 10,
                                      badgeContent:
                                          Text(succursaleCount.toString()),
                                      position: const BadgePosition(top: 20.0),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                children: const [TableSuccursaleDG()],
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
