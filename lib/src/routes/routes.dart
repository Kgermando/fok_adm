

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/pages/administration/dashboard_administration.dart';
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
import 'package:fokad_admin/src/pages/screens/help_screen.dart';
import 'package:fokad_admin/src/pages/screens/not_found_page.dart';
import 'package:fokad_admin/src/pages/screens/settings_screen.dart';
import 'package:routemaster/routemaster.dart';


final routes = RouteMap(
  routes: {
    '/': (_) => const Redirect('/login'),
    '/login': (_) => const MaterialPage(child: LoginPage()),
    '/profile': (_) => const MaterialPage(child: ProfilPage()),
    '/helps': (_) => const MaterialPage(child: HelpScreen()),
    '/settings': (_) => const MaterialPage(child: SettingsScreen()),
    '/admin-dashboard': (_) => const MaterialPage(child: DashboardAdministration()),
    '/finance-dashboard': (_) => const MaterialPage(child: DashboardFinance()),
    '/finance-transactions': (_) =>
        const MaterialPage(child: TransactionsFinance()),
    '/finance-budget': (_) => const MaterialPage(child: BudgetFinance()),
    '/transactions-caisse': (_) => const MaterialPage(child: CaisseTransactions()),
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
  },
  onUnknownRoute: (_) => const MaterialPage(child: NotFoundPage()),
);
