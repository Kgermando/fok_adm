import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class LogistiqueNav extends StatefulWidget {
  const LogistiqueNav({Key? key, required this.pageCurrente}) : super(key: key);
  final String pageCurrente;

  @override
  State<LogistiqueNav> createState() => _LogistiqueNavState();
}

class _LogistiqueNavState extends State<LogistiqueNav> {
  bool isOpen = false;
  bool isOpenAutomobile = false;
  bool isOpenMateriels = false;

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    return ExpansionTile(
      leading: const Icon(Icons.brightness_low, size: 30.0),
      title: AutoSizeText('Logistique', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpen = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        DrawerWidget(
            selected: widget.pageCurrente == LogistiqueRoutes.logDashboard,
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Dashboard',
            style: bodyText1!,
            onTap: () {
              Routemaster.of(context).replace(LogistiqueRoutes.logDashboard);
              // Navigator.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == LogistiqueRoutes.logDD,
            icon: Icons.manage_accounts,
            sizeIcon: 20.0,
            title: 'Directeur de departement',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(LogistiqueRoutes.logDD);
              // Navigator.of(context).pop();
            }),
        ExpansionTile(
          leading: const Icon(Icons.car_rental, size: 20.0),
          title: Text('Automobile', style: bodyText1),
          initiallyExpanded: false,
          onExpansionChanged: (val) {
            setState(() {
              isOpenAutomobile = !val;
            });
          },
          children: [
            DrawerWidget(
                selected: widget.pageCurrente == LogistiqueRoutes.logAnguinAuto,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Anguins',
                style: bodyText2!,
                onTap: () {
                  Routemaster.of(context)
                      .replace(LogistiqueRoutes.logAnguinAuto);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == LogistiqueRoutes.logCarburantAuto,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Carburant',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(LogistiqueRoutes.logCarburantAuto);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente == LogistiqueRoutes.logTrajetAuto,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Trajets',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(LogistiqueRoutes.logTrajetAuto);
                  // Navigator.of(context).pop();
                }),
          ],
        ),
        ExpansionTile(
          leading: const Icon(Icons.laptop_windows, size: 20.0),
          title: Text('Materiels', style: bodyText1),
          initiallyExpanded: false,
          onExpansionChanged: (val) {
            setState(() {
              isOpenMateriels = !val;
            });
          },
          children: [
            DrawerWidget(
                selected:
                    widget.pageCurrente == LogistiqueRoutes.logEtatMateriel,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Etat materiels',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(LogistiqueRoutes.logEtatMateriel);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == LogistiqueRoutes.logMobilierMateriel,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Mobiliers',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(LogistiqueRoutes.logMobilierMateriel);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    LogistiqueRoutes.logImmobilierMateriel,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Immobiliers',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(LogistiqueRoutes.logImmobilierMateriel);
                  // Navigator.of(context).pop();
                }),
          ],
        ),
        ExpansionTile(
          leading: const Icon(Icons.settings, size: 20.0),
          title: Text('Entretiens & Maintenance', style: bodyText1),
          initiallyExpanded: false,
          onExpansionChanged: (val) {
            setState(() {
              isOpenMateriels = !val;
            });
          },
          children: [
            DrawerWidget(
                selected: widget.pageCurrente == LogistiqueRoutes.logEntretien,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Entretiens',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(LogistiqueRoutes.logEntretien);
                  // Navigator.of(context).pop();
                }),
          ],
        ),
        DrawerWidget(
            selected: widget.pageCurrente == RhRoutes.rhPerformence,
            icon: Icons.multiline_chart_sharp,
            sizeIcon: 20.0,
            title: 'Performences',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(RhRoutes.rhPerformence);
              // Navigator.of(context).pop();
            }),
      ],
    );
  }
}
