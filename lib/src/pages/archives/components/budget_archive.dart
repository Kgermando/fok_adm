import 'package:flutter/material.dart';
import 'package:fokad_admin/src/pages/archives/table_archive.dart';

class BudgetArchive extends StatefulWidget {
  const BudgetArchive({Key? key}) : super(key: key);

  @override
  State<BudgetArchive> createState() => _BudgetArchiveState();
}

class _BudgetArchiveState extends State<BudgetArchive> {
  bool isOpen1 = false;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Card(
      color: Colors.blue.shade700,
      child: ExpansionTile(
        leading: const Icon(Icons.archive, color: Colors.white),
        title: Text('Archive Budgets',
            style: headline6!.copyWith(color: Colors.white)),
        initiallyExpanded: false,
        onExpansionChanged: (val) {
          setState(() {
            isOpen1 = !val;
          });
        },
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
        children: const [TableArchive(departement: "Budgets")],
      ),
    );
  }


}
