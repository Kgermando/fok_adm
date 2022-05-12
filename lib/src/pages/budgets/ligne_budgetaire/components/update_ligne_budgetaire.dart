import 'package:flutter/material.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';

class UpdateLigneBudgetaire extends StatefulWidget {
  const UpdateLigneBudgetaire({Key? key, required this.ligneBudgetaireModel}) : super(key: key);
  final LigneBudgetaireModel ligneBudgetaireModel;

  @override
  State<UpdateLigneBudgetaire> createState() => _UpdateLigneBudgetaireState();
}

class _UpdateLigneBudgetaireState extends State<UpdateLigneBudgetaire> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
