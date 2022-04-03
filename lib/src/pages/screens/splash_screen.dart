import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/routes/routes.dart';

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
                Navigator.of(context).pushReplacementNamed(AdminRoutes.adminDashboard);
              } else {
                Navigator.of(context).pushReplacementNamed(UserRoutes.login);
              }
            }
          }
          return const Center(child: LinearProgressIndicator());
        },
      ),
    );
  }
}
