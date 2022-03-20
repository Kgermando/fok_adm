import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/provider/theme_provider.dart';
import 'package:routemaster/routemaster.dart';

class AdministrationNav extends StatefulWidget {
  const AdministrationNav({Key? key, required this.pageCurrente}) : super(key: key);
  final String pageCurrente;

  @override
  State<AdministrationNav> createState() => _AdministrationNavState();
}

class _AdministrationNavState extends State<AdministrationNav> {
  bool isOpenAdmin = false;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    return ExpansionTile(
      leading: const Icon(
        Icons.admin_panel_settings,
        size: 30.0,
      ),
      title: Text('Administration', style: headline6),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenAdmin = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        DrawerWidget(
          selected: widget.pageCurrente == '/admin-dashboard',
          icon: Icons.dashboard,
          sizeIcon: 20.0,
          title: 'Dashboard',
          style: bodyText1!,
          onTap: () {
            Routemaster.of(context).replace('/admin-dashboard');
            Routemaster.of(context).pop();
          }
        ),
        DrawerWidget(
            selected: widget.pageCurrente == '/admin-dashboard',
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Finances',
            style: bodyText1,
            badge: Badge(
              badgeColor: Colors.blue,
              badgeContent: const Text('3',
                  style: TextStyle(fontSize: 10.0, color: Colors.white)),
              child: const Icon(Icons.notifications),
            ),
            onTap: () {
              Routemaster.of(context).replace('/admin-dashboard');
              Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == '/admin-dashboard',
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'RH',
            style: bodyText1,
            badge: Badge(
              badgeColor: Colors.blue,
              badgeContent: const Text('7',
                  style: TextStyle(fontSize: 10.0, color: Colors.white)),
              child: const Icon(Icons.notifications),
            ),
            onTap: () {
              Routemaster.of(context).replace('/admin-dashboard');
              Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == '/admin-dashboard',
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Logistiques',
            style: bodyText1,
            badge: Badge(
              badgeColor: Colors.blue,
              badgeContent: const Text('1',
                  style: TextStyle(fontSize: 10.0, color: Colors.white)),
              child: const Icon(Icons.notifications),
            ),
            onTap: () {
              Routemaster.of(context).replace('/admin-dashboard');
              Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == '/admin-dashboard',
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Comm. & Marketing',
            style: bodyText1,
            badge: Badge(
              badgeColor: Colors.blue,
              badgeContent: const Text('2',
                  style: TextStyle(fontSize: 10.0, color: Colors.white)),
              child: const Icon(Icons.notifications),
            ),
            onTap: () {
              Routemaster.of(context).replace('/admin-dashboard');
              Routemaster.of(context).pop();
            }),
      ],
    );
  }
}