import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
<<<<<<< HEAD
import 'package:fokad_admin/src/routes/routes.dart';
=======
import 'package:fokad_admin/src/pages/auth/profil_page.dart';
>>>>>>> parent of 80eb0c4 (add logout done)
import 'package:fokad_admin/src/utils/menu_items.dart';
import 'package:routemaster/routemaster.dart';

class MenuOptions with ChangeNotifier {
  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem(
      value: item,
      child: Row(
        children: [
          Icon(item.icon, size: 20),
          const SizedBox(width: 12),
          Text(item.text)
        ],
      ));

  void onSelected(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.itemProfile:
        Routemaster.of(context).push('/profile');
        break;

      case MenuItems.itemHelp:
        Routemaster.of(context).push('/helps');
        break;

      case MenuItems.itemSettings:
        Routemaster.of(context).push('/settings');
        break;

      case MenuItems.itemLogout:
        // Remove stockage jwt here.
<<<<<<< HEAD
        AuthApi().logout();
        
        Routemaster.of(context).replace(UserRoutes.login);
=======
        const storage = FlutterSecureStorage();
        storage.deleteAll();
        Routemaster.of(context).replace('/');
>>>>>>> parent of 80eb0c4 (add logout done)
    }
  }
}
