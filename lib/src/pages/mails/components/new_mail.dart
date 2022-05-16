import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/mails/mail_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/mail/mail_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:routemaster/routemaster.dart';

class NewMail extends StatefulWidget {
  const NewMail({Key? key}) : super(key: key);

  @override
  State<NewMail> createState() => _NewMailState();
}

class _NewMailState extends State<NewMail> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isOpen = false;

  final TextEditingController objetController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController pieceJointeController = TextEditingController();
  String? email;
  bool read = false;
  List<UserModel> ccList = [];

  @override
  initState() {
    getData();
    super.initState();
  }

  List<UserModel> userList = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var users = await UserApi().getAllData();
    setState(() {
      user = userModel;
      userList = users;
    });
  }

  @override
  void dispose() {
    objetController.dispose();
    messageController.dispose();
    pieceJointeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ),
                          const SizedBox(width: p10),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Mails',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addAgentWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addAgentWidget() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: SizedBox(
                width: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width,
                child: ListView(
                  controller: _controllerScroll,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [TitleWidget(title: "Nouveau mail")],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    emailWidget(),
                    ccWidget(),
                    const SizedBox(height: p20),
                    objetWidget(),
                    messageWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Envoyez',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            send();
                            form.reset();
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailWidget() {
    var emailList = userList.map((e) => e.email).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Select adresse email',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: email,
        isExpanded: true,
        validator: (value) => value == null ? "Select email" : null,
        items: emailList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            email = value;
          });
        },
      ),
    );
  }

  Widget ccWidget() {
    return Material(
      color: Colors.amber.shade50,
      child: ExpansionTile(
        leading: const Icon(Icons.person),
        title: const Text('Cc'),
        subtitle: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 20,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ccList.length,
              itemBuilder: (BuildContext context, index) {
                final agent = ccList[index];
                return Text("${agent.email}; ");
              }),
        ),
        onExpansionChanged: (val) {
          setState(() {
            isOpen = !val;
          });
        },
        trailing: const Icon(Icons.arrow_drop_down),
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, i) {
                  return ListTile(
                      title: Text(userList[i].email),
                      leading: Checkbox(
                        value: ccList.contains(userList[i]),
                        onChanged: (val) {
                          if (val == true) {
                            setState(() {
                              ccList.add(userList[i]);
                            });
                          } else {
                            setState(() {
                              ccList.remove(userList[i]);
                            });
                          }
                        },
                      ));
                }),
          )
        ],
      ),
    );
  }

  Widget objetWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: objetController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Objet",
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget messageWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: messageController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Mail ...",
            helperText: "Ecrivez mail ...",
          ),
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 20,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Future<void> send() async {
    var userSelect = userList.where((element) => element.email == email).first;
    final mailModel = MailModel(
        fullName: "${userSelect.prenom} ${userSelect.nom}",
        email: email.toString(),
        cc: ccList,
        objet: objetController.text,
        message: messageController.text,
        pieceJointe: (pieceJointeController.text == '')
            ? '-'
            : pieceJointeController.text,
        read: read,
        fullNameDest: "${user!.prenom} ${user!.nom}",
        emailDest: user!.email,
        dateSend: DateTime.now(),
        dateRead: DateTime.now());
    await MailApi().insertData(mailModel);
    Routemaster.of(context).replace(MailRoutes.mails);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Envoyer avec succès!"),
      backgroundColor: Colors.green[700],
    ));
  }
}
