import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/mails/mail_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/mail/mail_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/mails/components/list_mails.dart';
import 'package:fokad_admin/src/pages/mails/components/new_mail.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class MailPages extends StatefulWidget {
  const MailPages({Key? key}) : super(key: key);

  @override
  State<MailPages> createState() => _MailPagesState();
}

class _MailPagesState extends State<MailPages> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        getData();
      });
    });
    super.initState();
  }

  List<MailModel> mailsList = [];
  Future<void> getData() async {
    var mails = await MailApi().getAllData();
    setState(() {
      mailsList = mails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            child: Row(
              children: const [
                Icon(Icons.add),
                Icon(Icons.car_rental),
              ],
            ),
            onPressed: () {
              Routemaster.of(context).push(MailRoutes.addMail);
            }),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppbar(
                          title: 'Mails',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                        child: ListView.builder(
                          itemCount: mailsList.length,
                          itemBuilder: (context, index) {
                            final mail = mailsList[index];
                            return pageWidget(mail);
                          }))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget pageWidget(MailModel mail) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewMail(mailModel: mail)));
      },
      child: Padding(
        padding: const EdgeInsets.all(p10),
        child: ListMails(
          fullName: mail.fullName,
          email: mail.email,
          cc: mail.cc,
          objet: mail.objet,
          read: mail.read,
          dateSend: mail.dateSend
        ),
      ),
    );
  }
}
