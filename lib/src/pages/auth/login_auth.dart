import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/provider/theme_provider.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:provider/provider.dart';

import '../../app_state/app_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool isloading = false;

  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var headline6 = Theme.of(context).textTheme.headline6;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.all(50.0)
            : const EdgeInsets.all(10.0),
        child: Card(
          elevation: 10,
          shadowColor: Colors.deepPurpleAccent,
          child: Row(
            children: [
              if (!Responsive.isMobile(context))
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset('assets/images/logo.png',
                            fit: BoxFit.cover,
                            height: Responsive.isDesktop(context)
                                ? height / 1.5
                                : height / 2),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 20,
                        child: DefaultTextStyle(
                          style: headline6!.copyWith(color: Colors.black),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                  'Bienvenue sur l\'interface d\'administration FOKAD.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Générez vos rapports instanement.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Gerer votre reporting calls et projets.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Redigez et envoyez vos mails instanement.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Travaillez partout et à tous moment.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              Expanded(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.topRight, child: helpWidget()),
                        logoWidget(),
                        // titleText(),
                        const SizedBox(height: 20),
                        userNameBuild(),
                        const SizedBox(height: 20),
                        passwordBuild(),
                        const SizedBox(height: 20),
                        loginButtonBuild(),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            forgotPasswordWidget(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget logoWidget() {
    var height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Image.asset(
          "assets/images/logo.png",
          height: Responsive.isDesktop(context) ? 100 : height / 5,
          width: size.width,
        ),
        const SizedBox(height: p20),
        const Text('FOKAD ADMINISTRATION')
      ],
    );
  }

  Widget userNameBuild() {
    return Padding(
        padding: const EdgeInsets.all(p20),
        child: TextFormField(
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Matricule',
          ),
          controller: matriculeController,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ce champ est obligatoire';
            }
            return null;
          },
          style: const TextStyle(),
        ));
  }

  Widget passwordBuild() {
    return Padding(
        padding: const EdgeInsets.all(p20),
        child: TextFormField(
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Mot de passe',
          ),
          controller: passwordController,
          keyboardType: TextInputType.text,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ce champ est obligatoire';
            }
            return null;
          },
          style: const TextStyle(),
        ));
  }

  Widget loginButtonBuild() {
    return Padding(
      padding: const EdgeInsets.all(p20),
      child: BtnWidget(
          title: 'Login',
          isLoading: isloading,
          press: () async {
            final form = _form.currentState!;
            if (form.validate()) {
              setState(() => isloading = true);
              await AuthApi()
                  .login(matriculeController.text, passwordController.text)
                  .then((value) {
                if (value) { 
                Provider.of<AppState>(context, listen: false).isLoggedIn =true;
                // if () {
                  
                // } else {
                // }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Login succès!"),
                    backgroundColor: Colors.green[700],
                  ));
                  // setState(() => isloading = false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Votre Matricule ou Mot de passe incorrect"),
                    backgroundColor: Colors.red[700],
                  ));
                  setState(() => isloading = false);
                }
              });
            }
          }),
    );
  }

  Widget forgotPasswordWidget() {
    final button = Theme.of(context).textTheme.button;
    return TextButton(
        onPressed: () {},
        child: Text(
          'Mot de passe oublié ?',
          style: button,
          textAlign: TextAlign.start,
        ));
  }

  Widget helpWidget() {
    final button = Theme.of(context).textTheme.button;
    return TextButton.icon(
        onPressed: () {},
        icon: const Icon(
          Icons.help,
          color: Colors.teal,
        ),
        label: Text(
          'Besoin d\'aide?',
          style: button,
        ));
  }
}
