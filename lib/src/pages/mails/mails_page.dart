import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/mails/mail_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/mail/mail_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/mails/components/list_mails.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

final _lightColors = [
  Colors.pinkAccent.shade700,
  Colors.tealAccent.shade700,
  Colors.amber.shade700,
  Colors.lightGreen.shade700,
  Colors.lightBlue.shade700,
  Colors.orange.shade700,
  Colors.brown.shade700,
  Colors.grey.shade700,
  Colors.blueGrey.shade700,
];

class MailPages extends StatefulWidget {
  const MailPages({Key? key}) : super(key: key);

  @override
  State<MailPages> createState() => _MailPagesState();
}

class _MailPagesState extends State<MailPages> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final Stream<List<MailModel>> _mails = (() {
    late final StreamController<List<MailModel>> controller;
    controller = StreamController<List<MailModel>>(
      onListen: () async {
        List<MailModel> mailsList = [];
        UserModel userModel = await AuthApi().getUserId();
        var mails = await MailApi().getAllData();
        mailsList = mails
            .where((element) =>
                element.email == userModel.email ||
                element.cc.contains(userModel.email))
            .toList();
        controller.add(mailsList);
        await Future<void>.delayed(const Duration(seconds: 1));
        await controller.close();
      },
    );
    return controller.stream;
  })();

  // @override
  // void initState() {
  //   getData();
  //   super.initState();
  // }

  // List<MailModel> mailsList = [];
  // Future<void> getData() async {
  //   UserModel userModel = await AuthApi().getUserId();
  //   var mails = await MailApi().getAllData();
  //   setState(() {
  //     mailsList = mails
  //         .where((element) =>
  //             element.email == userModel.email ||
  //             element.cc.contains(userModel.email))
  //         .toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.send),
            onPressed: () {
              Navigator.pushNamed(context, MailRoutes.addMail);
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
                      StreamBuilder<List<MailModel>>(
                        stream: _mails,
                        builder: (BuildContext context, 
                          AsyncSnapshot<List<MailModel>> snapshot) {
                            List<Widget> children;
                            if (snapshot.hasError) {
                              children = <Widget>[
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text('Error: ${snapshot.error}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text('Stack trace: ${snapshot.stackTrace}'),
                                ),
                              ];
                            } else {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  children = const <Widget>[
                                    Icon(
                                      Icons.info,
                                      color: Colors.blue,
                                      size: 60,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text('Select a lot'),
                                    )
                                  ];
                                  break;
                                case ConnectionState.waiting:
                                 children = <Widget>[
                                    loading()
                                  ];
                                  break;
                                case ConnectionState.active:
                                children = <Widget>[
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                    size: 60,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text('\$${snapshot.data}'),
                                  ),
                                ];
                                break;
                                case ConnectionState.done:
                                  children = <Widget>[
                                    const Icon(
                                      Icons.info,
                                      color: Colors.blue,
                                      size: 60,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text('\$${snapshot.data} (closed)'),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            final mail = snapshot.data![index];
                                            final color = _lightColors[index];
                                            return pageWidget(mail, color);
                                          }),
                                    )
                                  ];
                                  break;
                              }
                            }
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children,
                            ),
                          );  
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget pageWidget(MailModel mail, Color color) {
    return InkWell(
      onTap: () async {
        await readMail(mail);

        Navigator.pushNamed(context, MailRoutes.mailDetail,
            arguments: MailColor(mail: mail, color: color));
      },
      child: Padding(
        padding: const EdgeInsets.all(p10),
        child: ListMails(
            fullName: mail.fullName,
            email: mail.email,
            cc: mail.cc,
            objet: mail.objet,
            read: mail.read,
            dateSend: mail.dateSend,
            color: color),
      ),
    );
  }

  Widget alertWidget() {
    final headline6 = Theme.of(context).textTheme.headline6;
    // Duration isDuration = const Duration(minutes: 1);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("En attente d'une connexion API sécurisée ...",
              style: headline6),
          // const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Future<void> readMail(MailModel mail) async {
    final mailModel = MailModel(
        fullName: mail.fullName,
        email: mail.email,
        cc: mail.cc,
        objet: mail.objet,
        message: mail.message,
        pieceJointe: mail.pieceJointe,
        read: true,
        fullNameDest: mail.fullNameDest,
        emailDest: mail.emailDest,
        dateSend: mail.dateSend,
        dateRead: DateTime.now());
    await MailApi().updateData(mail.id!, mailModel);
  }
}
