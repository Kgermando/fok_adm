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
import 'package:fokad_admin/src/pages/archives/archive_folder.dart';
import 'package:fokad_admin/src/pages/archives/components/archive_pdf_viewer.dart';
import 'package:fokad_admin/src/pages/archives/detail_archive.dart';
import 'package:fokad_admin/src/pages/archives/table_archive.dart';
import 'package:fokad_admin/src/pages/auth/login_auth.dart';
import 'package:fokad_admin/src/pages/auth/profil_page.dart';
import 'package:fokad_admin/src/pages/budgets/budget_dd/budget_dd.dart';
import 'package:fokad_admin/src/pages/budgets/budgets_previsionels/budgets_previsionnels.dart';
import 'package:fokad_admin/src/pages/budgets/budgets_previsionels/components/add_budget_previsionel.dart';
import 'package:fokad_admin/src/pages/budgets/budgets_previsionels/components/detail_departement_budget.dart';
import 'package:fokad_admin/src/pages/budgets/dashboard/dashboard_budget.dart';
import 'package:fokad_admin/src/pages/budgets/etat_besoin/etat_besoin_budgets_page.dart';
import 'package:fokad_admin/src/pages/budgets/historique_budget/historique_budgets_previsionnels.dart';
import 'package:fokad_admin/src/pages/budgets/ligne_budgetaire/components/ajout_ligne_budgetaire.dart';
import 'package:fokad_admin/src/pages/budgets/ligne_budgetaire/components/detail_ligne_budgetaire.dart';
import 'package:fokad_admin/src/pages/comm_marketing/c_m_dd/c_m_dd.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/achats/achats_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/bon_livraison/bon_livraison_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/cart/cart_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/creance_fact_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/factures_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/history_livraison/history_livaison_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/history_ravitaillement/history_ravitaillement_ipage.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/components/add_prod_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/components/detail_prod_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/components/update_prod_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/prod_model_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/restitutions/restitution_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/add_stock_global.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/stocks_global_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/add_succursale.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/detail_succurssale.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/succursale_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/ventes/ventes_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/dashboard/dashboard_com_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/etat_besoin/etat_besoin_cm_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/agenda_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/annuaire_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/campaign_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/add_agenda.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/detail_agenda.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/update_agenda.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/annuaire/add_annuaire.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/annuaire/detail_annuaire.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/annuaire/update_annuaire.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/campaign/add_campaign.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/campaign/detail_campaign.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/campaign/update_campaign.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/balance_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/components/add_compte_balance_ref.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/components/detail_balance.dart';
import 'package:fokad_admin/src/pages/comptabilite/bilan/bilan_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/bilan/components/add_comptes_bilan.dart';
import 'package:fokad_admin/src/pages/comptabilite/bilan/components/detail_bilan.dart';
import 'package:fokad_admin/src/pages/comptabilite/compt_dd/comptabilite_dd.dart';
import 'package:fokad_admin/src/pages/comptabilite/compte_resultat/components/add_compte_resultat.dart';
import 'package:fokad_admin/src/pages/comptabilite/compte_resultat/components/detail_compte_resultat.dart';
import 'package:fokad_admin/src/pages/comptabilite/compte_resultat/components/update_compte_resultat.dart';
import 'package:fokad_admin/src/pages/comptabilite/compte_resultat/compte_resultat.dart';
import 'package:fokad_admin/src/pages/comptabilite/dashboard/dashboard_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/etat_besoin/etat_besoin_comptabilite_page.dart';
import 'package:fokad_admin/src/pages/comptabilite/grand_livre/grand_livre_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/components/add_journal_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/components/detail_journal.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/journal_comptabilite.dart';
import 'package:fokad_admin/src/pages/devis/components/detail_devis.dart';
import 'package:fokad_admin/src/pages/devis/devis_page.dart';
import 'package:fokad_admin/src/pages/exploitations/dashboard/dashboard_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/etat_besoin/etat_besoin_exp_page.dart';
import 'package:fokad_admin/src/pages/exploitations/expl_dd/exploitaion_dd.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/add_projet_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/components/detail_projet.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/components/update_projet.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/projets_expo.dart';
import 'package:fokad_admin/src/pages/exploitations/taches/add_tache_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/taches/components/detail_tache.dart';
import 'package:fokad_admin/src/pages/exploitations/taches/tache_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/versements/add_versement_projet.dart';
import 'package:fokad_admin/src/pages/exploitations/versements/components/detail_versement_projet.dart';
import 'package:fokad_admin/src/pages/exploitations/versements/versement_projet.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/dashboard_finance.dart';
import 'package:fokad_admin/src/pages/finances/dd_finance/departement_fin.dart';
import 'package:fokad_admin/src/pages/finances/etat_besoin/etat_besoin_fin_page.dart';
import 'package:fokad_admin/src/pages/finances/transactions/banque_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/caisses_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/banques/add_depot_banque.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/banques/add_retrait_banque.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/banques/detail_banque.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/caisses/add_decaissement.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/caisses/add_encaissement.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/caisses/detail_caisse.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/creances/detail_creance.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/dettes/detail_dette.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/fin_exterieur/add_autre_fin.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/fin_exterieur/detail_fin_exterieur.dart';
import 'package:fokad_admin/src/pages/finances/transactions/creance_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/dette_transcations.dart';
import 'package:fokad_admin/src/pages/finances/transactions/fin_externe_transactions.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/add_anguin_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/add_carburant.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/add_trajet_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/anguin_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/carburant_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/detail_anguin.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/detail_carburant.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/detail_trajet.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/update_trajet.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/trajet_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/dashboard/dashboard_log.dart';
import 'package:fokad_admin/src/pages/logistiques/entretiens/add_entretien.dart';
import 'package:fokad_admin/src/pages/logistiques/entretiens/components/detail_entretiien.dart';
import 'package:fokad_admin/src/pages/logistiques/entretiens/entretien_page.dart';
import 'package:fokad_admin/src/pages/logistiques/etat_besoin/etat_besoin_log_page.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/log_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/add_etat_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/add_immobilier.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/add_mobiler_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/components/detail_etat_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/components/detail_immobilier.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/components/detail_mobilier.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/etat_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/immobilier_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/mobilier_materiel.dart';
import 'package:fokad_admin/src/pages/mails/components/detail_mail.dart';
import 'package:fokad_admin/src/pages/mails/components/new_mail.dart';
import 'package:fokad_admin/src/pages/mails/components/repondre_mail.dart';
import 'package:fokad_admin/src/pages/mails/components/tranfert_mail.dart';
import 'package:fokad_admin/src/pages/mails/mails_page.dart';
import 'package:fokad_admin/src/pages/rh/agents/agents_rh.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/add_agent.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/detail_agent_page.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/update_agent.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/dashboard_rh.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/departement_rh.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/historique/table_salaires_historique.dart';
import 'package:fokad_admin/src/pages/rh/etat_besoin/etat_besoin_rh_page.dart';
import 'package:fokad_admin/src/pages/rh/paiements/components/add_paiement_salaire.dart';
import 'package:fokad_admin/src/pages/rh/paiements/components/paiement_bulletin.dart';
import 'package:fokad_admin/src/pages/rh/paiements/paiements_rh.dart';
import 'package:fokad_admin/src/pages/rh/performences/components/add_performence_note.dart';
import 'package:fokad_admin/src/pages/rh/performences/components/detail_perfomence.dart';
import 'package:fokad_admin/src/pages/rh/performences/performences_rh.dart';
import 'package:fokad_admin/src/pages/rh/presences/components/detail_presence.dart';
import 'package:fokad_admin/src/pages/rh/presences/components/entrer_presence.dart';
import 'package:fokad_admin/src/pages/rh/presences/components/sortie_presence.dart';
import 'package:fokad_admin/src/pages/rh/presences/presences_rh.dart';
import 'package:fokad_admin/src/pages/rh/transport_restauration/components/detrail_transport_restaurant.dart';
import 'package:fokad_admin/src/pages/rh/transport_restauration/transport_restauration_page.dart';
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
  static const devisDetail = "/devis-detail";
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
  static const rhAgentPage = "/rh-agents-page";
  static const rhAgentPageUser = "/rh-agents-page-user";
  static const rhAgentAdd = "/rh-agents-add";
  static const rhAgentUpdate = "/rh-agents-update";
  static const rhPaiement = "/rh-paiements";
  static const rhPaiementAdd = "/rh-paiements-add";
  static const rhPaiementBulletin = "/rh-paiements-bulletin";
  static const rhPresence = "/rh-presences";
  static const rhPresenceDetail = "/rh-presences-detail";
  static const rhPresenceEntrer = "/rh-presences-entrer";
  static const rhPresenceSortie = "/rh-presences-sortie";
  static const rhPerformence = "/rh-performence";
  static const rhPerformenceDetail = "/rh-performence-detail";
  static const rhPerformenceAddNote = "/rh-performence-add-note";
  static const rhPerformenceAdd = "/rh-performence-add";
  static const rhDD = "/rh-dd";
  static const rhHistoriqueSalaire = "/rh-historique-salaire";
  static const rhEtatBesoin = "/rh-etat-besoin";
  static const rhTransportRest = "/rh-transport-rest";
  static const rhTransportRestDetail = "/rh-transport-rest-detail";
}

class BudgetRoutes {
  static const budgetDashboard = "/budget-dashboard";
  static const budgetDD = "/budget-dd";
  static const budgetBudgetPrevisionel = "/budgets-previsionels";
  static const budgetBudgetPrevisionelAdd = "/budgets-previsionels-add";
  static const budgetLignebudgetaireDetail = "/budgets-ligne-budgetaire-detail";
  static const budgetLignebudgetaireAdd = "/budgets-ligne-budgetaire-add";
  static const historiqueBudgetBudgetPrevisionel =
      "/historique-budgets-previsionels";
  static const budgetBudgetPrevisionelDetail =
      "/budgets-previsionels-detail";
  static const budgetEtatBesoin = "/budgets-etat-besoin";
}

class FinanceRoutes {
  static const financeDashboard = "/finance-dashboard";
  static const financeTransactions = "/finance-transactions";
  static const transactionsCaisse = "/transactions-caisse";
  static const transactionsCaisseDetail = "/transactions-caisse-detail";
  static const transactionsCaisseEncaissement =
      "/transactions-caisse-encaissement";
  static const transactionsCaisseDecaissement =
      "/transactions-caisse-decaissement";
  static const transactionsBanque = "/transactions-banque";
  static const transactionsBanqueDetail = "/transactions-banque-detail";
  static const transactionsBanqueRetrait = "/transactions-banque-retrait";
  static const transactionsBanqueDepot = "/transactions-banque-depot";
  static const transactionsDettes = "/transactions-dettes";
  static const transactionsDetteDetail = "/transactions-dettes-detail";
  static const transactionsCreances = "/transactions-creances";
  static const transactionsCreanceDetail = "/transactions-creances-detail";
  static const transactionsFinancementExterne =
      "/transactions-financement-externe";
  static const transactionsFinancementExterneAdd =
      "/transactions-financement-externe-add";
  static const transactionsFinancementExterneDetail =
      "/transactions-financement-externe-detail";
  
  static const transactionsDepenses = "/transactions-depenses";
  static const finDD = "/fin-dd";
  static const finEtatBesoin = "/fin-etat-besoin";
}

class ComptabiliteRoutes {
  static const comptabiliteDashboard = "/comptabilite-dashboard";
  static const comptabiliteBilan = "/comptabilite-bilan";
  static const comptabiliteBilanAdd = "/comptabilite-bilan-add";
  static const comptabiliteBilanDetail = "/comptabilite-bilan-detail";
  static const comptabiliteJournal = "/comptabilite-journal";
  static const comptabiliteJournalDetail = "/comptabilite-journal-detail";
  static const comptabiliteJournalAdd = "/comptabilite-journal-add";
  static const comptabiliteCompteResultat = "/comptabilite-compte-resultat";
  static const comptabiliteCompteResultatAdd =
      "/comptabilite-compte-resultat-add";
  static const comptabiliteCompteResultatDetail =
      "/comptabilite-compte-resultat-detail";
  static const comptabiliteCompteResultatUpdate =
      "/comptabilite-compte-resultat-update";
  static const comptabiliteBalance = "/comptabilite-balance";
  static const comptabiliteBalanceAdd = "/comptabilite-balance-add";
  static const comptabiliteBalanceDetail = "/comptabilite-balance-detail";
  static const comptabiliteGrandLivre = "/comptabilite-grand-livre";
  static const comptabiliteGrandLivreSearch = "/comptabilite-grand-livre-search";
  static const comptabiliteDD = "/comptabilite-dd";
  static const comptabiliteEtatBesoin = "/comptabilite-etat-besoin";
}

class LogistiqueRoutes {
  static const logDashboard = "/log-dashboard";
  static const logAnguinAuto = "/log-anguin-auto";
  static const logAnguinAutoDetail = "/log-anguin-auto-detail";
  static const logAddAnguinAuto = "/log-add-anguin-auto";
  static const logAddCarburantAuto = "/log-add-carburant-auto";
  static const logCarburantAuto = "/log-carburant-auto";
  static const logCarburantAutoDetail = "/log-carburant-auto-detail";
  static const logAddTrajetAuto = "/log-add-trajet-auto";
  static const logTrajetAuto = "/log-trajet-auto";
  static const logTrajetAutoDetail = "/log-trajet-auto-detail";
  static const logTrajetAutoUpdate = "/log-trajet-auto-update";
  static const logAddEntretien = "/log-add-entretien";
  static const logEntretien = "/log-entretien";
  static const logEntretienDetail = "/log-entretien-detail";
  static const logAddEtatMateriel = "/log-add-etat-materiel";
  static const logEtatMateriel = "/log-etat-materiel";
  static const logEtatMaterielDetail = "/log-etat-materiel-detail";
  static const logAddImmobilerMateriel = "/log-add-immobilier-materiel";
  static const logImmobilierMateriel = "/log-immobilier-materiel";
  static const logImmobilierMaterielDetail = "/log-immobilier-materiel-detail";
  static const logAddMobilierMateriel = "/log-add-mobilier-materiel";
  static const logMobilierMateriel = "/log-mobilier-materiel";
  static const logMobilierMaterielDetail = "/log-mobilier-materiel-detail";
  static const logDD = "/log-dd";
  static const logEtatBesoin = "/log-etat-besoin";
}

class ExploitationRoutes {
  static const expDashboard = "/exploitation-dashboard";
  static const expProjetAdd = "/exploitation-projets-add";
  static const expProjet = "/exploitation-projets";
  static const expProjetUpdate = "/exploitation-projet-update";
  static const expProjetDetail = "/exploitation-projets-detail";
  static const expTacheAdd = "/exploitation-taches-add";
  static const expTache = "/exploitation-taches"; 
  static const expTacheDetail = "/exploitation-taches-detail"; 
  static const expVersement = "/exploitation-virement";
  static const expVersementAdd = "/exploitation-virement-add";
  static const expVersementDetail = "/exploitation-virement-detail";
  static const expDD = "/exp-dd";
  static const exploitationEtatBesoin = "/exploitation-etat-besoin";
}

class ComMarketingRoutes {
  static const comMarketingDD = "/com-marketing-dd";
  static const comMarketingDashboard = "/com-marketing-dashboard";
  // Marketing
  static const comMarketingAnnuaire = "/com-marketing-annuaire";
  static const comMarketingAnnuaireAdd = "/com-marketing-annuaire-add";
  static const comMarketingAnnuaireDetail = "/com-marketing-annuaire-detail";
  static const comMarketingAnnuaireEdit = "/com-marketing-annuaire-edit";
  static const comMarketingAgenda = "/com-marketing-agenda";
  static const comMarketingAgendaAdd = "/com-marketing-agenda-add";
  static const comMarketingAgendaDetail = "/com-marketing-agenda-detail";
  static const comMarketingAgendaUpdate = "/com-marketing-agenda-update";
  static const comMarketingCampaign = "/com-marketing-campaign";
  static const comMarketingCampaignAdd = "/com-marketing-campaign-add";
  static const comMarketingCampaignDetail = "/com-marketing-campaign-detail";
  static const comMarketingCampaignUpdate = "/com-marketing-campaign-update";
  
  // Commercial
  static const comMarketingProduitModel = "/com-marketing-produit-model";
  static const comMarketingProduitModelDetail = "/com-marketing-produit-model-detail";
  static const comMarketingProduitModelAdd = "/com-marketing-produit-model-add";
  static const comMarketingProduitModelUpdate = "/com-marketing-produit-model-update";
  static const comMarketingStockGlobal = "/com-marketing-stock-global";
  static const comMarketingStockGlobalAdd = "/com-marketing-stock-global-add";
  static const comMarketingSuccursale = "/com-marketing-succursale";
  static const comMarketingSuccursaleDetail = "/com-marketing-succursale-detail";
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
  static const comMarketingEtatBesoin = "/com-marketing-etat-besoin";
}

class ArchiveRoutes {
  static const archives = "/archives";
  static const archiveTable = "/archives-table";
  static const addArchives = "/archives-add";
  static const archivesDetail = "/archives-detail";
  static const archivePdf = "/archives-pdf";
}

class MailRoutes {
  static const mails = "/mails";
  static const addMail = "/mail-add";
  static const mailDetail = "/mail-detail";
  static const mailRepondre = "/mail-repondre";
  static const mailTransfert = "/mail-tranfert";
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
  RhRoutes.rhAgentPage: (context) => const DetailAgentPage(),
  RhRoutes.rhAgentAdd: (context) => const AddAgent(),
  RhRoutes.rhAgentUpdate: (context) => const UpdateAgent(),
  RhRoutes.rhPaiement: (context) => const PaiementRh(),
  RhRoutes.rhPaiementBulletin: (context) => const PaiementBulletin(),
  RhRoutes.rhPaiementAdd: (context) => const AddPaiementSalaire(),
  RhRoutes.rhPresence: (context) => const PresenceRh(),
  RhRoutes.rhPresenceDetail: (context) => const DetailPresence(),
  RhRoutes.rhPresenceEntrer: (context) => const EntrerPresence(),
  RhRoutes.rhPresenceSortie: (context) => const SortiePresence(),
  RhRoutes.rhPerformence: (context) => const PerformenceRH(),
  RhRoutes.rhPerformenceDetail: (context) => const DetailPerformence(),
  RhRoutes.rhPerformenceAddNote: (context) => const AddPerformenceNote(),
  RhRoutes.rhDD: (context) => const DepartementRH(),
  RhRoutes.rhHistoriqueSalaire: (context) => const TableSalairesHistorique(),
  RhRoutes.rhEtatBesoin: (context) => const EtatBesoinRHPage(),
  RhRoutes.rhTransportRest: (context) => const TransportRestaurationPage(),
  RhRoutes.rhTransportRestDetail: (context) => const DetailTransportRestaurant(),

  // Budgets
  BudgetRoutes.budgetDashboard: (context) => const DashboardBudget(),
  BudgetRoutes.budgetDD: (context) => const BudgetDD(),
  BudgetRoutes.budgetBudgetPrevisionel: (context) => const BudgetsPrevisionnels(),
  BudgetRoutes.budgetBudgetPrevisionelAdd: (context) => const AddBudgetPrevionel(),
  BudgetRoutes.budgetLignebudgetaireDetail: (context) =>
      const DetailLigneBudgetaire(),
  BudgetRoutes.budgetLignebudgetaireAdd: (context) =>
      const AjoutLigneBudgetaire(),
  BudgetRoutes.historiqueBudgetBudgetPrevisionel: (context) => const HistoriqueBudgetsPrevisionnels(),
  BudgetRoutes.budgetBudgetPrevisionelDetail: (context) =>
      const DetailDepartmentBudget(),
  BudgetRoutes.budgetEtatBesoin: (context) =>
      const EtatBesoinBudgetsPage(),

  // FInance
  FinanceRoutes.finDD: (context) => const DepartementFin(), 
  FinanceRoutes.financeDashboard: (context) => const DashboardFinance(),
  FinanceRoutes.transactionsBanque: (context) => const BanqueTransactions(),
  FinanceRoutes.transactionsBanqueDetail: (context) => const DetailBanque(),
  FinanceRoutes.transactionsBanqueDepot: (context) => const AddDepotBanque(),
  FinanceRoutes.transactionsBanqueRetrait: (context) => const AddRetratBanque(),
  FinanceRoutes.transactionsCaisse: (context) => const CaisseTransactions(),
  FinanceRoutes.transactionsCaisseDetail: (context) => const DetailCaisse(),
  FinanceRoutes.transactionsCaisseEncaissement: (context) => const AddEncaissement(),
  FinanceRoutes.transactionsCaisseDecaissement: (context) => const AddDecaissement(),
  FinanceRoutes.transactionsCreances: (context) => const CreanceTransactions(),
  FinanceRoutes.transactionsCreanceDetail: (context) => const DetailCreance(),
  FinanceRoutes.transactionsDettes: (context) => const DetteTransactions(),
  FinanceRoutes.transactionsDetteDetail: (context) => const DetailDette(),
  FinanceRoutes.transactionsFinancementExterne: (context) => const FinExterneTransactions(),
  FinanceRoutes.transactionsFinancementExterneAdd: (context) => const AddAutreFin(),
  FinanceRoutes.transactionsFinancementExterneDetail: (context) =>
      const DetailFinExterieur(),
  FinanceRoutes.finEtatBesoin: (context) =>
      const EtatBesoinFinPage(), 

  // Comptabilite
  ComptabiliteRoutes.comptabiliteDD: (context) => const ComptabiliteDD(),
  ComptabiliteRoutes.comptabiliteDashboard: (context) => const DashboardComptabilite(),
  ComptabiliteRoutes.comptabiliteBilan: (context) =>const BilanComptabilite(),
  ComptabiliteRoutes.comptabiliteBilanAdd: (context) => const AddCompteBilan(),
  ComptabiliteRoutes.comptabiliteBilanDetail: (context) => const DetailBilan(), 
  ComptabiliteRoutes.comptabiliteJournal: (context) => const JournalComptabilite(),
  ComptabiliteRoutes.comptabiliteJournalDetail: (context) =>
      const DetailJournal(),
  ComptabiliteRoutes.comptabiliteJournalAdd: (context) => const AddJournalComptabilite(),
  ComptabiliteRoutes.comptabiliteCompteResultat: (context) =>const CompteResultat(),
  ComptabiliteRoutes.comptabiliteCompteResultatDetail: (context) =>
      const DetailCompteResultat(),
    ComptabiliteRoutes.comptabiliteCompteResultatAdd: (context) =>
      const AddCompteResultat(),
  ComptabiliteRoutes.comptabiliteCompteResultatUpdate: (context) =>
      const UpdateCompteResultat(),

  ComptabiliteRoutes.comptabiliteBalance: (context) => const BalanceComptabilite(),
  ComptabiliteRoutes.comptabiliteBalanceAdd: (context) =>
      const AddCompteBalanceRef(),
  ComptabiliteRoutes.comptabiliteBalanceDetail: (context) =>
      const DetailBalance(), 
  ComptabiliteRoutes.comptabiliteGrandLivre: (context) => const GrandLivreComptabilite(),
  // ComptabiliteRoutes.comptabiliteGrandLivreSearch: (context) =>
  //     const TableGrandLivre(),
  ComptabiliteRoutes.comptabiliteEtatBesoin: (context) =>
      const EtatBesoinComptabilitePage(),

  // DEVIS
  DevisRoutes.devis: (context) => const DevisPage(),
  DevisRoutes.devisDetail: (context) => const DetailDevis(),

  // LOGISTIQUES
  LogistiqueRoutes.logDD: (context) => const LogDD(),
  LogistiqueRoutes.logDashboard: (context) => const DashboardLog(),
  LogistiqueRoutes.logAddAnguinAuto: (context) => const AddAnguinAuto(),
  LogistiqueRoutes.logAnguinAuto: (context) =>const AnguinAuto(),
  LogistiqueRoutes.logAnguinAutoDetail: (context) => const DetailAnguin(),
  LogistiqueRoutes.logAddCarburantAuto: (context) => const AddCarburantAuto(),
  LogistiqueRoutes.logCarburantAuto: (context) => const CarburantAuto(),
  LogistiqueRoutes.logCarburantAutoDetail: (context) => const DetailCaburant(),
  LogistiqueRoutes.logAddTrajetAuto: (context) => const AddTrajetAuto(),
  LogistiqueRoutes.logTrajetAuto: (context) => const TrajetAuto(),
  LogistiqueRoutes.logTrajetAutoDetail: (context) => const DetailTrajet(),
  LogistiqueRoutes.logTrajetAutoUpdate: (context) => const UpdateTrajet(),
  LogistiqueRoutes.logAddEntretien: (context) => const AddEntretienPage(),
  LogistiqueRoutes.logEntretien: (context) => const EntretienPage(),
  LogistiqueRoutes.logEntretienDetail: (context) => const DetailEntretien(),
  LogistiqueRoutes.logAddEtatMateriel: (context) => const AddEtatMateriel(),
  LogistiqueRoutes.logEtatMateriel: (context) => const EtatMateriel(),
  LogistiqueRoutes.logEtatMaterielDetail: (context) => const DetailEtatMateriel(),
  LogistiqueRoutes.logAddImmobilerMateriel: (context) => const AddImmobilierMateriel(),
  LogistiqueRoutes.logImmobilierMateriel: (context) =>const ImmobilierMateriel(),
  LogistiqueRoutes.logImmobilierMaterielDetail: (context) =>
      const DetailImmobilier(),
  LogistiqueRoutes.logAddMobilierMateriel: (context) =>const AddMobilerMateriel(),
  LogistiqueRoutes.logMobilierMateriel: (context) =>const MobilierMateriel(),
  LogistiqueRoutes.logMobilierMaterielDetail: (context) => const DetailMobilier(),
  LogistiqueRoutes.logEtatBesoin: (context) => const EtatBesoinLogPage(),

  // Exploitations
  ExploitationRoutes.expDD: (context) => const ExploitationDD(),
  ExploitationRoutes.expDashboard: (context) => const DashboardExp(),
  ExploitationRoutes.expProjetAdd: (context) => const AddProjetExp(),
  ExploitationRoutes.expProjet: (context) => const ProjetsExp(),
  ExploitationRoutes.expProjetUpdate: (context) => const UpdateProjet(),
  ExploitationRoutes.expProjetDetail: (context) => const DetailProjet(),
  ExploitationRoutes.expVersement: (context) => const VersementProjet(),
  ExploitationRoutes.expVersementDetail: (context) => const DetailVersementProjet(),
  ExploitationRoutes.expVersementAdd: (context) => const AddVersementProjet(),
  ExploitationRoutes.expTache: (context) => const TacheExp(),
  ExploitationRoutes.expTacheAdd: (context) => const AddTacheExp(),
  ExploitationRoutes.expTacheDetail: (context) => const DetailTache(),
  ExploitationRoutes.exploitationEtatBesoin: (context) => const EtatBesoinExploitationsPage(),

  // Marketing
  ComMarketingRoutes.comMarketingDD: (context) => const CMDD(),
  ComMarketingRoutes.comMarketingDashboard: (context) =>const ComMarketing(),
  ComMarketingRoutes.comMarketingAnnuaire: (context) =>const AnnuaireMarketing(),
  ComMarketingRoutes.comMarketingAnnuaireAdd: (context) => const AddAnnuaire(),
  ComMarketingRoutes.comMarketingAnnuaireDetail: (context) => const DetailAnnuaire(),
  ComMarketingRoutes.comMarketingAnnuaireEdit: (context) =>
      const UpdateAnnuaire(),
  ComMarketingRoutes.comMarketingAgenda: (context) => const AgendaMarketing(),
  ComMarketingRoutes.comMarketingAgendaAdd: (context) => const AddAgenda(),
  ComMarketingRoutes.comMarketingAgendaDetail: (context) => const DetailAgenda(),
  ComMarketingRoutes.comMarketingAgendaUpdate: (context) =>
      const UpdateAgenda(),
  ComMarketingRoutes.comMarketingCampaign: (context) =>const CampaignMarketing(),
  ComMarketingRoutes.comMarketingCampaignAdd: (context) =>const AddCampaign(),
  ComMarketingRoutes.comMarketingCampaignDetail: (context) => const DetailCampaign(),
  ComMarketingRoutes.comMarketingCampaignUpdate: (context) => const UpdateCampaign(),

  // Commercial
  ComMarketingRoutes.comMarketingProduitModel: (context) =>const ProduitModelPage(),
  ComMarketingRoutes.comMarketingProduitModelDetail: (context) =>
      const DetailProdModel(),
  ComMarketingRoutes.comMarketingProduitModelAdd: (context) =>const AddProModel(),
  ComMarketingRoutes.comMarketingProduitModelUpdate: (context) =>
      const UpdateProModel(),
  ComMarketingRoutes.comMarketingStockGlobal: (context) =>const StockGlobalPage(),
  ComMarketingRoutes.comMarketingStockGlobalAdd: (context) =>const AddStockGlobal(),
  ComMarketingRoutes.comMarketingSuccursale: (context) =>const SuccursalePage(),
  ComMarketingRoutes.comMarketingSuccursaleAdd: (context) =>const AddSurrsale(),
  ComMarketingRoutes.comMarketingSuccursaleDetail: (context) =>
      const DetailSuccursale(),
  ComMarketingRoutes.comMarketingAchat: (context) =>const AchatsPage(),
  ComMarketingRoutes.comMarketingBonLivraison: (context) =>const BonLivraisonPage(),
  ComMarketingRoutes.comMarketingRestitution: (context) =>const RestitutionPage(),
  ComMarketingRoutes.comMarketingFacture: (context) =>const FacturePage(),
  ComMarketingRoutes.comMarketingCreance: (context) =>const CreanceFactPage(),
  ComMarketingRoutes.comMarketingVente: (context) =>const VentesPage(),
  ComMarketingRoutes.comMarketingcart: (context) =>const CartPage(),
  ComMarketingRoutes.comMarketingHistoryRavitaillement: (context) =>const HistoryRavitaillement(),
  ComMarketingRoutes.comMarketingHistoryLivraison: (context) =>const HistoryLivraison(),
  ComMarketingRoutes.comMarketingEtatBesoin: (context) =>
      const EtatBesoinCMPage(),

  // Mails
  MailRoutes.mails: (context) => const MailPages(),
  MailRoutes.addMail: (context) => const NewMail(),
  MailRoutes.mailDetail: (context) => const DetailMail(),
  MailRoutes.mailRepondre: (context) => const RepondreMail(),
  MailRoutes.mailTransfert: (context) => const TransfertMail(),

  // Archives
  ArchiveRoutes.archives: (context) => const ArchiveFolder(),
  ArchiveRoutes.archiveTable: (context) => const TableArchive(),
  ArchiveRoutes.addArchives: (context) => const AddArchive(),
  ArchiveRoutes.archivesDetail: (context) => const DetailArchive(),
  ArchiveRoutes.archivePdf: (context) => const ArchivePdfViewer(),
};
