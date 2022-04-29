import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class ComptabiliteNav extends StatefulWidget {
  const ComptabiliteNav({ Key? key, required this.pageCurrente }) : super(key: key);
  final String pageCurrente;

  @override
  State<ComptabiliteNav> createState() => _ComptabiliteNavState();
}

class _ComptabiliteNavState extends State<ComptabiliteNav> {
  bool isOpenComptabilite = false;

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    return ExpansionTile(
      leading: const Icon(Icons.table_view, size: 30.0),
      title: AutoSizeText('Comptabilités', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenComptabilite = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        DrawerWidget(
            selected: widget.pageCurrente == ComptabiliteRoutes.comptabiliteDashboard,
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Dashboard',
            style: bodyText1!,
            onTap: () {
              Routemaster.of(context).replace(ComptabiliteRoutes.comptabiliteDashboard);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == ComptabiliteRoutes.comptabiliteDD,
            icon: Icons.manage_accounts,
            sizeIcon: 15.0,
            title: 'Directeur département',
            style: bodyText2!,
            onTap: () {
              Routemaster.of(context).replace(ComptabiliteRoutes.comptabiliteDD);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected:
                widget.pageCurrente == ComptabiliteRoutes.comptabiliteBilan,
            icon: Icons.arrow_right,
            sizeIcon: 15.0,
            title: 'Bilan',
            style: bodyText2,
            onTap: () {
              Routemaster.of(context)
                  .replace(ComptabiliteRoutes.comptabiliteBilan);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == ComptabiliteRoutes.comptabiliteJournal,
            icon: Icons.arrow_right,
            sizeIcon: 15.0,
            title: 'Journal',
            style: bodyText2,
            onTap: () {
              Routemaster.of(context)
                  .replace(ComptabiliteRoutes.comptabiliteJournal);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected:
                widget.pageCurrente == ComptabiliteRoutes.comptabiliteValorisation,
            icon: Icons.arrow_right,
            sizeIcon: 15.0,
            title: 'Valorisation',
            style: bodyText2,
            onTap: () {
              Routemaster.of(context)
                  .replace(ComptabiliteRoutes.comptabiliteValorisation);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected:
                widget.pageCurrente == ComptabiliteRoutes.comptabiliteAmortissement,
            icon: Icons.arrow_right,
            sizeIcon: 15.0,
            title: 'Amortissement',
            style: bodyText2,
            onTap: () {
              Routemaster.of(context)
                  .replace(ComptabiliteRoutes.comptabiliteAmortissement);
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