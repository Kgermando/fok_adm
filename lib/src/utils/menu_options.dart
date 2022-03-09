import 'package:flutter/material.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
import 'package:fokad_admin/src/pages/auth/profil_page.dart';
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
      // AuthHttp().logout();
      // Phoenix.rebirth(context);
    }
  }
}

// class MenuStatsOptions {
//   PopupMenuItem<MenuStat> buildItem(MenuStat item) => PopupMenuItem(
//       value: item,
//       child: Row(
//         children: [Text(item.text)],
//       ));

//   void onSelected(BuildContext context, MenuStat item) {
//     switch (item) {
//       case MenuStats.itemDay:
//         Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => const DayDashbaord()));
//         break;

//       case MenuStats.itemWeek:
//         Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => const WeekDashboard()));
//         break;

//       case MenuStats.itemMouth:
//         Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => const MouthDashboard()));
//         break;

//       case MenuStats.itemYear:
//         Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => const YearDashboard()));
//         break;
//     }
//   }
// }
