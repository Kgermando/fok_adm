import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
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

  void onSelected(BuildContext context, MenuItemModel item) async {
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
        final user = await AuthApi().getUserId();
        final userModel = UserModel(
          id: user.id,
          nom: user.nom,
          prenom: user.prenom,
          email: user.email,
          telephone: user.telephone,
          matricule: user.matricule,
          departement: user.departement,
          servicesAffectation: user.servicesAffectation,
          fonctionOccupe: user.fonctionOccupe,
          role: user.role,
          isOnline: false,
          createdAt: user.createdAt,
          passwordHash: user.passwordHash,
          succursale: user.succursale
        );
        await UserApi().updateData(user.id!, userModel);
        AuthApi().logout();
        UserSharedPref().removeIdToken();
        UserSharedPref().removeAccessToken();
        UserSharedPref().removeRefreshToken();
        Navigator.pushNamed(context, UserRoutes.logout);
        Phoenix.rebirth(context);
    }
  }
}
