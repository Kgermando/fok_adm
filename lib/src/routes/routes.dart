import 'package:flutter/material.dart';
import 'package:fokad_admin/src/helpers/user_preferences.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
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
import 'package:fokad_admin/src/pages/rh/agents/components/add_agent.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/dashboard_rh.dart';
import 'package:fokad_admin/src/pages/rh/paiements/paiements_rh.dart';
import 'package:fokad_admin/src/pages/rh/presences/presences_rh.dart';
import 'package:fokad_admin/src/pages/screens/help_screen.dart';
import 'package:fokad_admin/src/pages/screens/not_found_page.dart';
import 'package:fokad_admin/src/pages/screens/settings_screen.dart';
import 'package:fokad_admin/src/pages/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRoutes {
  static const login = "/";
  static const profile = "/profile";
  static const helps = "/helps";
  static const settings = "/settings";
  static const splash = "/splash";
}

class AdminRoutes {
  static const adminDashboard = "/admin-dashboard";
  static const adminRH = "/admin-rh";
  static const adminFinance = "/admin-finances";
  static const adminExploitation = "/admin-exploitations";
  static const adminCommMarketing = "/admin-commercial-marketing";
  static const adminLogistique = "/admin-logistiques";
}

class RhRoutes {
  static const rhAgentAdd = "/rh-agents-add";
  static const rhAgent = "/rh-agents";
  static const rhDashboard = "/rh-dashboard";
  static const rhPaiement = "/rh-paiements";
  static const rhPresence = "/rh-presences";
}

class FinanceRoutes {
  static const financeDashboard = "/finance-dashboard";
  static const financeTransactions = "/finance-transactions";
  static const financeBudget = "/finance-budget";
  static const transactionsCaisse = "/transactions-caisse";
  static const transactionsBanque = "/transactions-banque";
  static const transactionsDettes = "/transactions-dettes";
  static const transactionsCreances = "/transactions-creances";
  static const transactionsFinancementExterne = "/transactions-financement-externe";
  static const transactionsDepenses = "/transactions-depenses";
  static const comptabiliteAmortissement = "/comptabilite-amortissement";
  static const comptabiliteBilan = "/comptabilite-bilan";
  static const comptabiliteJournal = "/comptabilite-journal";
  static const comptabiliteValorisation = "/comptabilite-valorisation";
  
}

class AppPages {
  static Page privateRoute(BuildContext context, Page route) {
    if (!context.read<AppState>().isLoggedIn) {
      return const Redirect(UserRoutes.login);
    }
    return route;
  }

  static RouteMap appRoutes(BuildContext context) {
    return RouteMap(
      routes: {
        UserRoutes.login: (route) {
          return const MaterialPage(child: LoginPage());
        },
        UserRoutes.profile: (route) {
          return privateRoute(context, const MaterialPage(child: ProfilPage()));
        },
        UserRoutes.helps: (route) {
          return privateRoute(context, const MaterialPage(child: HelpScreen()));
        },
        UserRoutes.settings: (route) {
          return privateRoute(context, const MaterialPage(child: SettingsScreen()));
        },
        UserRoutes.splash: (route) {
          return privateRoute(context, const MaterialPage(child: SplashScreens()));
        },

        // Administration
        AdminRoutes.adminDashboard: (route) {
          return privateRoute(context, const MaterialPage(child: DashboardAdministration()));
        },
        AdminRoutes.adminRH: (route) {
          return privateRoute(context, const MaterialPage(child: RhAdmin()));
        },
        AdminRoutes.adminFinance: (route) {
          return privateRoute(context, const MaterialPage(child: FinancesAdmin()));
        },
        AdminRoutes.adminExploitation: (route) {
          return privateRoute(context, const MaterialPage(child: ExploitationsAdmin()));
        },
        AdminRoutes.adminCommMarketing: (route) {
          return privateRoute(context, const MaterialPage(child: CommMarketingAdmin()));
        },
        AdminRoutes.adminLogistique: (route) {
          return privateRoute(context, const MaterialPage(child: LogistiquesAdmin()));
        },

        // RH
        RhRoutes.rhAgent: (route) {
          return privateRoute(context, const MaterialPage(child: AgentsRh()));
        },
        RhRoutes.rhAgentAdd: (route) {
          return privateRoute(context, const MaterialPage(child: AddAgent()));
        },
        RhRoutes.rhDashboard: (route) {
          return privateRoute(context, const MaterialPage(child: DashboardRh()));
        },
        RhRoutes.rhPaiement: (route) {
          return privateRoute(context, const MaterialPage(child: PaiementRh()));
        },
        RhRoutes.rhPresence: (route) {
          return privateRoute(context, const MaterialPage(child: PresenceRh()));
        },

        // Finances
        FinanceRoutes.financeDashboard: (route) {
          return privateRoute(context, const MaterialPage(child: DashboardFinance()));
        },
        FinanceRoutes.financeTransactions: (route) {
          return privateRoute(context, const MaterialPage(child: TransactionsFinance()));
        },
        FinanceRoutes.financeBudget: (route) {
          return privateRoute(context, const MaterialPage(child: BudgetFinance()));
        },
        FinanceRoutes.transactionsBanque: (route) {
          return privateRoute(context, const MaterialPage(child: BanqueTransactions()));
        },
        FinanceRoutes.transactionsCaisse: (route) {
          return privateRoute(context, const MaterialPage(child: CaisseTransactions()));
        },
        FinanceRoutes.transactionsCreances: (route) {
          return privateRoute(context, const MaterialPage(child: CreanceTransactions()));
        },
        FinanceRoutes.transactionsDepenses: (route) {
          return privateRoute(context, const MaterialPage(child: DepenseTransactions()));
        },
        FinanceRoutes.transactionsDettes: (route) {
          return privateRoute(context, const MaterialPage(child: DetteTransactions()));
        },
        FinanceRoutes.transactionsFinancementExterne: (route) {
          return privateRoute(context, const MaterialPage(child: FinExterneTransactions()));
        },
        FinanceRoutes.comptabiliteAmortissement: (route) {
          return privateRoute(context, const MaterialPage(child: AmortissementComptabilite()));
        },
        FinanceRoutes.comptabiliteBilan: (route) {
          return privateRoute(context, const MaterialPage(child: BilanComptabilite()));
        },
        FinanceRoutes.comptabiliteJournal: (route) {
          return privateRoute(context, const MaterialPage(child: JournalComptabilite()));
        },
        FinanceRoutes.comptabiliteValorisation: (route) {
          return privateRoute(context, const MaterialPage(child: ValorisationComptabilite()));
        },

      }
    );
  }
}

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;

  Future<bool> handleAfterLogin(bool value) async {
    isLoggedIn = true;
    bool res = await UserPreferences.setAuth(value);
    notifyListeners();
    return res;
  }

  // Future<bool> handleAfterLogin(UserModel user) async {
  //   isLoggedIn = false;
  //   bool res = await UserPreferences.save('userModel', user);
  //   notifyListeners();
  //   return res;
  // }

  void setLogin(UserModel user) {
    isLoggedIn = true;
    notifyListeners();
  }

  Future<bool> handleAfterLogout() async {
    isLoggedIn = false;
    bool res = await UserPreferences.removeAuth();
    notifyListeners();
    return res;
  }

  // Future<bool> handleAfterLogout() async {
  //   isLoggedIn = false;
  //   bool res = await UserPreferences.remove('userModel');
  //   notifyListeners();
  //   return res;
  // }
}
