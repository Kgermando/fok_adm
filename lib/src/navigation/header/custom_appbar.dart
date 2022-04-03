import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/controllers/app_state.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
import 'package:fokad_admin/src/navigation/header/header_item.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/utils/menu_items.dart';
import 'package:fokad_admin/src/utils/menu_options.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CustomAppbarState createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  bool isActiveNotification = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                onPressed: context.read<AppState>().openDrawer(context),
                icon: const Icon(
                  Icons.menu,
                ),
              ),
            HeaderItem(title: widget.title),
            const Spacer(),
            IconButton(onPressed: () {}, icon: Badge(
                  badgeContent: const Text('33',
                      style: TextStyle(fontSize: 10.0, color: Colors.white)),
                  child: const Icon(Icons.mail),
                )),
            IconButton(
              onPressed: () {},
              icon: Badge(
                badgeContent: const Text('9+', style: TextStyle(fontSize: 10.0, color: Colors.white)),
                child: const Icon(Icons.notifications),
              )
            ),
            const SizedBox(width: 10.0),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                Responsive.isDesktop(context)
                    ? const Text("Germain Kataku")
                    : Container()
                ],
              ),
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
