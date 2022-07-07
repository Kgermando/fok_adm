import 'package:flutter/material.dart'; 
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart'; 
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart'; 
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class SuccursalePage extends StatefulWidget {
  const SuccursalePage({Key? key}) : super(key: key);

  @override
  State<SuccursalePage> createState() => _SuccursalePageState();
}

class _SuccursalePageState extends State<SuccursalePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  initState() {
    getData();
    super.initState();
  }

  UserModel? user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: 'false',
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-'); 
  Future<void> getData() async {
    UserModel data = await AuthApi().getUserId(); 
    setState(() {
      user = data; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber.shade700,
          foregroundColor: Colors.white,
          child: const Icon(Icons.house),
          onPressed: () {
            Navigator.pushNamed(
                context, ComMarketingRoutes.comMarketingSuccursaleAdd);
          },
        ),
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
                          title: 'Succursales',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                        child: FutureBuilder<List<SuccursaleModel>>(
                            future: SuccursaleApi().getAllData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<SuccursaleModel>> snapshot) {
                              if (snapshot.hasData) {
                                List<SuccursaleModel>? dataList = snapshot.data!
                                  .where((element) => element.approbationDG == "Approved" &&
                                   element.approbationDD == "Approved").toList(); 
 
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, ComMarketingRoutes.comMarketingSuccursale);
                                          },
                                          icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                                      ],
                                    ),
                                    Expanded(
                                      child: dataList.isEmpty
                                          ? Center(
                                              child: Text(
                                                'Ajoutez une Succursale.',
                                                style: Responsive.isDesktop(context)
                                                    ? const TextStyle(fontSize: 24)
                                                    : const TextStyle(fontSize: 16),
                                              ),
                                            )
                                          : ListView.builder(
                                              itemCount: dataList.length,
                                              itemBuilder: (context, index) {
                                                final succursaleModel =
                                                    dataList[index];
                                                return succursaleWidget(
                                                    succursaleModel);
                                              }),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return const Text('Erreur de chargement');
                              } else {
                                return Center(
                                    child: loading());
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget succursaleWidget(SuccursaleModel succursaleModel) {
    int roleAgent = int.parse(user!.role);
    return GestureDetector(
      onTap: () {
        if (roleAgent < 3) {
          Navigator.pushNamed(
            context, ComMarketingRoutes.comMarketingSuccursaleDetail,
            arguments: succursaleModel
          ); 
        }
      },
      child: Card(
        elevation: 6,
        child: ListTile(
          dense: true,
          leading: const Icon(
            Icons.business,
            size: 40.0,
          ),
          title: Text(succursaleModel.name,
              overflow: TextOverflow.clip,
              style: Responsive.isDesktop(context)
                  ? const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )
                  : const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    )),
          subtitle: Text(
            succursaleModel.province,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
