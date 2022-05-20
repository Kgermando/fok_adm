import 'package:flutter/material.dart';
import 'package:fokad_admin/src/pages/devis/components/table_devis.dart';
class LogistiqueDep extends StatefulWidget {
  const LogistiqueDep({ Key? key }) : super(key: key);

  @override
  State<LogistiqueDep> createState() => _LogistiqueDepState();
}

class _LogistiqueDepState extends State<LogistiqueDep> {
   bool isOpen1 = false;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Card(
      color: Colors.grey.shade700,
      child: ExpansionTile(
        leading: const Icon(Icons.note_alt, color: Colors.white),
        title: Text('Logistique',
            style: headline6!.copyWith(color: Colors.white)),
        initiallyExpanded: false,
        onExpansionChanged: (val) {
          setState(() {
            isOpen1 = !val;
          });
        },
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
        children: const [TableDevis(departement: "Logistique")],
      ),
    );
  }
}