import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardAdministration extends StatefulWidget {
  const DashboardAdministration({Key? key}) : super(key: key);

  @override
  State<DashboardAdministration> createState() =>
      _DashboardAdministrationState();
}

class _DashboardAdministrationState extends State<DashboardAdministration> {
  @override
  initState() {
    tokeeee();
    super.initState();
  }

  Future<void> tokeeee() async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken"); // pour test
    print('accessToken $accessToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: context.read<Controller>().scaffoldKey,
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
                      const CustomAppbar(title: 'Tableau de bord'),
                      Expanded(
                          child: ListView(
                        children: const [
                          Text("Dashboard Budget"),
                        ],
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
