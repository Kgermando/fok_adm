import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({Key? key}) : super(key: key);

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  late AuthApi authApi;

  _checkIsLoggedIn() async {
    bool isLoggedIn = await AuthApi().isLoggedIn();

    if (isLoggedIn) {
      Routemaster.of(context).replace('/admin-dashboard');
    } else {
      Routemaster.of(context).replace('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    authApi = Provider.of<AuthApi>(context);
    _checkIsLoggedIn(); 

    return SplashScreen(
        seconds: 14,
        navigateAfterSeconds: Routemaster.of(context).push('/login'),
        title: const Text(
          'Welcome In SplashScreen',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.network('https://i.imgur.com/TyCSG9A.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: const TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Flutter splashscreen"),
        loaderColor: Colors.red);
  }
}
