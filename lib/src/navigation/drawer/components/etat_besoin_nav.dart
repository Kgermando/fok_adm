import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class EtatBesoinNav extends StatefulWidget {
  const EtatBesoinNav({Key? key, required this.pageCurrente}) : super(key: key);
  final String pageCurrente;

  @override
  State<EtatBesoinNav> createState() => _EtatBesoinNavState();
}

class _EtatBesoinNavState extends State<EtatBesoinNav> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

    return DrawerWidget(
        selected: widget.pageCurrente == DevisRoutes.devis,
        icon: Icons.note_alt,
        sizeIcon: 20.0,
        title: 'Etat de besoins',
        style: bodyLarge!,
        onTap: () {
          Routemaster.of(context).replace(DevisRoutes.devis);
          // Navigator.of(context).pop();
        });
  }
}
