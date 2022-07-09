import 'package:flutter/material.dart'; 
import 'package:fokad_admin/src/api/auth/auth_api.dart'; 
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';  
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/table_succursale.dart'; 
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
                          title: 'Gestion des produits modèles',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableSuccursale())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // Widget succursaleWidget(SuccursaleModel succursaleModel) {
  //   int roleAgent = int.parse(user!.role);
  //   return GestureDetector(
  //     onTap: () {
  //       if (roleAgent < 3) {
  //         Navigator.pushNamed(
  //           context, ComMarketingRoutes.comMarketingSuccursaleDetail,
  //           arguments: succursaleModel
  //         ); 
  //       }
  //     },
  //     child: Card(
  //       elevation: 6,
  //       child: ListTile(
  //         dense: true,
  //         leading: const Icon(
  //           Icons.business,
  //           size: 40.0,
  //         ),
  //         title: Text(succursaleModel.name,
  //             overflow: TextOverflow.clip,
  //             style: Responsive.isDesktop(context)
  //                 ? const TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 14,
  //                   )
  //                 : const TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 12,
  //                   )),
  //         subtitle: Text(
  //           succursaleModel.province,
  //           overflow: TextOverflow.clip,
  //           style: const TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 10,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
