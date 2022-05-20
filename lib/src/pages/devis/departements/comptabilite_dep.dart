import 'package:flutter/material.dart';
import 'package:fokad_admin/src/pages/devis/components/table_devis.dart';

class ComptabiliteDep extends StatefulWidget {
  const ComptabiliteDep({ Key? key }) : super(key: key);

  @override
  State<ComptabiliteDep> createState() => _ComptabiliteDepState();
}

class _ComptabiliteDepState extends State<ComptabiliteDep> {
    bool isOpen1 = false;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Card(
      color: Colors.green.shade700,
      child: ExpansionTile(
        leading: const Icon(Icons.note_alt, color: Colors.white),
        title: Text('Comptabilites',
            style: headline6!.copyWith(color: Colors.white)),
        initiallyExpanded: false,
        onExpansionChanged: (val) {
          setState(() {
            isOpen1 = !val;
          });
        },
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
        children: const [TableDevis(departement: "Comptabilites")],
      ),
    );
  }
}