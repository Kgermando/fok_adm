import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
import 'package:fokad_admin/src/routes/routes.dart';
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
        Routemaster.of(context).replace(UserRoutes.profile);
        break;

      case MenuItems.itemHelp:
        Routemaster.of(context).replace(UserRoutes.helps);
        break;

      case MenuItems.itemSettings:
        Routemaster.of(context).replace(UserRoutes.settings);
        break;

      case MenuItems.itemLogout:
        // Remove stockage jwt here.
        AuthApi().logout();
        Routemaster.of(context).replace(UserRoutes.login);
    }
  }
}
