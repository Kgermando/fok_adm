import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:routemaster/routemaster.dart';

class RhNav extends StatefulWidget {
  const RhNav({Key? key, required this.pageCurrente}) : super(key: key);
  final String pageCurrente;

  @override
  State<RhNav> createState() => _RhNavState();
}

class _RhNavState extends State<RhNav> {
  bool isOpenRh = false;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    return ExpansionTile(
      leading: const Icon(
        Icons.group,
        size: 30.0
      ),
      title: Text('RH', style: headline6),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenRh = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        DrawerWidget(
          selected: widget.pageCurrente == '/rh-dashboard',
          icon: Icons.dashboard,
          sizeIcon: 20.0,
          title: 'Dashboard',
          style: bodyText1!,
          onTap: () {
            Routemaster.of(context).replace('/rh-dashboard');
            Routemaster.of(context).pop();
          }
        ),
        DrawerWidget(
          selected: widget.pageCurrente == '/rh-paiements',
          icon: Icons.real_estate_agent_sharp,
          sizeIcon: 20.0,
          title: 'Liste des paiements',
          style: bodyText1,
          onTap: () {
            Routemaster.of(context).replace('/rh-paiements');
            Routemaster.of(context).pop();
          }
        ),
        DrawerWidget(
          selected: widget.pageCurrente == '/rh-salaires',
          icon: Icons.money_sharp,
          sizeIcon: 20.0,
          title: 'Salaires des agents',
          style: bodyText1,
          onTap: () {
            Routemaster.of(context).replace('/rh-salaires');
            Routemaster.of(context).pop();
          }
        ),
        DrawerWidget(
          selected: widget.pageCurrente == '/rh-presences',
          icon: Icons.person,
          sizeIcon: 20.0,
          title: 'Présences des agents',
          style: bodyText1,
          onTap: () {
            Routemaster.of(context).replace('/rh-presences');
            Routemaster.of(context).pop();
          }
        ),
        DrawerWidget(
          selected: widget.pageCurrente == '/rh-agents',
          icon: Icons.group,
          sizeIcon: 20.0,
          title: 'Liste des agents',
          style: bodyText1,
          onTap: () {
            Routemaster.of(context).replace('/rh-agents');
            Routemaster.of(context).pop();
          }
        ),
        
      ],
    );
  }
}