import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';


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

    return ExpansionTile(
      leading: const Icon(Icons.archive, size: 30.0),
      title: AutoSizeText('Archives', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpen = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: const [
        // DrawerWidget(
        //     selected: widget.pageCurrente == ArchiveRoutes.arcihves,
        //     icon: Icons.archive,
        //     sizeIcon: 20.0,
        //     title: 'Archives',
        //     style: bodyLarge!,
        //     onTap: () {
        //       Navigator.pushNamed(context, ArchiveRoutes.arcihves);
        //       // Navigator.of(context).pop();
        //     }),
      ],
    );
  }
}
