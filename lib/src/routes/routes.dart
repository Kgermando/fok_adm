import 'package:flutter/material.dart';
import 'package:fokad_admin/src/pages/administration/budgets_admin.dart';
import 'package:fokad_admin/src/pages/administration/comm_marketing_admin.dart';
import 'package:fokad_admin/src/pages/administration/comptes_admin.dart';
import 'package:fokad_admin/src/pages/administration/dashboard_administration.dart';
import 'package:fokad_admin/src/pages/administration/exploitations_admin.dart';
import 'package:fokad_admin/src/pages/administration/finances_admin.dart';
import 'package:fokad_admin/src/pages/administration/logistique_admin.dart';
import 'package:fokad_admin/src/pages/administration/rh_admin.dart';
import 'package:fokad_admin/src/pages/archives/add_archive.dart';
import 'package:fokad_admin/src/pages/archives/archive_page.dart';
import 'package:fokad_admin/src/pages/auth/login_auth.dart';
import 'package:fokad_admin/src/pages/auth/profil_page.dart';
import 'package:fokad_admin/src/pages/budgets/budget_dd/budget_dd.dart';
import 'package:fokad_admin/src/pages/budgets/budgets_previsionels/budgets_previsionnels.dart';
import 'package:fokad_admin/src/pages/budgets/budgets_previsionels/components/add_budget_previsionel.dart';
import 'package:fokad_admin/src/pages/budgets/dashboard/dashboard_budget.dart';
import 'package:fokad_admin/src/pages/budgets/historique_budget/historique_budgets_previsionnels.dart';
import 'package:fokad_admin/src/pages/comm_marketing/c_m_dd/c_m_dd.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/achats/achats_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/bon_livraison/bon_livraison_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/cart/cart_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/creance_fact_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/factures_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/history_livraison/history_livaison_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/history_ravitaillement/history_ravitaillement_ipage.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/components/add_prod_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/prod_model_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/restitutions/restitution_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/add_stock_global.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/stocks_global_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/add_succursale.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/succursale_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/ventes/ventes_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/dashboard/dashboard_com_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/agenda_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/annuaire_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/campaign_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/campaign/add_campaign.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/balance_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/components/add_balance_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/bilan/bilan_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/bilan/components/add_bilan.dart';
import 'package:fokad_admin/src/pages/comptabilite/compt_dd/comptabilite_dd.dart';
import 'package:fokad_admin/src/pages/comptabilite/compte_resultat/components/add_compte_resultat.dart';
import 'package:fokad_admin/src/pages/comptabilite/compte_resultat/compte_resultat.dart';
import 'package:fokad_admin/src/pages/comptabilite/dashboard/dashboard_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/grand_livre/grand_livre_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/components/add_journal_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/journal_comptabilite.dart';
import 'package:fokad_admin/src/pages/devis/components/add_devis.dart';
import 'package:fokad_admin/src/pages/devis/devis_page.dart';
import 'package:fokad_admin/src/pages/exploitations/dashboard/dashboard_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/expl_dd/exploitaion_dd.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/add_projet_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/projets_expo.dart';
import 'package:fokad_admin/src/pages/exploitations/taches/tache_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/versements/versement_projet.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/dashboard_finance.dart';
import 'package:fokad_admin/src/pages/finances/dd_finance/departement_fin.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/banque_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/caisses_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/creance_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/dette_transcations.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/fin_externe_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/transactions_fincance.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/add_anguin_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/add_carburant.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/add_trajet_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/anguin_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/carburant_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/trajet_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/dashboard/dashboard_log.dart';
import 'package:fokad_admin/src/pages/logistiques/entretiens/add_entretien.dart';
import 'package:fokad_admin/src/pages/logistiques/entretiens/entretien_page.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/log_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/add_etat_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/add_immobilier.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/add_mobiler_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/etat_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/immobilier_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/mobilier_materiel.dart';
import 'package:fokad_admin/src/pages/mails/components/new_mail.dart';
import 'package:fokad_admin/src/pages/mails/mails_page.dart';
import 'package:fokad_admin/src/pages/rh/agents/agents_rh.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/add_agent.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/detail_agent_page.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/dashboard_rh.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/departement_rh.dart';
import 'package:fokad_admin/src/pages/rh/paiements/components/add_paiement_salaire.dart';
import 'package:fokad_admin/src/pages/rh/paiements/components/paiement_bulletin.dart';
import 'package:fokad_admin/src/pages/rh/paiements/paiements_rh.dart';
import 'package:fokad_admin/src/pages/rh/performences/performences_rh.dart';
import 'package:fokad_admin/src/pages/rh/presences/components/add_presence.dart';
import 'package:fokad_admin/src/pages/rh/presences/presences_rh.dart';
import 'package:fokad_admin/src/pages/screens/help_screen.dart';
import 'package:fokad_admin/src/pages/screens/settings_screen.dart';
import 'package:routemaster/routemaster.dart';

import '../app_state/app_state.dart';

class UserRoutes {
  static const login = "/";
  static const logout = "/login";
  static const profile = "/profile";
  static const helps = "/helps";
  static const settings = "/settings";
  static const splash = "/splash";
  static const forgotPassword = "/forgot-password";
  static const changePassword = "/change-password";
}

class DevisRoutes {
  static const devis = "/devis";
  static const devisAdd= "/devis-add";
}

class AdminRoutes {
  static const home = "/";
  static const adminDashboard = "/admin-dashboard";
  static const adminRH = "/admin-rh";
  static const adminBudget = "/admin-budget";
  static const adminComptabilite = "/admin-comptabilite";
  static const adminFinance = "/admin-finances";
  static const adminExploitation = "/admin-exploitations";
  static const adminCommMarketing = "/admin-commercial-marketing";
  static const adminLogistique = "/admin-logistiques";
}

class RhRoutes {
  static const rhDashboard = "/rh-dashboard";
  static const rhAgent = "/rh-agents";
  static const rhAgentPage = "/rh-agents-page/:id";
  static const rhAgentAdd = "/rh-agents-add";
  static const rhPaiement = "/rh-paiements";
  static const rhPaiementAdd = "/rh-paiements-add";
  static const rhPaiementBulletin = "/rh-paiements-bulletin/:id";
  static const rhPresence = "/rh-presences";
  static const rhPresenceAdd = "/rh-presences-add";
  static const rhPerformence = "/rh-performence";
  static const rhPerformenceAdd = "/rh-performence-add";
  static const rhDD = "/rh-dd";
}

class BudgetRoutes {
  static const budgetDashboard = "/budget-dashboard";
  static const budgetDD = "/budget-dd";
  static const budgetBudgetPrevisionel = "/budgets-previsionels";
  static const budgetBudgetPrevisionelAdd = "/budgets-previsionels-add";
  static const historiqueBudgetBudgetPrevisionel = "/historique-budgets-previsionels";
}

class FinanceRoutes {
  static const financeDashboard = "/finance-dashboard";
  static const financeTransactions = "/finance-transactions";
  static const transactionsCaisse = "/transactions-caisse";
  static const transactionsBanque = "/transactions-banque";
  static const transactionsDettes = "/transactions-dettes";
  static const transactionsCreances = "/transactions-creances";
  static const transactionsFinancementExterne =
      "/transactions-financement-externe";
  static const transactionsDepenses = "/transactions-depenses";
  static const finDD = "/fin-dd";
}

class ComptabiliteRoutes {
  static const comptabiliteDashboard = "/comptabilite-dashboard";
  static const comptabiliteBilan = "/comptabilite-bilan";
  static const comptabiliteBilanAdd = "/comptabilite-bilan-add";
  static const comptabiliteJournal = "/comptabilite-journal";
  static const comptabiliteJournalAdd = "/comptabilite-journal-add";
  static const comptabiliteCompteResultat = "/comptabilite-compte-resultat";
  static const comptabiliteCompteResultatAdd = "/comptabilite-compte-resultat-add";
  static const comptabiliteBalance = "/comptabilite-balance";
  static const comptabiliteBalanceAdd = "/comptabilite-balance-add";
  static const comptabiliteGrandLivre = "/comptabilite-grand-livre";
  static const comptabiliteDD = "/comptabilite-dd";
}

class LogistiqueRoutes {
  static const logDashboard = "/log-dashboard";
  static const logAnguinAuto = "/log-anguin-auto";
  static const logAddAnguinAuto = "/log-add-anguin-auto";
  static const logAddCarburantAuto = "/log-add-carburant-auto";
  static const logCarburantAuto = "/log-carburant-auto";
  static const logAddTrajetAuto = "/log-add-trajet-auto";
  static const logTrajetAuto = "/log-trajet-auto";
  static const logAddEntretien = "/log-add-entretien";
  static const logEntretien = "/log-entretien";

  static const logAddEtatMateriel = "/log-add-etat-materiel";
  static const logEtatMateriel = "/log-etat-materiel";
  static const logAddImmobilerMateriel = "/log-add-immobilier-materiel";
  static const logImmobilierMateriel = "/log-immobilier-materiel";
  static const logAddMobilierMateriel = "/log-add-mobilier-materiel";
  static const logMobilierMateriel = "/log-mobilier-materiel";
  static const logDD = "/log-dd";
}

class ExploitationRoutes {
  static const expDashboard = "/exploitation-dashboard";
  static const expProjetAdd = "/exploitation-projets-add";
  static const expProjet = "/exploitation-projets";
  static const expTacheAdd = "/exploitation-taches-add";
  static const expTache = "/exploitation-taches";
  static const expVirement = "/exploitation-virement";
  static const expDD = "/exp-dd";
}

class ComMarketingRoutes {
  static const comMarketingDD = "/com-marketing-dd";
  static const comMarketingDashboard = "/com-marketing-dashboard";
  // Marketing
  static const comMarketingAnnuaire = "/com-marketing-annuaire";
  static const comMarketingAgenda = "/com-marketing-agenda";
  static const comMarketingCampaign = "/com-marketing-campaign";
  static const comMarketingCampaignAdd = "/com-marketing-campaign-add";
  // Commercial
  static const comMarketingProduitModel = "/com-marketing-produit-model";
  static const comMarketingProduitModelAdd = "/com-marketing-produit-model-add";
  static const comMarketingStockGlobal = "/com-marketing-stock-global";
  static const comMarketingStockGlobalAdd = "/com-marketing-stock-global-add";
  static const comMarketingSuccursale = "/com-marketing-succursale";
  static const comMarketingSuccursaleAdd = "/com-marketing-succursale-add";
  static const comMarketingAchat = "/com-marketing-achat";
  static const comMarketingBonLivraison = "/com-marketing-bon-livraison";
  static const comMarketingcart = "/com-marketing-cart";
  static const comMarketingCreance = "/com-marketing-creance";
  static const comMarketingFacture = "/com-marketing-facture";
  static const comMarketingGain = "/com-marketing-gain";
  static const comMarketingHistoryRavitaillement = "/com-marketing-history-ravitaillement";
  static const comMarketingHistoryLivraison = "/com-marketing-history-livraison";
  static const comMarketingnumberFact = "/com-marketing-number-fact";
  static const comMarketingRestitution = "/com-marketing-restitution";
  static const comMarketingVente = "/com-marketing-vente";
}

class ArchiveRoutes {
  static const arcihves = "/arcihves";
  static const addArcihves = "/arcihves-add";
}

class MailRoutes {
  static const mails = "/mails";
  static const addMail = "/mail-add";
}

class Routing {
  final loggedOutRouteMap = RouteMap(
    onUnknownRoute: (route) => const Redirect(UserRoutes.login),
    routes: {
      UserRoutes.login: (_) => const MaterialPage(child: LoginPage()),
      UserRoutes.logout: (_) => const MaterialPage(child: LoginPage()),
    },
  );

  RouteMap buildRouteMap(AppState appState) {
    return RouteMap(
      routes: {
        UserRoutes.profile: (_) => const MaterialPage(child: ProfilPage()),
        UserRoutes.helps: (_) => const MaterialPage(child: HelpScreen()),
        UserRoutes.settings: (_) => const MaterialPage(child: SettingsScreen()),
        // UserRoutes.forgotPassword: (_) => const MaterialPage(child: ForgotPassword()),
        // UserRoutes.changePassword: (_) => const MaterialPage(child: ChangePassword()),

        // Administration
        AdminRoutes.home: (_) =>
            const MaterialPage(child: DashboardAdministration()),
        AdminRoutes.adminDashboard: (_) =>
            const MaterialPage(child: DashboardAdministration()),
        AdminRoutes.adminRH: (_) => const MaterialPage(child: RhAdmin()),
        AdminRoutes.adminBudget: (_) =>
            const MaterialPage(child: BudgetsAdmin()),
        AdminRoutes.adminFinance: (_) =>
            const MaterialPage(child: FinancesAdmin()),
        AdminRoutes.adminComptabilite: (_) =>
            const MaterialPage(child: CompteAdmin()),
        AdminRoutes.adminExploitation: (_) =>
            const MaterialPage(child: ExploitationsAdmin()),
        AdminRoutes.adminCommMarketing: (_) =>
            const MaterialPage(child: CommMarketingAdmin()),
        AdminRoutes.adminLogistique: (_) =>
            const MaterialPage(child: LogistiquesAdmin()),

        // RH
        RhRoutes.rhDashboard: (_) => const MaterialPage(child: DashboardRh()),
        RhRoutes.rhAgent: (_) => const MaterialPage(child: AgentsRh()),
        RhRoutes.rhAgentPage: (info) => MaterialPage(
            child: AgentPage(id: info.queryParameters['id'] as int)),
        RhRoutes.rhAgentAdd: (_) => const MaterialPage(child: AddAgent()),
        RhRoutes.rhPaiement: (_) => const MaterialPage(child: PaiementRh()),
        "${RhRoutes.rhPaiementAdd}/:id": (info) =>
            const MaterialPage(child: AddPaiementSalaire()),
        RhRoutes.rhPaiementBulletin: (info) => MaterialPage(
            child: PaiementBulletin(id: info.queryParameters['id'] as int)),
        RhRoutes.rhPresence: (_) => const MaterialPage(child: PresenceRh()),
        RhRoutes.rhPresenceAdd: (_) => const MaterialPage(child: AddPresence()),
        RhRoutes.rhPerformence: (_) =>
            const MaterialPage(child: PerformenceRH()),
        RhRoutes.rhDD: (_) => const MaterialPage(child: DepartementRH()),

        // Budget
        BudgetRoutes.budgetDashboard: (_) =>
            const MaterialPage(child: DashboardBudget()),
        BudgetRoutes.budgetDD: (_) =>
            const MaterialPage(child: BudgetDD()),
        BudgetRoutes.budgetBudgetPrevisionel: (_) => const MaterialPage(child: BudgetsPrevisionnels()),
        BudgetRoutes.budgetBudgetPrevisionelAdd: (_) =>
            const MaterialPage(child: AddBudgetPrevionel()),
        BudgetRoutes.historiqueBudgetBudgetPrevisionel: (_) =>
            const MaterialPage(child: HistoriqueBudgetsPrevisionnels()),

        // Finance
        FinanceRoutes.financeDashboard: (_) =>
            const MaterialPage(child: DashboardFinance()),
        FinanceRoutes.financeTransactions: (_) =>
            const MaterialPage(child: TransactionsFinance()),
        FinanceRoutes.transactionsBanque: (_) =>
            const MaterialPage(child: BanqueTransactions()),
        FinanceRoutes.transactionsCaisse: (_) =>
            const MaterialPage(child: CaisseTransactions()),
        FinanceRoutes.transactionsCreances: (_) =>
            const MaterialPage(child: CreanceTransactions()),
        FinanceRoutes.transactionsDettes: (_) =>
            const MaterialPage(child: DetteTransactions()),
        FinanceRoutes.transactionsFinancementExterne: (_) =>
            const MaterialPage(child: FinExterneTransactions()),
        FinanceRoutes.finDD: (_) => const MaterialPage(child: DepartementFin()),

        // Comptabilite
        ComptabiliteRoutes.comptabiliteDD: (_) => const MaterialPage(child: ComptabiliteDD()),
        ComptabiliteRoutes.comptabiliteDashboard: (_) => const MaterialPage(child: DashboardComptabilite()),
        ComptabiliteRoutes.comptabiliteBilan: (_) => const MaterialPage(child: BilanComptabilite()),
        ComptabiliteRoutes.comptabiliteBilanAdd: (_) => const MaterialPage(child: AddBilan()),
        ComptabiliteRoutes.comptabiliteJournal: (_) => const MaterialPage(child: JournalComptabilite()),
        ComptabiliteRoutes.comptabiliteJournalAdd: (_) => const MaterialPage(child: AddJournalComptabilite()),
        ComptabiliteRoutes.comptabiliteCompteResultat: (_) => const MaterialPage(child: CompteResultat()),
        ComptabiliteRoutes.comptabiliteCompteResultatAdd: (_) => const MaterialPage(child: AddCompteResultat()),
        ComptabiliteRoutes.comptabiliteBalance: (_) => const MaterialPage(child: BalanceComptabilite()),
        ComptabiliteRoutes.comptabiliteBalanceAdd: (_) => const MaterialPage(child: AddBalanceComptabilite()),
        ComptabiliteRoutes.comptabiliteGrandLivre: (_) => const MaterialPage(child: GrandLivreComptabilite()),

        // DEVIS
        DevisRoutes.devis: (_) => const MaterialPage(child: DevisPage()),
        DevisRoutes.devisAdd: (_) => const MaterialPage(child: AddDevis()),

        // LOGISTIQUES
        LogistiqueRoutes.logDD: (_) => const MaterialPage(child: LogDD()),
        LogistiqueRoutes.logDashboard: (_) =>
            const MaterialPage(child: DashboardLog()),
        LogistiqueRoutes.logAddAnguinAuto: (_) =>
            const MaterialPage(child: AddAnguinAuto()),
        LogistiqueRoutes.logAnguinAuto: (_) =>
            const MaterialPage(child: AnguinAuto()),
        LogistiqueRoutes.logAddCarburantAuto: (_) =>
            const MaterialPage(child: AddCarburantAuto()),
        LogistiqueRoutes.logCarburantAuto: (_) =>
            const MaterialPage(child: CarburantAuto()),
        LogistiqueRoutes.logAddTrajetAuto: (_) =>
            const MaterialPage(child: AddTrajetAuto()),
        LogistiqueRoutes.logTrajetAuto: (_) =>
            const MaterialPage(child: TrajetAuto()),
        LogistiqueRoutes.logAddEntretien: (_) =>
            const MaterialPage(child: AddEntretienPage()),
        LogistiqueRoutes.logEntretien: (_) =>
            const MaterialPage(child: EntretienPage()),
        LogistiqueRoutes.logAddEtatMateriel: (_) =>
            const MaterialPage(child: AddEtatMateriel()),
        LogistiqueRoutes.logEtatMateriel: (_) =>
            const MaterialPage(child: EtatMateriel()),
        LogistiqueRoutes.logAddImmobilerMateriel: (_) =>
            const MaterialPage(child: AddImmobilierMateriel()),
        LogistiqueRoutes.logImmobilierMateriel: (_) =>
            const MaterialPage(child: ImmobilierMateriel()),
        LogistiqueRoutes.logAddMobilierMateriel: (_) =>
            const MaterialPage(child: AddMobilerMateriel()),
        LogistiqueRoutes.logMobilierMateriel: (_) =>
            const MaterialPage(child: MobilierMateriel()),

        // Exploitations
        ExploitationRoutes.expDD: (_) =>
            const MaterialPage(child: ExploitationDD()),
        ExploitationRoutes.expDashboard: (_) =>
            const MaterialPage(child: DashboardExp()),
        ExploitationRoutes.expProjetAdd: (_) =>
            const MaterialPage(child: AddProjetExp()),
        ExploitationRoutes.expProjet: (_) =>
            const MaterialPage(child: ProjetsExp()),
        ExploitationRoutes.expVirement: (_) =>
            const MaterialPage(child: VersementProjet()),
        ExploitationRoutes.expTache: (_) =>
            const MaterialPage(child: TacheExp()),

        // Marketing
        ComMarketingRoutes.comMarketingDD: (_) =>
            const MaterialPage(child: CMDD()),
        ComMarketingRoutes.comMarketingDashboard: (_) =>
            const MaterialPage(child: ComMarketing()),
        ComMarketingRoutes.comMarketingAnnuaire: (_) =>
            const MaterialPage(child: AnnuaireMarketing()),
        ComMarketingRoutes.comMarketingAgenda: (_) =>
            const MaterialPage(child: AgendaMarketing()),
        ComMarketingRoutes.comMarketingCampaign: (_) =>
            const MaterialPage(child: CampaignMarketing()),
        ComMarketingRoutes.comMarketingCampaignAdd: (_) =>
            const MaterialPage(child: AddCampaign()),

        // Commercial
        ComMarketingRoutes.comMarketingProduitModel: (_) =>
            const MaterialPage(child: ProduitModelPage()),
        ComMarketingRoutes.comMarketingProduitModelAdd: (_) =>
            const MaterialPage(child: AddProModel()),
        ComMarketingRoutes.comMarketingStockGlobal: (_) =>
            const MaterialPage(child: StockGlobalPage()),
        ComMarketingRoutes.comMarketingStockGlobalAdd: (_) =>
            const MaterialPage(child: AddStockGlobal()),
        ComMarketingRoutes.comMarketingSuccursale: (_) =>
            const MaterialPage(child: SuccursalePage()),
        ComMarketingRoutes.comMarketingSuccursaleAdd: (_) =>
            const MaterialPage(child: AddSurrsale()),
        ComMarketingRoutes.comMarketingAchat: (_) => const MaterialPage(child: AchatsPage()),
        ComMarketingRoutes.comMarketingBonLivraison: (_) => const MaterialPage(child: BonLivraisonPage()),
        ComMarketingRoutes.comMarketingRestitution: (_) => const MaterialPage(child: RestitutionPage()),
        ComMarketingRoutes.comMarketingFacture: (_) => const MaterialPage(child: FacturePage()),
        ComMarketingRoutes.comMarketingCreance: (_) => const MaterialPage(child: CreanceFactPage()),
        ComMarketingRoutes.comMarketingVente: (_) => const MaterialPage(child: VentesPage()),
        ComMarketingRoutes.comMarketingcart: (_) => const MaterialPage(child: CartPage()),
        ComMarketingRoutes.comMarketingHistoryRavitaillement: (_) => const MaterialPage(child: HistoryRavitaillement()),
        ComMarketingRoutes.comMarketingHistoryLivraison: (_) => const MaterialPage(child: HistoryLivraison()),

        MailRoutes.mails: (_) => const MaterialPage(child: MailPages()),
        MailRoutes.addMail: (_) => const MaterialPage(child: NewMail()),

        ArchiveRoutes.arcihves: (_) => const MaterialPage(child: ArchivePage()),
        ArchiveRoutes.addArcihves: (_) => const MaterialPage(child: AddArchive()),
      },
    );
  }
}
