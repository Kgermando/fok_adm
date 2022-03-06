import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:provider/provider.dart';

class TransactionsFinance extends StatefulWidget {
  const TransactionsFinance({ Key? key }) : super(key: key);

  @override
  State<TransactionsFinance> createState() => _TransactionsFinanceState();
}

class _TransactionsFinanceState extends State<TransactionsFinance> {
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
                    const CustomAppbar(title: 'Finance Transactions'),
                      Expanded(
                        child: ListView(
                          children: const [
                            Text("Transactions Finance"),
                          ],
                        )
                      )
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
  }
}