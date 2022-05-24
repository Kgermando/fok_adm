import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/api/logistiques/carburant_api.dart';
import 'package:fokad_admin/src/api/logistiques/entretien_api.dart';
import 'package:fokad_admin/src/api/logistiques/etat_materiel_api.dart';
import 'package:fokad_admin/src/api/logistiques/immobiler_api.dart';
import 'package:fokad_admin/src/api/logistiques/mobilier_api.dart';
import 'package:fokad_admin/src/api/logistiques/trajet_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
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
  int itemCount = 0;

  int anguinsapprobationDD = 0;
  int carburantCount = 0;
  int trajetsCount = 0;
  int immobiliersCount = 0;
  int mobiliersCount = 0;
  int entretiensCount = 0;
  int etatmaterielsCount = 0;

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
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');

  Future<void> getData() async {
    var userModel = await AuthApi().getUserId();
    var anguins = await AnguinApi().getAllData();
    var carburants = await CarburantApi().getAllData();
    var trajets = await TrajetApi().getAllData();
    var immobiliers = await ImmobilierApi().getAllData();
    var mobiliers = await MobilierApi().getAllData();
    var entretiens = await EntretienApi().getAllData();
    var etatmateriels = await EtatMaterielApi().getAllData();

    setState(() {
      user = userModel;
      anguinsapprobationDD = anguins.length;
      carburantCount = carburants.length;
      trajetsCount = trajets.length;
      immobiliersCount = immobiliers.length;
      mobiliersCount = mobiliers.length;
      entretiensCount = entretiens.length;
      etatmaterielsCount = etatmateriels.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    double userRole = double.parse(user.role);

    itemCount =  anguinsapprobationDD + carburantCount + trajetsCount + 
      immobiliersCount + mobiliersCount + entretiensCount + etatmaterielsCount;

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
        if (userRole <= 2)
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
        if (userRole <= 2)
        DrawerWidget(
            selected: widget.pageCurrente == LogistiqueRoutes.logDD,
            icon: Icons.manage_accounts,
            sizeIcon: 20.0,
            title: 'Directeur de departement',
            style: bodyText1!,
            badge: Badge(
              showBadge: (itemCount >= 1) ? true : false,
              badgeColor: Colors.teal,
              badgeContent: Text('$itemCount',
                  style: const TextStyle(fontSize: 10.0, color: Colors.white)),
              child: const Icon(Icons.notifications),
            ),
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
            style: bodyText1!,
            onTap: () {
              Routemaster.of(context).replace(RhRoutes.rhPerformence);
              // Navigator.of(context).pop();
            }),
      ],
    );
  }
}
