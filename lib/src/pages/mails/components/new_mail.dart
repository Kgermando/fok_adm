import 'package:flutter/material.dart';
import 'package:fokad_admin/src/models/mail/mail_model.dart';

class NewMail extends StatefulWidget {
  const NewMail({Key? key, required this.mailModel}) : super(key: key);
  final MailModel mailModel;

  @override
  State<NewMail> createState() => _NewMailState();
}

class _NewMailState extends State<NewMail> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
