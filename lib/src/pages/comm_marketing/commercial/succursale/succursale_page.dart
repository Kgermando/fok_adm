import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/approbation/approbation_api.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/detail_succurssale.dart';
import 'package:fokad_admin/src/routes/routes.dart';

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
  List<ApprobationModel> approbationList = [];
  Future<void> getData() async {
    UserModel data = await AuthApi().getUserId();
    var approbations = await ApprobationApi().getAllData();
    setState(() {
      user = data;
      approbationList = approbations;
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
                              List<SuccursaleModel> succursaleModels = [];
                              if (snapshot.hasData) {
                                for (var item in approbationList) {
                                  succursaleModels = snapshot.data!
                                      .where((element) =>
                                          element.created
                                                  .microsecondsSinceEpoch ==
                                              item.reference
                                                  .microsecondsSinceEpoch &&
                                          item.fontctionOccupee ==
                                              'Directeur générale' &&
                                          item.approbation == "Approved")
                                      .toList();
                                }
                                return succursaleModels.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Ajoutez une Succursale.',
                                          style: Responsive.isDesktop(context)
                                              ? const TextStyle(fontSize: 24)
                                              : const TextStyle(fontSize: 16),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: succursaleModels.length,
                                        itemBuilder: (context, index) {
                                          final succursaleModel =
                                              succursaleModels[index];
                                          return succursaleWidget(
                                              succursaleModel);
                                        });
                              } else if (snapshot.hasError) {
                                return const Text('Erreur de chargement');
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetailSuccursale(id: succursaleModel.id!)));
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
