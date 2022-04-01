import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/pages/administration/comm_marketing_admin.dart';
import 'package:fokad_admin/src/pages/administration/dashboard_administration.dart';
import 'package:fokad_admin/src/pages/administration/exploitations_admin.dart';
import 'package:fokad_admin/src/pages/administration/finances_admin.dart';
import 'package:fokad_admin/src/pages/administration/logistique_admin.dart';
import 'package:fokad_admin/src/pages/administration/rh_admin.dart';
import 'package:fokad_admin/src/pages/auth/login_auth.dart';
import 'package:fokad_admin/src/pages/auth/profil_page.dart';
import 'package:fokad_admin/src/pages/finances/budgets/budget_finance.dart';
import 'package:fokad_admin/src/pages/finances/comptabilites/armotissement_comptabilite.dart';
import 'package:fokad_admin/src/pages/finances/comptabilites/bilan_comptabilite.dart';
import 'package:fokad_admin/src/pages/finances/comptabilites/journal_comptabilite.dart';
import 'package:fokad_admin/src/pages/finances/comptabilites/valorisation_comptabilite.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/dashboard_finance.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/banque_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/caisses_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/creance_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/depense_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/dette_transcations.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/fin_externe_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/transactions_fincance.dart';
import 'package:fokad_admin/src/pages/rh/agents/agents_rh.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/dashboard_rh.dart';
import 'package:fokad_admin/src/pages/rh/paiements/paiements_rh.dart';
import 'package:fokad_admin/src/pages/rh/presences/presences_rh.dart';
import 'package:fokad_admin/src/pages/rh/salaires/salaires_rh.dart';
import 'package:fokad_admin/src/pages/screens/help_screen.dart';
import 'package:fokad_admin/src/pages/screens/not_found_page.dart';
import 'package:fokad_admin/src/pages/screens/settings_screen.dart';
import 'package:fokad_admin/src/pages/screens/splash_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutMap = RouteMap(
  onUnknownRoute: (_) => const MaterialPage(child: NotFoundPage()),
  routes: {
    '/': (_) => const MaterialPage(child: LoginPage()),
  },
);

final loggedInMap = RouteMap(
  routes: {
    // '/': (_) => const Redirect('/login'),
    '/splash': (_) => const MaterialPage(child: SplashScreens()),
    '/login': (_) => const MaterialPage(child: LoginPage()),
    '/profile': (_) => const MaterialPage(child: ProfilPage()),
    '/helps': (_) => const MaterialPage(child: HelpScreen()),
    '/settings': (_) => const MaterialPage(child: SettingsScreen()),

    // ADMINISTRATION
    '/admin-dashboard': (_) =>
        const MaterialPage(child: DashboardAdministration()),
    '/admin-commercial-marketing': (_) =>
        const MaterialPage(child: CommMarketingAdmin()),
    '/admin-finances': (_) => const MaterialPage(child: FinancesAdmin()),
    '/admin-logistiques': (_) => const MaterialPage(child: LogistiquesAdmin()),
    '/admin-rh': (_) => const MaterialPage(child: RhAdmin()),
    '/admin-exploitations': (_) =>
        const MaterialPage(child: ExploitationsAdmin()),

    // FINANCES
    '/finance-dashboard': (_) => const MaterialPage(child: DashboardFinance()),
    '/finance-transactions': (_) =>
        const MaterialPage(child: TransactionsFinance()),
    '/finance-budget': (_) => const MaterialPage(child: BudgetFinance()),
    '/transactions-caisse': (_) =>
        const MaterialPage(child: CaisseTransactions()),
    '/transactions-banque': (_) =>
        const MaterialPage(child: BanqueTransactions()),
    '/transactions-dettes': (_) =>
        const MaterialPage(child: DetteTransactions()),
    '/transactions-creances': (_) =>
        const MaterialPage(child: CreanceTransactions()),
    '/transactions-financement-externe': (_) =>
        const MaterialPage(child: FinExterneTransactions()),
    '/transactions-depenses': (_) =>
        const MaterialPage(child: DepenseTransactions()),
    '/comptabilite-amortissement': (_) =>
        const MaterialPage(child: AmortissementComptabilite()),
    '/comptabilite-bilan': (_) =>
        const MaterialPage(child: BilanComptabilite()),
    '/comptabilite-journal': (_) =>
        const MaterialPage(child: JournalComptabilite()),
    '/comptabilite-valorisation': (_) =>
        const MaterialPage(child: ValorisationComptabilite()),

    // RH
    '/rh-dashboard': (_) => const MaterialPage(child: DashboardRh()),
    '/rh-paiements': (_) => const MaterialPage(child: PaiementRh()),
    '/rh-salaires': (_) => const MaterialPage(child: SalaireRh()),
    '/rh-presences': (_) => const MaterialPage(child: PresenceRh()),
    '/rh-agents': (_) => const MaterialPage(child: AgentsRh()),
  },
  // onUnknownRoute: (_) => const MaterialPage(child: NotFoundPage()),
  onUnknownRoute: (_) => const MaterialPage(child: LoginPage()),
);

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;

  bool get isLogged => isLoggedIn;

  Future<bool> setIsLoggedIn(BuildContext context) async {
    isLoggedIn = await AuthApi().isLoggedIn();
    // if (isLoggedIn) {
    //   Routemaster.of(context).replace('/admin-dashboard');
    // } else {
    //   Routemaster.of(context).replace('/login');
    // }
    print('isLoggedIn $isLoggedIn');
    notifyListeners();
    return isLoggedIn;
  }
}
