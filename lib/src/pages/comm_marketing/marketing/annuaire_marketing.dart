import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/annuaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/annuaire/add_annuaire.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/annuaire/detail_annuaire.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/search_widget.dart';

final _lightColors = [
  Colors.pinkAccent.shade700,
  Colors.tealAccent.shade700,
  Colors.amber.shade700,
  Colors.lightGreen.shade700,
  Colors.lightBlue.shade700,
  Colors.orange.shade700,
];

class AnnuaireMarketing extends StatefulWidget {
  const AnnuaireMarketing({Key? key}) : super(key: key);

  @override
  State<AnnuaireMarketing> createState() => _AnnuaireMarketingState();
}

class _AnnuaireMarketingState extends State<AnnuaireMarketing> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String query = '';
  Timer? debouncer;

  bool connectionStatus = false;

  bool isLoading = false;

  // Search
  List<AnnuaireModel> annuaireList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Ajout contact',
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(ComMarketingRoutes.comMarketingAnnuaireAdd);
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
                          title: 'Annuaire',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      buildSearch(),
                      Expanded(
                          child: FutureBuilder<List<AnnuaireModel>>(
                              future: AnnuaireApi().getAllData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<AnnuaireModel>> snapshot) {
                                if (snapshot.hasData) {
                                  List<AnnuaireModel>? annuaireModels =
                                      snapshot.data;

                                  return annuaireModels!.isEmpty
                                      ? Column(
                                          children: [
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5),
                                            Center(
                                              child: Text(
                                                'Ajouter un contact.',
                                                style: Responsive.isDesktop(
                                                        context)
                                                    ? const TextStyle(
                                                        fontSize: 24)
                                                    : const TextStyle(
                                                        fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        )
                                      : ListView.builder(
                                          itemCount: annuaireModels.length,
                                          itemBuilder: (context, index) {
                                            final annuaireModel =
                                                annuaireModels[index];

                                            return buildAnnuaire(
                                                annuaireModel, index);
                                          });
                                } else {
                                  return Center(
                                      child: loading());
                                }
                              })),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Recherche rapide',
        onChanged: searchAchat,
      );

  Future searchAchat(String query) async => debounce(() async {
        final list = await AnnuaireApi().getAllDataSearch(query);
        if (!mounted) return;
        setState(() {
          this.query = query;
          annuaireList = list;
        });
      });

  Widget buildAnnuaire(AnnuaireModel annuaireModel, int index) {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    final color = _lightColors[index % _lightColors.length];
    return GestureDetector(
        onTap: () { 
          Navigator.of(context).pushNamed(
            ComMarketingRoutes.comMarketingAnnuaireDetail, 
              arguments: AnnuaireColor(annuaireModel: annuaireModel, color: color)
          ); 
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            child: ListTile(
              visualDensity: VisualDensity.comfortable,
              dense: true,
              leading:
                  Icon(Icons.perm_contact_cal_sharp, color: color, size: 50),
              title: Text(
                annuaireModel.nomPostnomPrenom,
                style: bodyText1,
              ),
              subtitle: Text(
                annuaireModel.mobile1,
                style: bodyText2,
              ),
            ),
          ),
        ));
  }
}
