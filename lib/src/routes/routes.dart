

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/pages/auth/login_auth.dart';
import 'package:fokad_admin/src/pages/finances/budgets/budget_finance.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/dashboard_finance.dart';
import 'package:fokad_admin/src/pages/finances/transactions/transactions_fincance.dart';
import 'package:fokad_admin/src/pages/screens/help_screen.dart';
import 'package:fokad_admin/src/pages/screens/not_found_page.dart';
import 'package:fokad_admin/src/pages/screens/settings_screen.dart';
import 'package:routemaster/routemaster.dart';


final routes = RouteMap(
  routes: {
    '/': (_) => const Redirect('/login'),
    '/login': (_) => const MaterialPage(child: LoginPage()),
    '/finance-dashboard': (_) => const MaterialPage(child: DashboardFinance()),
    '/finance-transactions': (_) =>
        const MaterialPage(child: TransactionsFinance()),
    '/finance-budget': (_) => const MaterialPage(child: BudgetFinance()),
    '/helps': (_) => const MaterialPage(child: HelpScreen()),
    '/settings': (_) => const MaterialPage(child: SettingsScreen()),
  },
  onUnknownRoute: (_) => const MaterialPage(child: NotFoundPage()),
);
