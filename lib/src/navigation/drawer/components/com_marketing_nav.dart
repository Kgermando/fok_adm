import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class ComMarketing extends StatefulWidget {
  const ComMarketing({ Key? key, required this.pageCurrente }) : super(key: key);
  final String pageCurrente;

  @override
  State<ComMarketing> createState() => _ComMarketingState();
}

class _ComMarketingState extends State<ComMarketing> {
  bool isOpenBudget = false;

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    return ExpansionTile(
      leading: const Icon(Icons.fact_check, size: 30.0),
      title: AutoSizeText('Comm. & Marketing', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenBudget = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        DrawerWidget(
            selected: widget.pageCurrente == ComMarketingRoutes.comMarketingDashboard,
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Dashboard',
            style: bodyText1!,
            onTap: () {
              Routemaster.of(context).replace(
                ComMarketingRoutes.comMarketingDashboard,
              );
              // Routemaster.of(context).pop();
            }),
      ],
    );
  }
}