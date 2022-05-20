import 'package:flutter/material.dart';
import 'package:fokad_admin/src/pages/devis/components/table_devis.dart';

class RHDep extends StatefulWidget {
  const RHDep({ Key? key }) : super(key: key);

  @override
  State<RHDep> createState() => _RHDepState();
}

class _RHDepState extends State<RHDep> {
   bool isOpen1 = false;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Card(
      color: Colors.purple.shade700,
      child: ExpansionTile(
        leading: const Icon(Icons.note_alt, color: Colors.white),
        title: Text('Ressources Humaines',
            style: headline6!.copyWith(color: Colors.white)),
        initiallyExpanded: false,
        onExpansionChanged: (val) {
          setState(() {
            isOpen1 = !val;
          });
        },
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
        children: const [TableDevis(departement: "Ressources Humaines")],
      ),
    );
  }
}