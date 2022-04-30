import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
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
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    return ExpansionTile(
      leading: const Icon(Icons.group, size: 30.0),
      title: AutoSizeText('RH', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenRh = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        DrawerWidget(
            selected: widget.pageCurrente == RhRoutes.rhDashboard,
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Dashboard',
            style: bodyText1!,
            onTap: () {
              Routemaster.of(context).replace(RhRoutes.rhDashboard);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == RhRoutes.rhDD,
            icon: Icons.manage_accounts,
            sizeIcon: 20.0,
            title: 'Directeur de Département',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(RhRoutes.rhDD);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == RhRoutes.rhPaiement,
            icon: Icons.real_estate_agent_sharp,
            sizeIcon: 20.0,
            title: 'Liste des paiements',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(RhRoutes.rhPaiement);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == RhRoutes.rhPresence,
            icon: Icons.checklist_outlined,
            sizeIcon: 20.0,
            title: 'Présences des agents',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(RhRoutes.rhPresence);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == RhRoutes.rhAgent,
            icon: Icons.group,
            sizeIcon: 20.0,
            title: 'Liste des agents',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(RhRoutes.rhAgent);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == DevisRoutes.devis,
            icon: Icons.note_alt,
            sizeIcon: 20.0,
            title: 'Etat de besoin',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(DevisRoutes.devis);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == RhRoutes.rhPerformence,
            icon: Icons.multiline_chart_sharp,
            sizeIcon: 20.0,
            title: 'Performences',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(RhRoutes.rhPerformence);
              // Routemaster.of(context).pop();
            }),
      ],
    );
  }
}
