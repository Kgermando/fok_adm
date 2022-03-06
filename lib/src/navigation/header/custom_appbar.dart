import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
import 'package:fokad_admin/src/navigation/header/header_item.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/utils/menu_items.dart';
import 'package:fokad_admin/src/utils/menu_options.dart';
import 'package:provider/provider.dart';

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
                onPressed: context.read<Controller>().controlMenu,
                icon: const Icon(
                  Icons.menu,
                ),
              ),
            HeaderItem(title: widget.title),
            const Spacer(),
            IconButton(onPressed: () {}, icon: const Icon(Icons.mail)),
            IconButton(
                onPressed: () {},
                icon: isActiveNotification
                    ? const Icon(Icons.notifications_active)
                    : const Icon(Icons.notifications)),
            TextButton.icon(
              onPressed: () {},
              icon: CircleAvatar(
                radius: 30,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              label: Responsive.isDesktop(context)
                  ? const Text("Germain Kataku")
                  : Container(),
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
