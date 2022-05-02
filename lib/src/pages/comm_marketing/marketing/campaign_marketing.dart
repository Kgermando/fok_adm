import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/table_campaign.dart';

class CampaignMarketing extends StatefulWidget {
  const CampaignMarketing({ Key? key }) : super(key: key);

  @override
  State<CampaignMarketing> createState() => _CampaignMarketingState();
}

class _CampaignMarketingState extends State<CampaignMarketing> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            child: Row(
              children: const [
                Icon(Icons.add),
                Icon(Icons.car_rental),
              ],
            ),
            onPressed: () {
              // Routemaster.of(context).push(.expProjetAdd);
            }),
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
                          title: 'Geston des campaigns',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableCampaign())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}