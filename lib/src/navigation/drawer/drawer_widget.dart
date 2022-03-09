import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/provider/theme_provider.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget(
      {Key? key,
      required this.selected,
      this.selectedTileColor,
      required this.icon,
      required this.title,
      required this.onTap, required this.style, required this.sizeIcon})
      : super(key: key);

  final bool selected;
  final Color? selectedTileColor;
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final TextStyle style;
  final double sizeIcon;

  @override
  Widget build(BuildContext context) {
    Color? color;
    if (selected == true) {
      color = themeColor;
    } 
    return ListTile(
        selected: selected,
        selectedTileColor: selectedTileColor,
        leading: Icon(
          icon, 
          size: sizeIcon,
          color: color,
        ),
        title: Text(
          title,
          style: style.copyWith(
            color: color,
          )
        ),
        onTap: onTap);
  }
}
