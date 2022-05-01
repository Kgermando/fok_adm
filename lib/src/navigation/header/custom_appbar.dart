import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/exploitations/rapport_api.dart';
import 'package:fokad_admin/src/api/exploitations/taches_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/exploitations/rapport_model.dart';
import 'package:fokad_admin/src/models/exploitations/tache_model.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/header/header_item.dart';
import 'package:fokad_admin/src/utils/menu_items.dart';
import 'package:fokad_admin/src/utils/menu_options.dart';
import 'package:badges/badges.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar(
      {Key? key, required this.title, required this.controllerMenu})
      : super(key: key);

  final String title;
  final VoidCallback controllerMenu;

  @override
  _CustomAppbarState createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  bool isActiveNotification = true;

  int tacheCount = 0;

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      getData();
      timer.cancel();
    }));
    super.initState();
  }

  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var taches = await TachesApi().getAllData();
    setState(() {
      tacheCount = taches
          .where((element) =>
              element.signatureResp == userModel.matricule &&
              element.read == false)
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                onPressed: widget.controllerMenu,
                icon: const Icon(
                  Icons.menu,
                ),
              ),
            HeaderItem(title: widget.title),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: Badge(
                  badgeContent: const Text('33',
                      style: TextStyle(fontSize: 10.0, color: Colors.white)),
                  child: const Icon(Icons.mail),
                )),
            if (tacheCount >= 1)
              IconButton(
                  onPressed: () {},
                  icon: Badge(
                    badgeContent: Text('$tacheCount',
                        style: const TextStyle(
                            fontSize: 10.0, color: Colors.white)),
                    child: const Icon(Icons.notifications),
                  )),
            const SizedBox(width: 10.0),
            InkWell(
              onTap: () {},
              child: FutureBuilder<UserModel>(
                  future: AuthApi().getUserId(),
                  builder: (BuildContext context,
                      AsyncSnapshot<UserModel> snapshot) {
                    if (snapshot.hasData) {
                      UserModel? userModel = snapshot.data;
                      // print('photo ${userModel!.photo}');
                      final String firstLettter2 = userModel!.prenom[0];
                      final String firstLettter = userModel.nom[0];

                      return Row(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: CircleAvatar(
                              backgroundColor: Colors.white38,
                              child: AutoSizeText(
                                '$firstLettter2$firstLettter'.toUpperCase(),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: p8),
                          Responsive.isDesktop(context)
                              ? AutoSizeText(
                                  "${userModel.prenom} ${userModel.nom}",
                                  maxLines: 1,
                                )
                              : Container()
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
            PopupMenuButton<MenuItem>(
              onSelected: (item) => MenuOptions().onSelected(context, item),
              itemBuilder: (context) => [
                ...MenuItems.itemsFirst.map(MenuOptions().buildItem).toList(),
                const PopupMenuDivider(),
                ...MenuItems.itemsSecond.map(MenuOptions().buildItem).toList(),
              ],
            )
          ],
        ),
      ],
    );
  }
}
