import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/agenda_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/agenda_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/add_agenda.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/agenda_card_widget.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/detail_agenda.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class AgendaMarketing extends StatefulWidget {
  const AgendaMarketing({Key? key}) : super(key: key);

  @override
  State<AgendaMarketing> createState() => _AgendaMarketingState();
}

class _AgendaMarketingState extends State<AgendaMarketing> {
  Timer? timer;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  @override
  initState() {
    timer = Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      getData();
    }));
    super.initState();
  }

  @override
  dispose() {
    timer!.cancel();
    super.dispose();
  }

  List<AgendaModel> agendaList = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var agenda = await AgendaApi().getAllData();
    setState(() {
      user = userModel;
      agendaList = agenda
          .where((element) => element.signature == user!.matricule)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Nouvel agenda',
            child: const Icon(Icons.add),
            onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddAgenda(),
                  ))
                }),
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
                          title: 'Agenda',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: buildAgenda())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildAgenda() {
    return StaggeredGrid.count(
      crossAxisCount: 6,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: List.generate(agendaList.length, (index) {
        print(agendaList);
        final agenda = agendaList[index];
        final color = _lightColors[index % _lightColors.length];
        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DetailAgenda(agendaModel: agenda, color: color),
            ));
          },
          child:
              AgendaCardWidget(agendaModel: agenda, index: index, color: color),
        );
      }),
    );
  }
}
