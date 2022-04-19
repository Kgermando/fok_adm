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
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    return ExpansionTile(
      leading: const Icon(Icons.monetization_on, size: 30.0),
      title: Text('Logistique', style: bodyMedium),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpen = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
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
                  // Routemaster.of(context).pop();
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
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == LogistiqueRoutes.logTrajetAuto,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Trajets',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(LogistiqueRoutes.logTrajetAuto);
                  // Routemaster.of(context).pop();
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
                // Routemaster.of(context).pop();
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
                  // Routemaster.of(context).pop();
                }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == LogistiqueRoutes.logImmobilierMateriel,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Immobiliers',
                style: bodyText2,
                onTap: () {
                  Routemaster.of(context)
                      .replace(LogistiqueRoutes.logImmobilierMateriel);
                  // Routemaster.of(context).pop();
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
                // Routemaster.of(context).pop();
              }),
          ],
        )
      ],
    );
  }
}
