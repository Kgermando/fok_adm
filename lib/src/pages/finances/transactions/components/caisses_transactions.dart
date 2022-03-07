import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/utils/pluto_grid.dart';
import 'package:fokad_admin/src/widgets/dialog_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:provider/provider.dart';

class CaisseTransactions extends StatefulWidget {
  const CaisseTransactions({Key? key}) : super(key: key);

  @override
  State<CaisseTransactions> createState() => _CaisseTransactionsState();
}

class _CaisseTransactionsState extends State<CaisseTransactions> {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<Controller>().scaffoldKey,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            transactionsDialog();
            print('Dialog');
          },
          child: const Icon(Icons.add),
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
                      const CustomAppbar(title: 'Caisse'),
                      Expanded(
                          child: Scrollbar(
                        controller: controller,
                        child: ListView(
                          controller: controller,
                          children: const [
                            Text("Caisse Finance"),
                            SizedBox(
                              height: p20,
                            ),
                            ColumnFilteringScreen()
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

  transactionsDialog() {
    return dialogWidget(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          TitleWidget(title: 'Nouveau caisse'), 
          Text('data')
        ],
      ),
    );
  }
}
