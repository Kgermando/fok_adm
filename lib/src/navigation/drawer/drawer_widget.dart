import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key, 
    required this.selected, 
    this.selectedTileColor, 
    required this.icon, 
    required this.title, 
    required this.onTap}) : super(key: key);

  final bool selected;
  final Color? selectedTileColor;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedTileColor: selectedTileColor,
      leading: Icon(
        icon, 
        color: selected ? themeColor : Colors.black
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? themeColor : Colors.black
        ),
      ),
      onTap: onTap
    );
  }
}
