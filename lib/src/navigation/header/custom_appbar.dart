import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/header/header_item.dart';
import 'package:fokad_admin/src/utils/menu_items.dart';
import 'package:fokad_admin/src/utils/menu_options.dart';
import 'package:badges/badges.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({Key? key, required this.title, required this.controllerMenu}) : super(key: key);

  final String title;
  final VoidCallback controllerMenu;

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
                onPressed: widget.controllerMenu,
                icon: const Icon(
                  Icons.menu,
                ),
              ),
            HeaderItem(title: widget.title),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: Badge(
                  badgeContent: const Text('33',
                      style: TextStyle(fontSize: 10.0, color: Colors.white)),
                  child: const Icon(Icons.mail),
                )),
            IconButton(
                onPressed: () {},
                icon: Badge(
                  badgeContent: const Text('9+',
                      style: TextStyle(fontSize: 10.0, color: Colors.white)),
                  child: const Icon(Icons.notifications),
                )),
            const SizedBox(width: 10.0),
            InkWell(
              onTap: () {},
              child: FutureBuilder<UserModel>(
                  future: AuthApi().getUserId(),
                  builder: (BuildContext context,
                      AsyncSnapshot<UserModel> snapshot) {
                    if (snapshot.hasData) {
                      UserModel? userModel = snapshot.data;
                      // print('photo ${userModel!.photo}');
                      return Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                          // (userModel.photo != '' || userModel.photo != null)
                          //     ? Image.network(
                          //         userModel.photo!,
                          //         width: 30,
                          //         height: 30,
                          //         fit: BoxFit.cover,
                          //       )
                          //     : Image.asset(
                          //         'assets/images/logo.png',
                          //         width: 30,
                          //         height: 30,
                          //         fit: BoxFit.cover,
                          //       ),
                          Responsive.isDesktop(context)
                              ? Text("${userModel!.prenom} ${userModel.nom}")
                              : Container()
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
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
