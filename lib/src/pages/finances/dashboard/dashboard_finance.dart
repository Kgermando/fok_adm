import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/widgets/animation_line_chart.dart';
import 'package:fokad_admin/src/widgets/dashboard_card_widget.dart';
import 'package:provider/provider.dart';

class DashboardFinance extends StatefulWidget {
  const DashboardFinance({ Key? key }) : super(key: key);

  @override
  State<DashboardFinance> createState() => _DashboardFinanceState();
}

class _DashboardFinanceState extends State<DashboardFinance> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    double montant = 25312.00;

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
                      const CustomAppbar(title: 'Finance Dashboard'),
                      Expanded(
                        child: ListView(
                         controller: scrollController,
                        children: [
                          const SizedBox(height: p10),
                          Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            spacing: 12.0,
                            runSpacing: 12.0,
                            direction: Axis.horizontal,
                            children: [
                              DashboardCardWidget(
                                title: 'CAISSE',
                                icon: Icons.view_stream_outlined,
                                montant: '$montant',
                                color: Colors.yellow.shade700,
                                colorText: Colors.black,
                              ),
                              DashboardCardWidget(
                                title: 'BANQUE',
                                icon: Icons.business,
                                montant: '$montant',
                                color: Colors.green.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                title: 'DETTES',
                                icon: Icons.money_off,
                                montant: '$montant',
                                color: Colors.red.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                title: 'CREANCES',
                                icon: Icons.money_off_csred,
                                montant: '$montant',
                                color: Colors.purple.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                title: 'FIN. EXTERNE',
                                icon: Icons.money_outlined,
                                montant: '$montant',
                                color: Colors.teal.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                title: 'DEPENSES',
                                icon: Icons.monetization_on,
                                montant: '$montant',
                                color: Colors.orange.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                title: 'DIPONIBLES',
                                icon: Icons.attach_money,
                                montant: '$montant',
                                color: Colors.blue.shade700,
                                colorText: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Responsive.isDesktop(context)
                              ? Row(
                                  children: const [
                                    Expanded(
                                        child: AnimationLineChart(
                                            title: 'CAISSE')),
                                    Expanded(
                                        child: AnimationLineChart(
                                            title: 'BANQUE')),
                                  ],
                                )
                              : Column(
                                  children: const [
                                    AnimationLineChart(title: 'CAISSE'),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    AnimationLineChart(title: 'BANQUE'),
                                  ],
                                ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Responsive.isDesktop(context)
                              ? Row(
                                  children: const [
                                    Expanded(
                                        child: AnimationLineChart(
                                            title: 'DETTES')),
                                    Expanded(
                                        child: AnimationLineChart(
                                            title: 'CREANCES')),
                                  ],
                                )
                              : Column(
                                  children: const [
                                    AnimationLineChart(title: 'DETTES'),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    AnimationLineChart(title: 'CREANCES'),
                                  ],
                                ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Responsive.isDesktop(context)
                              ? Row(
                                  children: const [
                                    Expanded(
                                        child: AnimationLineChart(
                                            title: 'FINANCEMENTS EXTERNE')),
                                    Expanded(
                                        child: AnimationLineChart(
                                            title: 'DEPENSES')),
                                  ],
                                )
                              : Column(
                                  children: const [
                                    AnimationLineChart(
                                        title: 'FINANCEMENTS EXTERNE'),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    AnimationLineChart(title: 'DEPENSES'),
                                  ],
                                ),
                        ],
                        )
                      )
                      
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