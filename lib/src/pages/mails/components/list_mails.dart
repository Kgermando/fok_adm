import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListMails extends StatefulWidget {
  const ListMails(
      {Key? key,
      required this.fullName,
      required this.email,
      required this.cc,
      required this.objet,
      required this.read, required this.dateSend})
      : super(key: key);

  final String fullName;
  final String email;
  final List cc;
  final String objet;
  final bool read;
  final DateTime dateSend;

  @override
  State<ListMails> createState() => _ListMailsState();
}

class _ListMailsState extends State<ListMails> {
  @override
  Widget build(BuildContext context) {
    final String firstLettter = widget.fullName[0];

    return Material(
        color: (widget.read) ? Colors.white : Colors.amber.shade200,
        child: ListTile(
          leading: SizedBox(
            width: 30,
            height: 30,
            child: CircleAvatar(
              backgroundColor: Colors.white38,
              child: AutoSizeText(
                firstLettter.toUpperCase(),
                maxLines: 1,
              ),
            ),
          ),
          title: AutoSizeText(widget.fullName, maxLines: 1),
          subtitle: AutoSizeText(widget.objet, maxLines: 2),
          selectedTileColor: Colors.amberAccent,
          trailing: Column(
            children: [
              SelectableText(
                  timeago.format(widget.dateSend, locale: 'fr_short'),
                  textAlign: TextAlign.start),
              const SizedBox(height: p8),
              (widget.read)
              ? const Icon(Icons.mail)
              : const Icon(Icons.mark_email_read)
            ],
          ),
        ));
  }
}
