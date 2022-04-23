import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/app_state/app_state.dart';
import 'package:fokad_admin/src/pages/administration/dashboard_administration.dart';
import 'package:fokad_admin/src/pages/auth/login_auth.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/provider/theme_provider.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Routemaster.setPathUrlStrategy();
  // setPathUrlStrategy();
  timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  await Future<void>.delayed(Duration.zero);
  runApp(const MyApp());
}

class TitleObserver extends RoutemasterObserver {
  @override
  void didChangeRoute(RouteData routeData, Page page) {
    if (page.name != null) {
      SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
          label: page.name,
          primaryColor: 0xFF00FF00,
        ),
      );
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Controller()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => AuthApi()),
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp.router(
            title: 'FOKAD ADMINISTRATION',
            themeMode: themeProvider.themeMode,
            routerDelegate: RoutemasterDelegate(
              observers: [TitleObserver()],
              routesBuilder: (context) {
                final appState = Provider.of<AppState>(context);
                final isLoggedIn = appState.isLoggedIn;
                print('isLoggedIn $isLoggedIn');
                return isLoggedIn
                    ? Routing().buildRouteMap(appState)
                    : Routing().loggedOutRouteMap;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [
              Locale('fr', 'FR'),
              Locale('en', 'EN')
            ],
          );
        });
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  void initState() {
    super.initState();
    authLogin();
  }

  bool? auth;

  authLogin() async {
    bool isloggIn = await AuthApi().isLoggedIn();

    if (isloggIn) {
      return const DashboardAdministration();
    } else {
      return const LoginPage();
    }
  }

  // authLogin() {
  //   // AuthHttp().logout();
  //   if (auth == true) {
  //     return const DashboardAdministration();
  //   } else {
  //     return const LoginPage();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return authLogin();
  }
}
