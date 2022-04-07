import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:provider/provider.dart';

class AddPaiementSalaire extends StatefulWidget {
  const AddPaiementSalaire({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<AddPaiementSalaire> createState() => _AddPaiementSalaireState();
}

class _AddPaiementSalaireState extends State<AddPaiementSalaire> {
  final ScrollController _controllerScroll = ScrollController();

  final TextEditingController salaireController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      const CustomAppbar(title: 'Nouveau salaire'),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addPaiementSalaireWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPaiementSalaireWidget() {
    return Container();
  }
}
