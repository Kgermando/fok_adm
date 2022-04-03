import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/menu_items.dart';

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
        Navigator.of(context).pushReplacementNamed(UserRoutes.profile);
        break;

      case MenuItems.itemHelp:
        Navigator.of(context).pushReplacementNamed(UserRoutes.helps);
        break;

      case MenuItems.itemSettings:
        Navigator.of(context).pushReplacementNamed(UserRoutes.settings);
        break;

      case MenuItems.itemLogout:
        // Remove stockage jwt here.
        AuthApi().logout();
        Navigator.of(context).pushReplacementNamed(UserRoutes.login);
    }
  }
}
