import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/presence_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/presences/components/table_presence.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class PresenceRh extends StatefulWidget {
  const PresenceRh({Key? key}) : super(key: key);

  @override
  State<PresenceRh> createState() => _PresenceRhState();
}

class _PresenceRhState extends State<PresenceRh> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  initState() {
    getData();
    super.initState();
  }

  List<PresenceModel> presenceList = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var presenceModel = await PresenceApi().getAllData();
    setState(() {
      user = userModel;
      presenceList = presenceModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = presenceList.where((element) => element.created.day == DateTime.now().day);

    return Scaffold(
      key: _key,
      drawer: const DrawerMenu(),
      floatingActionButton:  (p.isNotEmpty) ? Container() : FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, RhRoutes.rhPresenceAdd);
        }
      ),
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
                    CustomAppbar(
                        title: 'Liste des presences',
                        controllerMenu: () =>
                            _key.currentState!.openDrawer()),
                    const Expanded(child: TablePresence())
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
