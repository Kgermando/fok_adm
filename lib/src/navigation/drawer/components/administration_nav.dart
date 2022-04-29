import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/creance_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/models/finances/creances_model.dart';
import 'package:fokad_admin/src/models/finances/dette_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class AdministrationNav extends StatefulWidget {
  const AdministrationNav({Key? key, required this.pageCurrente})
      : super(key: key);
  final String pageCurrente;

  @override
  State<AdministrationNav> createState() => _AdministrationNavState();
}

class _AdministrationNavState extends State<AdministrationNav> {
  bool isOpenAdmin = false;

  int agentInactifs = 0;
  int countPaie = 0;
  int nbrCreance = 0;
  int nbrDette = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    UserModel userLoggIn = await AuthApi().getUserId();
    // RH
    List<AgentModel> agents = await AgentsApi().getAllData();

    // FInances
    List<PaiementSalaireModel> paiement =
        await PaiementSalaireApi().getAllData();
    List<CreanceModel?> dataCreanceList = await CreanceApi().getAllData();
    List<DetteModel?> dataDetteList = await DetteApi().getAllData();

    setState(() {
       agentInactifs =
          agents.where((element) => element.statutAgent == false).length;
          
      countPaie =
          paiement.where((element) => element.approbationDG == '-' && element.approbationFin != '-').length;
      nbrCreance = dataCreanceList
          .where((element) => element!.approbationDG == userLoggIn.matricule)
          .length;
      nbrDette = dataDetteList
          .where((element) => element!.approbationDG == userLoggIn.matricule)
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    return ExpansionTile(
      leading: const Icon(
        Icons.admin_panel_settings,
        size: 30.0,
      ),
      title: AutoSizeText('Administration', maxLines: 1,  style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenAdmin = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        DrawerWidget(
            selected: widget.pageCurrente == AdminRoutes.adminDashboard,
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Dashboard',
            style: bodyText1!,
            onTap: () {
              Routemaster.of(context).replace(AdminRoutes.adminDashboard);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == AdminRoutes.adminBudget,
            icon: Icons.fact_check,
            sizeIcon: 20.0,
            title: 'Budgets',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(AdminRoutes.adminBudget);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == AdminRoutes.adminFinance,
            icon: Icons.account_balance,
            sizeIcon: 20.0,
            title: 'Finances',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(AdminRoutes.adminFinance);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == AdminRoutes.adminComptabilite,
            icon: Icons.table_view,
            sizeIcon: 20.0,
            title: 'Comptabilités',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(AdminRoutes.adminComptabilite);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == AdminRoutes.adminRH,
            icon: Icons.group,
            sizeIcon: 20.0,
            title: 'RH',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(AdminRoutes.adminRH);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == AdminRoutes.adminExploitation,
            icon: Icons.work,
            sizeIcon: 20.0,
            title: 'Exploitations',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(AdminRoutes.adminExploitation);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == AdminRoutes.adminCommMarketing,
            icon: Icons.add_business,
            sizeIcon: 20.0,
            title: 'Comm. & Marketing',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(AdminRoutes.adminCommMarketing);
              // Routemaster.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente == AdminRoutes.adminLogistique,
            icon: Icons.home_work,
            sizeIcon: 20.0,
            title: 'Logistiques',
            style: bodyText1,
            onTap: () {
              Routemaster.of(context).replace(AdminRoutes.adminLogistique);
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
      ],
    );
  }
}
