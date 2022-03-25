import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

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

    return SplashScreenView(
      navigateRoute: _checkIsLoggedIn(),
      duration: 3000,
      imageSize: 130,
      imageSrc: "logo.png",
      backgroundColor: Colors.white,
    );
  }
}
