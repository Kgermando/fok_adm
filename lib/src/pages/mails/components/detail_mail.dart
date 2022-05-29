import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/mails/mail_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/mail/mail_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailMail extends StatefulWidget {
  const DetailMail({Key? key, required this.mailModel, required this.color})
      : super(key: key);
  final MailModel mailModel;
  final Color color;

  @override
  State<DetailMail> createState() => _DetailMailState();
}

class _DetailMailState extends State<DetailMail> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  initState() {
    getData();
    super.initState();
  }

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: false,
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
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
                    child: FutureBuilder<MailModel>(
                        future: MailApi().getOneData(widget.mailModel.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<MailModel> snapshot) {
                          if (snapshot.hasData) {
                            MailModel? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: p20,
                                      child: IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: const Icon(Icons.arrow_back)),
                                    ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: "Mail",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: pageDetail(data!)))
                              ],
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(MailModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        // elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: p20),
              Padding(
                padding: const EdgeInsets.all(p8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SelectableText(
                        timeago.format(data.dateSend, locale: 'fr_short'),
                        textAlign: TextAlign.start),
                  ],
                ),
              ),
              dataWidget(data)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(MailModel data) {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    final String firstLettter = data.fullName[0];
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: CircleAvatar(
                backgroundColor: widget.color,
                child: AutoSizeText(
                  firstLettter.toUpperCase(),
                  style: headlineSmall!.copyWith(color: Colors.white),
                  maxLines: 1,
                ),
              ),
            ),
            title: AutoSizeText(data.objet,
                style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(data.email == user.email)
                Row(
                  children: [
                    AutoSizeText("à".toUpperCase()),
                    const AutoSizeText("moi."),
                  ],
                ),
                SizedBox(
                  width: 500,
                  child: ExpansionTile(
                    title: const Text("Voir plus", textAlign: TextAlign.end),
                    children: [
                      Row(
                        children: [
                          const AutoSizeText("De:"),
                          const SizedBox(width: p10),
                          AutoSizeText(data.emailDest, style: bodySmall),
                          const SizedBox(width: p10),
                          AutoSizeText(data.fullNameDest, style: bodySmall!.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      
                      Row(
                        children: [
                          AutoSizeText("à:".toUpperCase()),
                          const SizedBox(width: p10),
                          AutoSizeText(data.email, style: bodySmall),
                          const SizedBox(width: p10),
                          AutoSizeText(data.fullName,
                            style: bodySmall.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(width: p10),
                      Row(
                        children: [
                          const Text("Date:"),
                          const SizedBox(width: p10),
                          SelectableText(
                            DateFormat("dd-MM-yyyy HH:mm")
                                .format(data.dateSend),
                            style: bodySmall,
                            textAlign: TextAlign.start),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.lock, size: 15.0, color: Colors.green.shade700),
                          const SizedBox(width: p10),
                          Text("Chiffrement Standard (TLS).", style:bodySmall.copyWith(color: Colors.green.shade700))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(color: Colors.amber.shade700),
          const SizedBox(height: p20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(data.message,
                  textAlign: TextAlign.start, style: bodyMedium),
            ],
          )
        ],
      ),
    );
  }
}
