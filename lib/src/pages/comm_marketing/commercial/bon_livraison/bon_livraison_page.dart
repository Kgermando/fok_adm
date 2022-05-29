import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/bon_livraison_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/bon_livraison.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/bon_livraison/components/detail_bon_livraison.dart';

class BonLivraisonPage extends StatefulWidget {
  const BonLivraisonPage({Key? key}) : super(key: key);

  @override
  State<BonLivraisonPage> createState() => _BonLivraisonPageState();
}

class _BonLivraisonPageState extends State<BonLivraisonPage> {
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
                          title: 'Bon de livraison',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      // const Expanded(child: TableBonLivraison())
                      Expanded(
                          child: FutureBuilder<List<BonLivraisonModel>>(
                              future: BonLivraisonApi().getAllData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<BonLivraisonModel>>
                                      snapshot) {
                                if (snapshot.hasData) {
                                  List<BonLivraisonModel>? dataList =
                                      snapshot.data;
                                  return dataList!.isEmpty
                                      ? Center(
                                          child: Text(
                                          'Pas encore de livraisons.',
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
                                                return bonLivraisonItemWidget(
                                                    data);
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

  Widget bonLivraisonItemWidget(BonLivraisonModel bonLivraisonModel) {
    Color? nonRecu;
    if (!bonLivraisonModel.accuseReception) {
      nonRecu = const Color(0xFFFFC400);
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                DetailBonLivraison(id: bonLivraisonModel.id!)));
      },
      child: Card(
        elevation: 10,
        color: nonRecu,
        child: ListTile(
          hoverColor: grey,
          dense: true,
          leading: const Icon(
            Icons.description_outlined,
            size: 40.0,
          ),
          title: Text(bonLivraisonModel.succursale,
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
            bonLivraisonModel.idProduct,
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
