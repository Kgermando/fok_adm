import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';

class AnnuaireMarketing extends StatefulWidget {
  const AnnuaireMarketing({ Key? key }) : super(key: key);

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
    Duration duration = const Duration(milliseconds: 1000),
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
          onPressed: () {}),
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
                              future: ,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<AnnuaireModel>> snapshot) {
                                if (snapshot.hasData) {
                                  List<AnnuaireModel>? annuaireModels =
                                      snapshot.data;
                                  return annuaireModels!.isEmpty
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
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
                                      : Scrollbar(
                                        showTrackOnHover: true,
                                        child: ListView.builder(
                                            itemCount:
                                                annuaireModels.length,
                                            itemBuilder: (context, index) {
                                              final annuaireModel =
                                                  annuaireModels[index];
                                              return buildAnnuaire(
                                                  annuaireModel, index);
                                            }),
                                      );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
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
}