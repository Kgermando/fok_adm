import 'package:flutter/material.dart';
import 'package:fokad_admin/src/pages/archives/table_archive.dart';

class ComptabiliteArchive extends StatefulWidget {
  const ComptabiliteArchive({ Key? key }) : super(key: key);

  @override
  State<ComptabiliteArchive> createState() => _ComptabiliteArchiveState();
}

class _ComptabiliteArchiveState extends State<ComptabiliteArchive> {
    bool isOpen1 = false;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Card(
      color: Colors.green.shade700,
      child: ExpansionTile(
        leading: const Icon(Icons.archive, color: Colors.white),
        title: Text('Archive Comptabilites',
            style: headline6!.copyWith(color: Colors.white)),
        initiallyExpanded: false,
        onExpansionChanged: (val) {
          setState(() {
            isOpen1 = !val;
          });
        },
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
        children: const [TableArchive(departement: "Comptabilites")],
      ),
    );
  }
}