import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class ArchiveNav extends StatefulWidget {
  const ArchiveNav({Key? key, required this.pageCurrente}) : super(key: key);
  final String pageCurrente;

  @override
  State<ArchiveNav> createState() => _ArchiveNavState();
}

class _ArchiveNavState extends State<ArchiveNav> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

    return DrawerWidget(
        selected: widget.pageCurrente == ArchiveRoutes.arcihves,
        icon: Icons.archive,
        sizeIcon: 20.0,
        title: 'Archives',
        style: bodyLarge!,
        onTap: () {
          Routemaster.of(context).replace(
            ArchiveRoutes.arcihves,
          );
          // Navigator.of(context).pop();
        });

    // ExpansionTile(
    //   leading: const Icon(Icons.archive, size: 30.0),
    //   title: AutoSizeText('Archive', maxLines: 1, style: bodyLarge),
    //   initiallyExpanded: false,
    //   onExpansionChanged: (val) {
    //     setState(() {
    //       isOpen = !val;
    //     });
    //   },
    //   trailing: const Icon(Icons.arrow_drop_down),
    //   children: [],
    // );
  }
}
