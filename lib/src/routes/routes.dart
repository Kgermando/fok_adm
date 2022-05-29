import 'package:flutter/material.dart';
import 'package:fokad_admin/src/pages/administration/budgets_admin.dart';
import 'package:fokad_admin/src/pages/administration/comm_marketing_admin.dart';
import 'package:fokad_admin/src/pages/administration/comptes_admin.dart';
import 'package:fokad_admin/src/pages/administration/dashboard_administration.dart';
import 'package:fokad_admin/src/pages/administration/etat_besoin_page.dart';
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
import 'package:fokad_admin/src/pages/finances/transactions/components/banque_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/caisses_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/components/banques/add_depot_banque.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/components/banques/add_retrait_banque.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/components/caisses/add_decaissement.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/components/caisses/add_encaissement.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/components/fin_exterieur/add_autre_fin.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/creance_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/dette_transcations.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/fin_externe_transactions.dart';
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
import 'package:fokad_admin/src/pages/rh/dashboard/dashboard_rh.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/departement_rh.dart';
import 'package:fokad_admin/src/pages/rh/paiements/components/add_paiement_salaire.dart';
import 'package:fokad_admin/src/pages/rh/paiements/paiements_rh.dart';
import 'package:fokad_admin/src/pages/rh/performences/performences_rh.dart';
import 'package:fokad_admin/src/pages/rh/presences/components/add_presence.dart';
import 'package:fokad_admin/src/pages/rh/presences/presences_rh.dart';
import 'package:fokad_admin/src/pages/screens/help_screen.dart';
import 'package:fokad_admin/src/pages/screens/settings_screen.dart';


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
  static const devisAdd = "/devis-add";
}

class AdminRoutes {
  static const adminDashboard = "/admin-dashboard";
  static const adminRH = "/admin-rh";
  static const adminBudget = "/admin-budget";
  static const adminComptabilite = "/admin-comptabilite";
  static const adminFinance = "/admin-finances";
  static const adminExploitation = "/admin-exploitations";
  static const adminCommMarketing = "/admin-commercial-marketing";
  static const adminLogistique = "/admin-logistiques";
  static const adminEtatBesoin = "/admin-etat-besoin";
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
  static const historiqueBudgetBudgetPrevisionel =
      "/historique-budgets-previsionels";
}

class FinanceRoutes {
  static const financeDashboard = "/finance-dashboard";
  static const financeTransactions = "/finance-transactions";
  static const transactionsCaisse = "/transactions-caisse";
  static const transactionsCaisseEncaissement =
      "/transactions-caisse-encaissement";
  static const transactionsCaisseDecaissement =
      "/transactions-caisse-decaissement";
  static const transactionsBanque = "/transactions-banque";
  static const transactionsBanqueRetrait = "/transactions-banque-retrait";
  static const transactionsBanqueDepot = "/transactions-banque-depot";
  static const transactionsDettes = "/transactions-dettes";
  static const transactionsCreances = "/transactions-creances";
  static const transactionsFinancementExterne =
      "/transactions-financement-externe";
  static const transactionsFinancementExterneAdd =
      "/transactions-financement-externe-add";
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
  static const comptabiliteCompteResultatAdd =
      "/comptabilite-compte-resultat-add";
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
  static const comMarketingHistoryRavitaillement =
      "/com-marketing-history-ravitaillement";
  static const comMarketingHistoryLivraison =
      "/com-marketing-history-livraison";
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

final routes = <String, WidgetBuilder>{
  // User
  UserRoutes.login : (context) => const LoginPage(),
  UserRoutes.logout: (context) => const LoginPage(),
  UserRoutes.profile : (context) => const ProfilPage(),
  UserRoutes.helps: (context) => const HelpScreen(),
  UserRoutes.settings: (context) => const SettingsScreen(),

  // Administration
  AdminRoutes.adminDashboard: (context) => const DashboardAdministration(),
  AdminRoutes.adminRH: (context) => const RhAdmin(),
  AdminRoutes.adminBudget: (context) => const BudgetsAdmin(),
  AdminRoutes.adminFinance: (context) => const FinancesAdmin(),
  AdminRoutes.adminComptabilite: (context) => const CompteAdmin(),
  AdminRoutes.adminExploitation: (context) => const ExploitationsAdmin(),
  AdminRoutes.adminCommMarketing: (context) => const CommMarketingAdmin(),
  AdminRoutes.adminLogistique: (context) => const LogistiquesAdmin(),
  AdminRoutes.adminEtatBesoin: (context) => const EtatBesoinAdmin(),

  // RH
  RhRoutes.rhDashboard: (context) => const DashboardRh(),
  RhRoutes.rhAgent: (context) => const AgentsRh(),
  RhRoutes.rhAgentAdd: (context) => const AddAgent(),
  RhRoutes.rhPaiement: (context) => const PaiementRh(),
  RhRoutes.rhPaiementAdd: (context) => const AddPaiementSalaire(),
  RhRoutes.rhPresence: (context) => const PresenceRh(),
  RhRoutes.rhPresenceAdd: (context) => const AddPresence(),
  RhRoutes.rhPerformence: (context) => const PerformenceRH(),
  RhRoutes.rhDD: (context) => const DepartementRH(),

  // Budgets
  BudgetRoutes.budgetDashboard: (context) => const DashboardBudget(),
  BudgetRoutes.budgetDD: (context) => const BudgetDD(),
  BudgetRoutes.budgetBudgetPrevisionel: (context) => const BudgetsPrevisionnels(),
  BudgetRoutes.budgetBudgetPrevisionelAdd: (context) => const AddBudgetPrevionel(),
  BudgetRoutes.historiqueBudgetBudgetPrevisionel: (context) => const HistoriqueBudgetsPrevisionnels(),

  // FInance
  FinanceRoutes.financeDashboard: (context) => const DashboardFinance(),
  FinanceRoutes.transactionsBanque: (context) => const BanqueTransactions(),
  FinanceRoutes.transactionsBanqueDepot: (context) => const AddDepotBanque(),
  FinanceRoutes.transactionsBanqueRetrait: (context) => const AddRetratBanque(),
  FinanceRoutes.transactionsCaisse: (context) => const CaisseTransactions(),
  FinanceRoutes.transactionsCaisseEncaissement: (context) => const AddEncaissement(),
  FinanceRoutes.transactionsCaisseDecaissement: (context) => const AddDecaissement(),
  FinanceRoutes.transactionsCreances: (context) => const CreanceTransactions(),
  FinanceRoutes.transactionsDettes: (context) => const DetteTransactions(),
  FinanceRoutes.transactionsFinancementExterne: (context) => const FinExterneTransactions(),
  FinanceRoutes.transactionsFinancementExterneAdd: (context) => const AddAutreFin(),

  // Comptabilite
  ComptabiliteRoutes.comptabiliteDD: (context) => const ComptabiliteDD(),
  ComptabiliteRoutes.comptabiliteDashboard: (context) => const DashboardComptabilite(),
  ComptabiliteRoutes.comptabiliteBilan: (context) =>const BilanComptabilite(),
  ComptabiliteRoutes.comptabiliteBilanAdd: (context) => const AddBilan(),
  ComptabiliteRoutes.comptabiliteJournal: (context) => const JournalComptabilite(),
  ComptabiliteRoutes.comptabiliteJournalAdd: (context) => const AddJournalComptabilite(),
  ComptabiliteRoutes.comptabiliteCompteResultat: (context) =>const CompteResultat(),
  ComptabiliteRoutes.comptabiliteCompteResultatAdd: (context) => const AddCompteResultat(),
  ComptabiliteRoutes.comptabiliteBalance: (context) => const BalanceComptabilite(),
  ComptabiliteRoutes.comptabiliteBalanceAdd: (context) => const AddBalanceComptabilite(),
  ComptabiliteRoutes.comptabiliteGrandLivre: (context) => const GrandLivreComptabilite(),

  // DEVIS
  DevisRoutes.devis: (context) => const DevisPage(),
  DevisRoutes.devisAdd: (context) => const AddDevis(),

  // LOGISTIQUES
  LogistiqueRoutes.logDD: (context) => const LogDD(),
  LogistiqueRoutes.logDashboard: (context) => const DashboardLog(),
  LogistiqueRoutes.logAddAnguinAuto: (context) => const AddAnguinAuto(),
  LogistiqueRoutes.logAnguinAuto: (context) =>const AnguinAuto(),
  LogistiqueRoutes.logAddCarburantAuto: (context) => const AddCarburantAuto(),
  LogistiqueRoutes.logCarburantAuto: (context) => const CarburantAuto(),
  LogistiqueRoutes.logAddTrajetAuto: (context) => const AddTrajetAuto(),
  LogistiqueRoutes.logTrajetAuto: (context) => const TrajetAuto(),
  LogistiqueRoutes.logAddEntretien: (context) => const AddEntretienPage(),
  LogistiqueRoutes.logEntretien: (context) => const EntretienPage(),
  LogistiqueRoutes.logAddEtatMateriel: (context) => const AddEtatMateriel(),
  LogistiqueRoutes.logEtatMateriel: (context) => const EtatMateriel(),
  LogistiqueRoutes.logAddImmobilerMateriel: (context) => const AddImmobilierMateriel(),
  LogistiqueRoutes.logImmobilierMateriel: (context) =>const ImmobilierMateriel(),
  LogistiqueRoutes.logAddMobilierMateriel: (context) =>const AddMobilerMateriel(),
  LogistiqueRoutes.logMobilierMateriel: (context) =>const MobilierMateriel(),

  // Exploitations
  ExploitationRoutes.expDD: (context) => const ExploitationDD(),
  ExploitationRoutes.expDashboard: (context) => const DashboardExp(),
  ExploitationRoutes.expProjetAdd: (context) => const AddProjetExp(),
  ExploitationRoutes.expProjet: (context) => const ProjetsExp(),
  ExploitationRoutes.expVirement: (context) => const VersementProjet(),
  ExploitationRoutes.expTache: (context) => const TacheExp(),

  // Marketing
  ComMarketingRoutes.comMarketingDD: (context) => const CMDD(),
  ComMarketingRoutes.comMarketingDashboard: (context) =>const ComMarketing(),
  ComMarketingRoutes.comMarketingAnnuaire: (context) =>const AnnuaireMarketing(),
  ComMarketingRoutes.comMarketingAgenda: (context) => const AgendaMarketing(),
  ComMarketingRoutes.comMarketingCampaign: (context) =>const CampaignMarketing(),
  ComMarketingRoutes.comMarketingCampaignAdd: (context) =>const AddCampaign(),

  // Commercial
  ComMarketingRoutes.comMarketingProduitModel: (context) =>const ProduitModelPage(),
  ComMarketingRoutes.comMarketingProduitModelAdd: (context) =>const AddProModel(),
  ComMarketingRoutes.comMarketingStockGlobal: (context) =>const StockGlobalPage(),
  ComMarketingRoutes.comMarketingStockGlobalAdd: (context) =>const AddStockGlobal(),
  ComMarketingRoutes.comMarketingSuccursale: (context) =>const SuccursalePage(),
  ComMarketingRoutes.comMarketingSuccursaleAdd: (context) =>const AddSurrsale(),
  ComMarketingRoutes.comMarketingAchat: (context) =>const AchatsPage(),
  ComMarketingRoutes.comMarketingBonLivraison: (context) =>const BonLivraisonPage(),
  ComMarketingRoutes.comMarketingRestitution: (context) =>const RestitutionPage(),
  ComMarketingRoutes.comMarketingFacture: (context) =>const FacturePage(),
  ComMarketingRoutes.comMarketingCreance: (context) =>const CreanceFactPage(),
  ComMarketingRoutes.comMarketingVente: (context) =>const VentesPage(),
  ComMarketingRoutes.comMarketingcart: (context) =>const CartPage(),
  ComMarketingRoutes.comMarketingHistoryRavitaillement: (context) =>const HistoryRavitaillement(),
  ComMarketingRoutes.comMarketingHistoryLivraison: (context) =>const HistoryLivraison(),


  // Mails
  MailRoutes.mails: (context) => const MailPages(),
  MailRoutes.addMail: (context) => const NewMail(),

  // Archives
  ArchiveRoutes.arcihves: (context) => const ArchivePage(),
  ArchiveRoutes.addArcihves: (context) => const AddArchive(),
};
