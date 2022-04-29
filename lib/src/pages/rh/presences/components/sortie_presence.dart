import 'package:flutter/material.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';

class SortiePresence extends StatefulWidget {
  const SortiePresence({Key? key, required this.presenceModel}) : super(key: key);
  final PresenceModel presenceModel;

  @override
  State<SortiePresence> createState() => _SortiePresenceState();
}

class _SortiePresenceState extends State<SortiePresence> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
