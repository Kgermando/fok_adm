import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/achats/components/list_stock.dart';

class AchatsPage extends StatefulWidget {
  const AchatsPage({Key? key}) : super(key: key);

  @override
  State<AchatsPage> createState() => _AchatsPageState();
}

class _AchatsPageState extends State<AchatsPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController controllerScrollbar = ScrollController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          title: 'Stocks',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: FutureBuilder<List<AchatModel>>(
                              future: AchatApi().getAllData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<AchatModel>> snapshot) {
                                if (snapshot.hasData) {
                                  List<AchatModel>? dataList = snapshot.data;
                                  return dataList!.isEmpty
                                      ? Center(
                                          child: Text(
                                          'Pas encore stocks.',
                                          style: Responsive.isDesktop(context)
                                              ? const TextStyle(fontSize: 24)
                                              : const TextStyle(fontSize: 16),
                                        ))
                                      : Scrollbar(
                                          controller: controllerScrollbar,
                                          isAlwaysShown: true,
                                          child: ListView.builder(
                                              controller: controllerScrollbar,
                                              itemCount: dataList.length,
                                              itemBuilder: (context, index) {
                                                final data = dataList[index];
                                                return ListStock(
                                                    achat: data,
                                                    role: user.role);
                                              }),
                                        );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              }))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
