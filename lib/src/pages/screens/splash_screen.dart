import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:routemaster/routemaster.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({Key? key}) : super(key: key);

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder<bool>(
        future: AuthApi().isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool? userInfo = snapshot.data;
            if (userInfo != null) {
              var userData = userInfo;
               if (userData) {
                Routemaster.of(context).replace('/admin-dashboard');
              } else {
                Routemaster.of(context).replace('/login');
              }
            }
          }
          return const Center(child: LinearProgressIndicator());
        },
      ),
    );
  }
}
