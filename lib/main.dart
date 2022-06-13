import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/app_state/app_state.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/provider/controller.dart';
import 'package:fokad_admin/src/provider/theme_provider.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_strategy/url_strategy.dart';
  
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());

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
  // final user = await AuthApi().getUserId();

  runApp(Phoenix(child: MyApp(user: user)));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
     String homeRoute = UserRoutes.login;

    if (user.departement == "Administration") {
      if (double.parse(user.role) <= 2) {
        homeRoute = AdminRoutes.adminDashboard;
      } else {
        homeRoute = AdminRoutes.adminLogistique;
      }
    } else if (user.departement == "Finances") {
      if (double.parse(user.role) <= 2) {
        homeRoute = FinanceRoutes.financeDashboard;
      } else {
        homeRoute = FinanceRoutes.transactionsDettes;
      }
    } else if (user.departement == "Comptabilites") {
      if (double.parse(user.role) <= 2) {
        homeRoute = ComptabiliteRoutes.comptabiliteDashboard;
      } else {
        homeRoute = ComptabiliteRoutes.comptabiliteJournal;
      }
    } else if (user.departement == "Budgets") {
      if (double.parse(user.role) <= 2) {
        homeRoute = BudgetRoutes.budgetDashboard;
      } else {
        homeRoute = BudgetRoutes.budgetBudgetPrevisionel;
      }
    } else if (user.departement == "Ressources Humaines") {
      if (double.parse(user.role) <= 2) {
        homeRoute = RhRoutes.rhDashboard;
      } else {
        homeRoute = RhRoutes.rhPresence;
      }
    } else if (user.departement == "Exploitations") {
      if (double.parse(user.role) <= 2) {
        homeRoute = ExploitationRoutes.expDashboard;
      } else {
        homeRoute = ExploitationRoutes.expTache;
      }
    } else if (user.departement == "Commercial et Marketing") {
      if (double.parse(user.role) <= 2) {
        homeRoute = ComMarketingRoutes.comMarketingDashboard;
      } else {
        homeRoute = ComMarketingRoutes.comMarketingAnnuaire;
      }
    } else if (user.departement == "Logistique") {
      if (double.parse(user.role) <= 2) {
        homeRoute = LogistiqueRoutes.logDashboard;
      } else {
        homeRoute = LogistiqueRoutes.logAnguinAuto;
      }
    } else {
      homeRoute = UserRoutes.login;
    }

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Controller()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => AuthApi()),
          ChangeNotifierProvider(create: (context) => DevisAPi()),
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'FOKAD ADMINISTRATION',
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            initialRoute: homeRoute,
            routes: routes,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'EN')],
          );
        });
  }
}
