import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/controllers/app_state.dart';
import 'package:fokad_admin/src/helpers/user_preferences.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/provider/theme_provider.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/app_spinner.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_hooks/flutter_hooks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  await Future<void>.delayed(Duration.zero);
  runApp(const MyApp());
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
          ChangeNotifierProvider(create: (context) => AppState())
        ],
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp.router(
            builder: (context, child) {
              return AppWrapper(child: child);
            },
            routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
              return AppPages.appRoutes(context);
            }),
            routeInformationParser: const RoutemasterParser(),
            title: 'FOKAD ADMINISTRATION',
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: const [Locale('en', 'EN')],
          );
        });
  }
}

class AppWrapper extends HookWidget {
  const AppWrapper({Key? key, required this.child}) : super(key: key);
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    var isLoading = useState<bool>(true);
    useEffect(() {
      Future.microtask(() async {
        AuthApi().isLoggedIn().then((value) async {
          if (value) {
            String? id = await UserPreferences.getIdToken();
            context.read<AppState>().setLogin(id!);
            Routemaster.of(context).replace(AdminRoutes.adminDashboard);
          } else {
            await context.read<AppState>().handleAfterLogout();
          }
        }).catchError((onError) {
          debugPrint('onError');
        }).whenComplete(() => isLoading.value = false);
      });
      return null;
    }, []);
    return isLoading.value
        ? Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: double.infinity,
            width: double.infinity,
            child: const AppSpinner())
        : child ?? const SizedBox();
  }
}
