import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class EtatBesoinNav extends StatefulWidget {
  const EtatBesoinNav({Key? key, required this.pageCurrente}) : super(key: key);
  final String pageCurrente;

  @override
  State<EtatBesoinNav> createState() => _EtatBesoinNavState();
}

class _EtatBesoinNavState extends State<EtatBesoinNav> {
  bool isOpen = false;

  @override
  void initState() {
    getData();

    super.initState();
  }

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: 'false',
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');

  Future<void> getData() async {
    var userModel = await AuthApi().getUserId();
    if (mounted) {
      setState(() {
        user = userModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    double userRole = double.parse(user.role);

    return ExpansionTile(
      leading: const Icon(Icons.note_alt, size: 30.0),
      title: AutoSizeText('Etat de besoins', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpen = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        if (userRole <= 2)
          DrawerWidget(
              selected: widget.pageCurrente == DevisRoutes.devis,
              icon: Icons.note_alt,
              sizeIcon: 20.0,
              title: 'Etat de besoins',
              style: bodyLarge!,
              onTap: () {
                Navigator.pushNamed(context, DevisRoutes.devis);
                // Navigator.of(context).pop();
              }),
      ],
    );
  }
}
