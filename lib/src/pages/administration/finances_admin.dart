import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/creance_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/creances_model.dart';
import 'package:fokad_admin/src/models/finances/dette_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/finances/transactions/table_creance_admin.dart';
import 'package:fokad_admin/src/pages/administration/components/finances/transactions/table_dette_admin.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:provider/provider.dart';

class FinancesAdmin extends StatefulWidget {
  const FinancesAdmin({Key? key}) : super(key: key);

  @override
  State<FinancesAdmin> createState() => _FinancesAdminState();
}

class _FinancesAdminState extends State<FinancesAdmin> {
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenFin1 = false;
  bool isOpenFin2 = false;

  int nbrCreance = 0;
  int nbrDette = 0;

  @override
  initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    UserModel userLoggIn = await AuthApi().getUserId();
    List<CreanceModel?> dataCreanceList = await CreanceApi().getAllData();
    List<DetteModel?> dataDetteList = await DetteApi().getAllData();
    setState(() {

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
    final headline6 = Theme.of(context).textTheme.headline6;
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomAppbar(title: 'Finances Admin'),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                              color: const Color.fromARGB(255, 126, 170, 214),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title:
                                    Text('Dossier Créances $nbrCreance', style: headline6),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenFin1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: const [TableCreanceAdmin()],
                              ),
                            ),
                            Card(
                              color: const Color.fromARGB(255, 117, 190, 121),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title: Text('Dossier Dettes $nbrDette', style: headline6),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenFin2 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down),
                                children: const [TableDetteAdmin()],
                              ),
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
