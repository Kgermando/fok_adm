import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/ventes/components/vente_items_widget.dart';

class VentesPage extends StatefulWidget {
  const VentesPage({Key? key}) : super(key: key);

  @override
  State<VentesPage> createState() => _VentesPageState();
}

class _VentesPageState extends State<VentesPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ),
                          const SizedBox(width: p10),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Ventes',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: FutureBuilder<List<AchatModel>>(
                              future: AchatApi().getAllData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<AchatModel>> snapshot) {
                                if (snapshot.hasData) {
                                  List<AchatModel>? achats = snapshot.data;
                                  return achats!.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Pas encore d\'articles à vendre.',
                                            style: Responsive.isDesktop(context)
                                                ? const TextStyle(fontSize: 24)
                                                : const TextStyle(fontSize: 16),
                                          ),
                                        )
                                      : Scrollbar(
                                          controller: _controllerScroll,
                                          isAlwaysShown: true,
                                          child: ListView.builder(
                                              controller: _controllerScroll,
                                              itemCount: achats.length,
                                              itemBuilder: (context, index) {
                                                final achat = achats[index];
                                                return AchatItemWidget(
                                                    achat: achat);
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
