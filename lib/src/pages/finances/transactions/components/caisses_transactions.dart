import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/caisse_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/caisse_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/components/caisses/table_caisse.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/type_operation.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class CaisseTransactions extends StatefulWidget {
  const CaisseTransactions({Key? key}) : super(key: key);

  @override
  State<CaisseTransactions> createState() => _CaisseTransactionsState();
}

class _CaisseTransactionsState extends State<CaisseTransactions> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: speedialWidget(),
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
                          title: 'Livre de Caisse',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableCaisse())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  SpeedDial speedialWidget() {
    return SpeedDial(
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.upload),
          foregroundColor: Colors.black,
          backgroundColor: Colors.yellow.shade700,
          label: 'Décaissement',
          onPressed: () {
            Routemaster.of(context)
                .replace(FinanceRoutes.transactionsCaisseDecaissement);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.file_download),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Encaissement',
          onPressed: () {
            Routemaster.of(context)
                .replace(FinanceRoutes.transactionsCaisseEncaissement);
          },
        ),
      ],
    );
  }

  
}
