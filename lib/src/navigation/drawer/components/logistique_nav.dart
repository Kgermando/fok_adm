import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart'; 
import 'package:fokad_admin/src/api/notifications/devis/devis_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/carburant_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/engin_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/entretien_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/etat_materiel_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/immobilier_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/mobilier_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/trajet_notify_api.dart'; 
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

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
  int etatBesoinCount = 0;

  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getData();
    });
    super.initState();
  }

  @override
  dispose() {
    timer!.cancel();
    super.dispose();
  }
 

  Future<void> getData() async { 

    var anguinsCountNotify = await EnginNotifyApi().getCountDD();
    var acarburantsCountNotify = await CarburantNotifyApi().getCountDD();
    var trajetsCountNotify = await TrajetNotifyApi().getCountDD();
    var immobiliersCountNotify = await ImmobilierNotifyApi().getCountDD();
    var mobiliersCountNotify = await MobilierNotifyApi().getCountDD();
    var entretiensCountNotify = await EntretienNotifyApi().getCountDD();
    var etatmaterielsCountNotify = await EtatMaterielNotifyApi().getCountDD();

    // Etat de Besoins
    var etatBesionsCountNotify = await DevisNotifyApi().getCountDD();

    if (mounted) {
      setState(() { 
        anguinsapprobationDD = anguinsCountNotify.count; 
        carburantCount = acarburantsCountNotify.count;  
        trajetsCount = trajetsCountNotify.count; 
        immobiliersCount = immobiliersCountNotify.count;    
        mobiliersCount = mobiliersCountNotify.count; 
        entretiensCount = entretiensCountNotify.count;  
        etatmaterielsCount = etatmaterielsCountNotify.count;  
        etatBesoinCount = etatBesionsCountNotify.count;

        itemCount = anguinsapprobationDD +
            carburantCount +
            trajetsCount +
            immobiliersCount +
            mobiliersCount +
            entretiensCount +
            etatmaterielsCount +
            etatBesoinCount;
      }); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    return FutureBuilder<UserModel>(
        future: AuthApi().getUserId(),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            UserModel? user = snapshot.data;
            int userRole = int.parse(user!.role);
            return ExpansionTile(
              leading: const Icon(Icons.brightness_low, size: 30.0),
              title: AutoSizeText('Logistique', maxLines: 1, style: bodyLarge),
              initiallyExpanded:
                  (user.departement == 'Logistique') ? true : false,
              onExpansionChanged: (val) {
                setState(() {
                  isOpen = !val;
                });
              },
              trailing: const Icon(Icons.arrow_drop_down),
              children: [
                if (userRole <= 2)
                  DrawerWidget(
                      selected:
                          widget.pageCurrente == LogistiqueRoutes.logDashboard,
                      icon: Icons.dashboard,
                      sizeIcon: 20.0,
                      title: 'Dashboard',
                      style: bodyText1!,
                      onTap: () {
                        Navigator.pushNamed(
                            context, LogistiqueRoutes.logDashboard);
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
                            style: const TextStyle(
                                fontSize: 10.0, color: Colors.white)),
                        child: const Icon(Icons.notifications),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, LogistiqueRoutes.logDD);
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
                        selected: widget.pageCurrente ==
                            LogistiqueRoutes.logAnguinAuto,
                        icon: Icons.arrow_right,
                        sizeIcon: 15.0,
                        title: 'Angins',
                        style: bodyText2!,
                        onTap: () {
                          Navigator.pushNamed(
                              context, LogistiqueRoutes.logAnguinAuto);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected: widget.pageCurrente ==
                            LogistiqueRoutes.logCarburantAuto,
                        icon: Icons.arrow_right,
                        sizeIcon: 15.0,
                        title: 'Carburant',
                        style: bodyText2,
                        onTap: () {
                          Navigator.pushNamed(
                              context, LogistiqueRoutes.logCarburantAuto);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected: widget.pageCurrente ==
                            LogistiqueRoutes.logTrajetAuto,
                        icon: Icons.arrow_right,
                        sizeIcon: 15.0,
                        title: 'Trajets',
                        style: bodyText2,
                        onTap: () {
                          Navigator.pushNamed(
                              context, LogistiqueRoutes.logTrajetAuto);
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
                        selected: widget.pageCurrente ==
                            LogistiqueRoutes.logMobilierMateriel,
                        icon: Icons.arrow_right,
                        sizeIcon: 15.0,
                        title: 'Mobiliers',
                        style: bodyText2,
                        onTap: () {
                          Navigator.pushNamed(
                              context, LogistiqueRoutes.logMobilierMateriel);
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
                          Navigator.pushNamed(
                              context, LogistiqueRoutes.logImmobilierMateriel);
                          // Navigator.of(context).pop();
                        }),
                    DrawerWidget(
                        selected: widget.pageCurrente ==
                            LogistiqueRoutes.logEtatMateriel,
                        icon: Icons.arrow_right,
                        sizeIcon: 15.0,
                        title: 'Etat materiels',
                        style: bodyText2,
                        onTap: () {
                          Navigator.pushNamed(
                              context, LogistiqueRoutes.logEtatMateriel);
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
                        selected: widget.pageCurrente ==
                            LogistiqueRoutes.logEntretien,
                        icon: Icons.arrow_right,
                        sizeIcon: 15.0,
                        title: 'Entretiens',
                        style: bodyText2,
                        onTap: () {
                          Navigator.pushNamed(
                              context, LogistiqueRoutes.logEntretien);
                          // Navigator.of(context).pop();
                        }),
                  ],
                ),
                DrawerWidget(
                    selected:
                        widget.pageCurrente == LogistiqueRoutes.logEtatBesoin,
                    icon: Icons.content_paste,
                    sizeIcon: 20.0,
                    title: 'Etat de besoin',
                    style: bodyText1!,
                    onTap: () {
                      Navigator.pushNamed(
                          context, LogistiqueRoutes.logEtatBesoin);
                      // Navigator.of(context).pop();
                    }),
                DrawerWidget(
                    selected: widget.pageCurrente == RhRoutes.rhPerformence,
                    icon: Icons.multiline_chart_sharp,
                    sizeIcon: 20.0,
                    title: 'Performences',
                    style: bodyText1,
                    onTap: () {
                      Navigator.pushNamed(context, RhRoutes.rhPerformence);
                      // Navigator.of(context).pop();
                    }),
                DrawerWidget(
                    selected: widget.pageCurrente == ArchiveRoutes.archives,
                    icon: Icons.archive,
                    sizeIcon: 20.0,
                    title: 'Archives',
                    style: bodyLarge!,
                    onTap: () {
                      Navigator.pushNamed(context, ArchiveRoutes.archives);
                      // Navigator.of(context).pop();
                    }),
              ],
            );
          } else {
            return Column(
              children: [loading(), const SizedBox(height: p20)],
            );
          }
        });
  }
}
