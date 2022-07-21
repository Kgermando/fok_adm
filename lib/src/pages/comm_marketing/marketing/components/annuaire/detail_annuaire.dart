import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/annuaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart'; 
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart'; 
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailAnnuaire extends StatefulWidget {
  const DetailAnnuaire(
      {Key? key})
      : super(key: key);

  @override
  State<DetailAnnuaire> createState() => _DetailAnnuaireState();
}

class _DetailAnnuaireState extends State<DetailAnnuaire> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); 
  bool isLoading = false;
  bool hasCallSupport = false;
  // ignore: unused_field
  Future<void>? _launched;

  String? sendDate;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // ignore: deprecated_member_use
    await launch(launchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final headline5 = Theme.of(context).textTheme.headline5;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

  AnnuaireColor annuaireColor =
        ModalRoute.of(context)!.settings.arguments as AnnuaireColor;

    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: Row(
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
                      Row(
                        children: [
                          SizedBox(
                            width: p20,
                            child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back)),
                          ),
                          const SizedBox(width: p10),
                          Expanded(
                            child: CustomAppbar(
                                title: annuaireColor.annuaireModel.nomPostnomPrenom,
                                controllerMenu: () =>
                                    _key.currentState!.openDrawer()),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: isLoading
                              ? Center(child: loading())
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Card(
                                        elevation: 10,
                                        child: Container(
                                          margin: const EdgeInsets.all(p16),
                                          width: (Responsive.isDesktop(context))
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width / 2
                                              : MediaQuery.of(context)
                                                  .size
                                                  .width / 1,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(p10),
                                            border: Border.all(
                                              color: Colors.blueGrey.shade700,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Column( 
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    color: annuaireColor.color,
                                                    height: 200,
                                                    width: double.infinity,
                                                  ),
                                                  Positioned(
                                                    top: 130,
                                                    left: 50,
                                                    child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .green.shade700,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              width: 2.0,
                                                              color: Colors
                                                                  .amber
                                                                  .shade700)),
                                                      child: CircleAvatar(
                                                        radius: 50,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Image.asset(
                                                          "assets/images/avatar.jpg",
                                                          width: 80,
                                                          height: 80,
                                                        )
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: 150,
                                                      left: 180,
                                                      child: AutoSizeText(
                                                         annuaireColor.annuaireModel.nomPostnomPrenom,
                                                          maxLines: 2,
                                                          style: headline5!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white))),
                                                  Positioned(
                                                      top: 150,
                                                      right: 20,
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed:
                                                                  hasCallSupport
                                                                      ? () =>
                                                                          setState(
                                                                              () {
                                                                            _launched =
                                                                                _makePhoneCall(annuaireColor.annuaireModel.mobile1);
                                                                          })
                                                                      : null,
                                                              icon: const Icon(
                                                                Icons.call,
                                                                size: 40.0,
                                                                color: Colors
                                                                    .green,
                                                              )),
                                                          IconButton(
                                                              onPressed: () {
                                                                if (Platform
                                                                    .isAndroid) {}
                                                              },
                                                              icon: const Icon(
                                                                Icons.sms,
                                                                size: 40.0,
                                                                color: Colors
                                                                    .green,
                                                              )),
                                                          const SizedBox(
                                                              width: 8),
                                                          IconButton(
                                                            onPressed: () => {},
                                                            icon: const Icon(
                                                              Icons.email_sharp,
                                                              size: 40.0,
                                                              color:
                                                                  Colors.purple,
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              ),
                                              const SizedBox(height: p30),
                                              Card(
                                                elevation: 2,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                      editButton(annuaireColor),
                                                      deleteButton(
                                                          annuaireColor)
                                                  ],
                                                ) 
                                              ),
                                              const SizedBox(height: p30),
                                              if (!annuaireColor
                                                  .annuaireModel.email
                                                  .contains('null'))
                                                Card(
                                                  elevation: 2,
                                                  child: ListTile(
                                                    leading: Icon(
                                                        Icons.email_sharp,
                                                        color: annuaireColor
                                                            .color),
                                                    title: Text(
                                                      annuaireColor
                                                          .annuaireModel.email,
                                                      style: bodyText2,
                                                    ),
                                                  ),
                                                ),
                                              Card(
                                                elevation: 2,
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.call,
                                                    color: annuaireColor.color,
                                                    size: 40,
                                                  ),
                                                  title: Text(
                                                    annuaireColor
                                                        .annuaireModel.mobile1,
                                                    style: bodyText2,
                                                  ),
                                                  subtitle: (!annuaireColor
                                                          .annuaireModel.mobile2
                                                          .contains('null'))
                                                      ? Text(
                                                          annuaireColor
                                                              .annuaireModel
                                                              .mobile2,
                                                          style: bodyText2,
                                                        )
                                                      : Container(),
                                                ),
                                              ),
                                              if (!annuaireColor
                                                  .annuaireModel.secteurActivite
                                                  .contains('null'))
                                                Card(
                                                  elevation: 2,
                                                  child: ListTile(
                                                    leading: Icon(
                                                        Icons.local_activity,
                                                        color: annuaireColor
                                                            .color),
                                                    title: Text(
                                                      annuaireColor
                                                          .annuaireModel
                                                          .secteurActivite,
                                                      style: bodyText2,
                                                    ),
                                                  ),
                                                ),
                                              if (!annuaireColor
                                                  .annuaireModel.nomEntreprise
                                                  .contains('null'))
                                                Card(
                                                  elevation: 2,
                                                  child: ListTile(
                                                    leading: Icon(
                                                        Icons.business,
                                                        color: annuaireColor.color),
                                                    title: Text(
                                                      annuaireColor
                                                          .annuaireModel
                                                          .nomEntreprise,
                                                      style: bodyText2,
                                                    ),
                                                  ),
                                                ),
                                              if (!annuaireColor
                                                  .annuaireModel.grade
                                                  .contains('null'))
                                                Card(
                                                  elevation: 2,
                                                  child: ListTile(
                                                    leading: Icon(Icons.grade,
                                                        color: annuaireColor.color),
                                                    title: Text(
                                                      annuaireColor
                                                          .annuaireModel.grade,
                                                      style: bodyText2,
                                                    ),
                                                  ),
                                                ),
                                              if (!annuaireColor.annuaireModel
                                                  .adresseEntreprise
                                                  .contains('null'))
                                                Card(
                                                  elevation: 2,
                                                  child: ListTile(
                                                    leading: Icon(
                                                        Icons.place_sharp,
                                                        color: annuaireColor.color),
                                                    title: Text(
                                                      annuaireColor
                                                          .annuaireModel
                                                          .adresseEntreprise,
                                                      style: bodyText2,
                                                    ),
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
                  )),
            ),
          ],
        ));
  }

  Widget editButton(AnnuaireColor annuaireColor) => IconButton(
    icon: const Icon(Icons.edit_outlined),
    tooltip: "Modifiaction",
    onPressed: () { 
      Navigator.of(context).pushNamed(
          ComMarketingRoutes.comMarketingAnnuaireEdit,
          arguments:
            AnnuaireColor(
              annuaireModel: annuaireColor.annuaireModel, color: annuaireColor.color));  
    });

  Widget deleteButton(AnnuaireColor annuaireColor) {
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: "Suppression",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de supprimé ceci?'),
          content:
              const Text('Cette action permet de supprimer définitivement.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Annuler'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await AnnuaireApi().deleteData(annuaireColor.annuaireModel.id!);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "${annuaireColor.annuaireModel.nomPostnomPrenom} vient d'être supprimé!"),
                  backgroundColor: Colors.red[700],
                ));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
