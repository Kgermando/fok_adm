import 'package:flutter/material.dart'; 
import 'package:fokad_admin/src/api/rh/transport_restaurant_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/rh/table_transport_restaurant_admin.dart';

class RhAdmin extends StatefulWidget {
  const RhAdmin({Key? key}) : super(key: key);

  @override
  State<RhAdmin> createState() => _RhAdminState();
}

class _RhAdminState extends State<RhAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenRh1 = false;
  bool isOpenRh2 = false;

  int transRestCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    // RH
    var transRests = await TransportRestaurationApi().getAllData();


    setState(() {

        transRestCount =
          transRests.where((element) =>  element.approbationDD == 'Approved' &&
              element.approbationDG == '-').length;
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
                          title: 'Ressources Humaines',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text(
                                    'Dossier Transports & Restaurations',
                                    style: headline6!.copyWith(
                                        color: Colors.white)),
                                subtitle: Text(
                                    "Vous $transRestCount dossiers necessitent votre approbation",
                                    style: bodyMedium!.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenRh2 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [
                                  TableTansportRestaurantAdmin()],
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
