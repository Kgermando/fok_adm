import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';


class MailsNAv extends StatefulWidget {
  const MailsNAv({ Key? key, required this.pageCurrente }) : super(key: key);
  final String pageCurrente;


  @override
  State<MailsNAv> createState() => _MailsNAvState();
}

class _MailsNAvState extends State<MailsNAv> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    return ExpansionTile(
      leading: const Icon(Icons.brightness_low, size: 30.0),
      title: AutoSizeText('Mails', maxLines: 1, style: bodyLarge),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpen = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        DrawerWidget(
          selected: widget.pageCurrente == MailRoutes.mails,
          icon: Icons.dashboard,
          sizeIcon: 20.0,
          title: 'Mails',
          style: bodyText1!,
          onTap: () {
            Navigator.pushNamed(context, MailRoutes.mails);
            // Navigator.of(context).pop();
          }
        )
      ],
    );
  }
}