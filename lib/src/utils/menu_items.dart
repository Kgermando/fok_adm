import 'package:flutter/material.dart';
import 'package:fokad_admin/src/models/menu_item.dart';

class MenuItems {
  static const List<MenuItem> itemsFirst = [
    itemProfile,
    itemHelp,
    itemSettings,
  ];

  static const List<MenuItem> itemsSecond = [
    itemLogout,
  ];

  static const itemProfile = MenuItem(
    text: 'Profil',
    icon: Icons.person,
  );

  static const itemHelp = MenuItem(text: 'Aide', icon: Icons.help);

  static const itemSettings = MenuItem(
    text: 'Settings',
    icon: Icons.settings,
  );

  static const itemLogout = MenuItem(text: 'Déconnexion', icon: Icons.logout);
}

class MenuStats {
  static const List<MenuStat> itemsFirst = [
    itemDay,
    itemWeek,
    itemMouth,
    itemYear,
  ];

  static const itemDay = MenuStat(text: 'Jour');
  static const itemWeek = MenuStat(text: 'Semaine');
  static const itemMouth = MenuStat(text: 'Mois');
  static const itemYear = MenuStat(text: 'Année');
}
