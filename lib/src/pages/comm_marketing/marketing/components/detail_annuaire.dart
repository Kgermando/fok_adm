import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/annuaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/add_update_annuaire.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailAnnuaire extends StatefulWidget {
  const DetailAnnuaire({Key? key, required this.annuaireModel, required this.color}) : super(key: key);
  final AnnuaireModel annuaireModel;
  final Color color;

  @override
  State<DetailAnnuaire> createState() => _DetailAnnuaireState();
}

class _DetailAnnuaireState extends State<DetailAnnuaire> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
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
    await launch(launchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    final _size = MediaQuery.of(context).size;
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
                              onPressed: () => Routemaster.of(context).pop(),
                              icon: const Icon(Icons.arrow_back)),
                        ),
                        const SizedBox(width: p10),
                        Expanded(
                          child: CustomAppbar(
                              title: widget.annuaireModel.nomPostnomPrenom,
                              controllerMenu: () =>
                                  _key.currentState!.openDrawer()),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Scrollbar(
                        controller: _controllerScroll,
                          isAlwaysShown: true,
                        child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                elevation: 10,
                                child: Container(
                                  margin: const EdgeInsets.all(p16),
                                  width: (Responsive.isDesktop(context))
                                      ? MediaQuery.of(context).size.width / 2
                                      : MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(p10),
                                    border: Border.all(
                                      color: Colors.blueGrey.shade700,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: ListView(
                                    controller: _controllerScroll,
                                    children: [
                                      if (widget.annuaireModel
                                                    .nomPostnomPrenom.isNotEmpty)
                                  Container(
                                  height: _size.height / 4,
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                      color: widget.color),
                                  child:
                                      Responsive.isDesktop(
                                              context)
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .end,
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .perm_contact_cal_sharp,
                                                  size: 40.0,
                                                  // color: Colors.white,
                                                ),
                                                const SizedBox(
                                                    width: 8),
                                                SizedBox(
                                                  width: _size
                                                          .width /
                                                      2,
                                                  child: Text(
                                                    widget
                                                        .annuaireModel
                                                        .nomPostnomPrenom,
                                                    // style: headline4,
                                                    style: const TextStyle(
                                                        fontSize:
                                                            30.0),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: hasCallSupport
                                                            ? () => setState(() {
                                                                  _launched = _makePhoneCall(widget.annuaireModel.mobile1);
                                                                })
                                                            : null,
                                                        icon: const Icon(
                                                          Icons
                                                              .call,
                                                          size:
                                                              40.0,
                                                          color: Colors
                                                              .green,
                                                        )),
                                                    IconButton(
                                                        onPressed:
                                                            () {
                                                          if (Platform
                                                              .isAndroid) {}
                                                        },
                                                        icon:
                                                            const Icon(
                                                          Icons
                                                              .sms,
                                                          size:
                                                              40.0,
                                                          color: Colors
                                                              .green,
                                                        )),
                                                    const SizedBox(
                                                        width: 8),
                                                    IconButton(
                                                      onPressed:
                                                          () => {},
                                                      icon:
                                                          const Icon(
                                                        Icons
                                                            .email_sharp,
                                                        size:
                                                            40.0,
                                                        color: Colors
                                                            .purple,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .end,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .perm_contact_cal_sharp,
                                                      size: 40.0,
                                                      // color: Colors.white,
                                                    ),
                                                    const SizedBox(
                                                        width: 8),
                                                    SizedBox(
                                                      width: _size
                                                              .width /
                                                          2,
                                                      child: Text(
                                                        widget
                                                            .annuaireModel
                                                            .nomPostnomPrenom,
                                                        // style: headline4,
                                                        style: Responsive.isDesktop(
                                                                context)
                                                            ? const TextStyle(
                                                                fontSize: 30.0)
                                                            : const TextStyle(
                                                                // color: Colors.white,
                                                                fontSize: 16.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .end,
                                                  children: [
                                                    IconButton(
                                                        onPressed: hasCallSupport
                                                            ? () => setState(() {
                                                                  _launched = _makePhoneCall(widget.annuaireModel.mobile1);
                                                                })
                                                            : null,
                                                        icon: const Icon(
                                                          Icons
                                                              .call,
                                                          size:
                                                              40.0,
                                                          color: Colors
                                                              .green,
                                                        )),
                                                    const SizedBox(
                                                        width: 8),
                                                    IconButton(
                                                      onPressed:
                                                          () => {},
                                                      icon:
                                                          const Icon(
                                                        Icons
                                                            .email_sharp,
                                                        size:
                                                            40.0,
                                                        color: Colors
                                                            .purple,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                  ),
                                const SizedBox(height: 16.0),
                                if (!widget.annuaireModel.email
                                  .contains('null'))
                                  Card(
                                  elevation: 2,
                                  child: ListTile(
                                    leading: Icon(
                                        Icons.email_sharp,
                                        color: widget.color),
                                    title: Text(
                                      widget.annuaireModel.email,
                                      style: bodyText2,
                                    ),
                                  ),
                                  ),
                                Card(
                                  elevation: 2,
                                  child: ListTile(
                                  leading: Icon(
                                    Icons.call,
                                    color: widget.color,
                                    size: 40,
                                  ),
                                  title: Text(
                                    widget.annuaireModel.mobile1,
                                    style: bodyText2,
                                  ),
                                  subtitle: (!widget
                                          .annuaireModel.mobile2
                                          .contains('null'))
                                      ? Text(
                                          widget.annuaireModel
                                              .mobile2,
                                          style: bodyText2,
                                        )
                                      : Container(),
                                  ),
                                ),
                                if (!widget
                                  .annuaireModel.secteurActivite
                                  .contains('null'))
                                  Card(
                                  elevation: 2,
                                  child: ListTile(
                                    leading: Icon(
                                        Icons.local_activity,
                                        color: widget.color),
                                    title: Text(
                                      widget.annuaireModel
                                          .secteurActivite,
                                      style: bodyText2,
                                    ),
                                  ),
                                  ),
                                if (!widget
                                  .annuaireModel.nomEntreprise
                                  .contains('null'))
                                  Card(
                                  elevation: 2,
                                  child: ListTile(
                                    leading: Icon(Icons.business,
                                        color: widget.color),
                                    title: Text(
                                      widget.annuaireModel
                                          .nomEntreprise,
                                      style: bodyText2,
                                    ),
                                  ),
                                  ),
                                if (!widget.annuaireModel.grade
                                  .contains('null'))
                                  Card(
                                  elevation: 2,
                                  child: ListTile(
                                    leading: Icon(Icons.grade,
                                        color: widget.color),
                                    title: Text(
                                      widget.annuaireModel.grade,
                                      style: bodyText2,
                                    ),
                                  ),
                                  ),
                                if (!widget
                                  .annuaireModel.adresseEntreprise
                                  .contains('null'))
                                  Card(
                                  elevation: 2,
                                  child: ListTile(
                                    leading: Icon(
                                        Icons.place_sharp,
                                        color: widget.color),
                                    title: Text(
                                      widget.annuaireModel
                                          .adresseEntreprise,
                                      style: bodyText2,
                                    ),
                                  ),
                                  ),
                                  ],
                                  ),
                                )
                              )
                            ],
                          ),
                      ),
                    ),
                  ],
                )
              ),
            ),
          ],
        ));
        
  }

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              AddUpdateAnnuaire(annuaireModel: widget.annuaireModel),
        ));
      });

  Widget deleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete),
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
                await AnnuaireApi().deleteData(widget.annuaireModel.id!);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "${widget.annuaireModel.nomPostnomPrenom} vient d'être supprimé!"),
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