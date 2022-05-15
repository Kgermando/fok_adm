import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/produit_model_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/c_m_dd/components/campaigns/table_campaign_dd.dart';
import 'package:fokad_admin/src/pages/comm_marketing/c_m_dd/components/produi_model/table_prod_model_dd.dart';
import 'package:fokad_admin/src/pages/comm_marketing/c_m_dd/components/succursales/table_succursale_dd.dart';

class CMDD extends StatefulWidget {
  const CMDD({Key? key}) : super(key: key);

  @override
  State<CMDD> createState() => _CMDDState();
}

class _CMDDState extends State<CMDD> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenRh1 = false;
  bool isOpenRh2 = false;

  int campaignCount = 0;
  int succursaleCount = 0;
  int prodModelCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    List<CampaignModel> campaign = await CampaignApi().getAllData();
    List<SuccursaleModel> succursale = await SuccursaleApi().getAllData();
    List<ProductModel> prodModel = await ProduitModelApi().getAllData();
    setState(() {
      campaignCount =
          campaign.where((element) => element.approbationDD == '-').length;
      succursaleCount =
          succursale.where((element) => element.approbationDD == '-').length;
      prodModelCount =
          prodModel.where((element) => element.approbationDD == '-').length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Scaffold(
        // key: _key,
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
                          title: 'Département COMM && Marketing',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                              color: Colors.pink.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title:
                                    Text('Dossier Campagnes', style: headline6!
                                        .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $campaignCount dossiers necessitent votre approbation",
                                    style: bodyMedium!
                                        .copyWith(color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenRh1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down, color: Colors.white,),
                                children: const [TableCampaignDD()],
                              ),
                            ),
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Succursale',
                                    style: headline6.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $succursaleCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenRh1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down, color: Colors.white,),
                                children: const [TableSuccursaleDD()],
                              ),
                            ),
                            Card(
                              color: Colors.grey.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier modèle produits',
                                    style: headline6.copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $prodModelCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenRh1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down, color: Colors.white,),
                                children: const [TableProduitModelDD()],
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
