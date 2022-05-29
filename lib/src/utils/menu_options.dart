import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/menu_items.dart';

class MenuOptions with ChangeNotifier {
  PopupMenuItem<MenuItemModel> buildItem(MenuItemModel item) => PopupMenuItem(
      value: item,
      child: Row(
        children: [
          Icon(item.icon, size: 20),
          const SizedBox(width: 12),
          Text(item.text)
        ],
      ));

  void onSelected(BuildContext context, MenuItemModel item) {
    switch (item) {
      case MenuItems.itemProfile:
        Navigator.pushNamed(context, UserRoutes.profile);
        break;

      case MenuItems.itemHelp:
        Navigator.pushNamed(context, UserRoutes.helps);
        break;

      case MenuItems.itemSettings:
        Navigator.pushNamed(context, UserRoutes.settings);
        break;

      case MenuItems.itemLogout:
        // Remove stockage jwt here.
        AuthApi().logout();
        Navigator.pushNamed(context, UserRoutes.logout);
    }
  }
}
