import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/controllers/app_state.dart';
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
import 'package:fokad_admin/src/pages/rh/agents/components/agent_page.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/dashboard_rh.dart';
import 'package:fokad_admin/src/pages/rh/paiements/paiements_rh.dart';
import 'package:fokad_admin/src/pages/rh/presences/presences_rh.dart';
import 'package:fokad_admin/src/pages/screens/help_screen.dart';
import 'package:fokad_admin/src/pages/screens/not_found_page.dart';
import 'package:fokad_admin/src/pages/screens/settings_screen.dart';
import 'package:routemaster/routemaster.dart';

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
  static const rhDashboard = "/rh-dashboard";
  static const rhAgent = "/rh-agents";
  static const rhAgentPage = "/rh-agents-page";
  static const rhAgentAdd = "/rh-agents-add";
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

class Routing {

  authLogin() async {
    bool isloggIn = await AuthApi().isLoggedIn();

    if (isloggIn) {
      return const DashboardAdministration();
    } else {
      return const LoginPage();
    }
  }

  final routes = RouteMap(
      routes: {
      UserRoutes.login: (_) => const MaterialPage(child: LoginPage()),
      UserRoutes.profile: (_) => const MaterialPage(child: ProfilPage()), 
      UserRoutes.helps: (_) => const MaterialPage(child: HelpScreen()),  
      UserRoutes.settings: (_) => const MaterialPage(child: SettingsScreen()),

      // Administration
      AdminRoutes.adminDashboard: (_) => const MaterialPage(child: DashboardAdministration()),
      AdminRoutes.adminRH: (_) => const MaterialPage(child: RhAdmin()),
      AdminRoutes.adminFinance: (_) => const MaterialPage(child: FinancesAdmin()),
      AdminRoutes.adminExploitation: (_) => const MaterialPage(child: ExploitationsAdmin()),
      AdminRoutes.adminCommMarketing: (_) => const MaterialPage(child: CommMarketingAdmin()),
      AdminRoutes.adminLogistique: (_) => const MaterialPage(child: LogistiquesAdmin()), 

      // RH
      RhRoutes.rhDashboard: (_) => const MaterialPage(child: DashboardRh()),
      RhRoutes.rhAgent: (_) => const MaterialPage(child: AgentsRh()),
      RhRoutes.rhAgentPage: (_) => const MaterialPage(child: AgentPage()),
      RhRoutes.rhAgentAdd: (_) => const MaterialPage(child: AddAgent()),
      RhRoutes.rhPaiement: (_) => const MaterialPage(child: PaiementRh()),
      RhRoutes.rhPresence: (_) => const MaterialPage(child: PresenceRh()),



      // Finance
      FinanceRoutes.financeDashboard: (_) => const MaterialPage(child: DashboardFinance()), 
      FinanceRoutes.financeTransactions: (_) => const MaterialPage(child: TransactionsFinance()),
      FinanceRoutes.financeBudget: (_) => const MaterialPage(child: BudgetFinance()), 
      FinanceRoutes.transactionsBanque: (_) => const MaterialPage(child: BanqueTransactions()),
      FinanceRoutes.transactionsCaisse: (_) => const MaterialPage(child: CaisseTransactions()),
      FinanceRoutes.transactionsCreances: (_) => const MaterialPage(child: CreanceTransactions()),
      FinanceRoutes.transactionsDepenses: (_) => const MaterialPage(child: DepenseTransactions()),
      FinanceRoutes.transactionsDettes: (_) => const MaterialPage(child: DetteTransactions()), 
      FinanceRoutes.transactionsFinancementExterne: (_) => const MaterialPage(child: FinExterneTransactions()), 
      FinanceRoutes.comptabiliteAmortissement: (_) => const MaterialPage(child: AmortissementComptabilite()), 
      FinanceRoutes.comptabiliteBilan: (_) => const MaterialPage(child: BilanComptabilite()),
      FinanceRoutes.comptabiliteJournal: (_) => const MaterialPage(child: JournalComptabilite()),
      FinanceRoutes.comptabiliteValorisation: (_) => const MaterialPage(child: ValorisationComptabilite()), 
    },
    onUnknownRoute: (_) => const MaterialPage(child: NotFoundPage()),
  );
  
   
}



