import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:provider/provider.dart';

class BudgetFinance extends StatefulWidget {
  const BudgetFinance({ Key? key }) : super(key: key);

  @override
  State<BudgetFinance> createState() => _BudgetFinanceState();
}

class _BudgetFinanceState extends State<BudgetFinance> {
  @override
  Widget build(BuildContext context) {
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
                      const CustomAppbar(title: 'Finance Budget'),
                      Expanded(
                          child: ListView(
                        children: [
                          const Text("Finance Budget"),
                          // tableList()
                        ],
                      ))
                    ],
                  ),
              ),
            ),
          ],
        ),
      )
    );
  }

  // Widget tableList() {
  //   return Padding(
  //     padding: const EdgeInsets.all(p16),
  //     child: PaginatedDataTable(
  //         columnSpacing: 12,
  //         horizontalMargin: 12,
  //         source: ,
  //         columns: [
  //           DataColumn2(
  //             label: Text('Column A'),
  //             size: ColumnSize.L,
  //           ),
  //           DataColumn(
  //             label: Text('Column B'),
  //           ),
  //           DataColumn(
  //             label: Text('Column C'),
  //           ),
  //           DataColumn(
  //             label: Text('Column D'),
  //           ),
  //           DataColumn(
  //             label: Text('Column NUMBERS'),
  //             numeric: true,
  //             onSort: () {}
  //           ),
  //         ],
  //         rows: List<DataRow>.generate(
  //             100,
  //             (index) => DataRow(cells: [
  //                   DataCell(Text('A' * (10 - index % 10))),
  //                   DataCell(Text('B' * (10 - (index + 5) % 10))),
  //                   DataCell(Text('C' * (15 - (index + 5) % 10))),
  //                   DataCell(Text('D' * (15 - (index + 10) % 10))),
  //                   DataCell(Text(((index + 0.1) * 25.4).toString()))
  //                 ]))),
  //   );
  // }
}