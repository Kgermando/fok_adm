

// const String mainUrl = "http://localhost/api";
// const String mainUrl = "http://192.168.43.96/api";
const String mainUrl = "http://161.35.239.245/api";


var refreshTokenUrl = Uri.parse("$mainUrl/auth/reloadToken");
var loginUrl = Uri.parse("$mainUrl/auth/login");
var logoutUrl = Uri.parse("$mainUrl/auth/logout");

var registerUrl = Uri.parse("$mainUrl/user/insert-new-user");
var userAllUrl = Uri.parse("$mainUrl/user/users/");
var userUrl = Uri.parse("$mainUrl/user/");


// RH
var listAgentsUrl = Uri.parse("$mainUrl/rh/agents/");
var addAgentsUrl = Uri.parse("$mainUrl/rh/agents/insert-new-agent");
var agentCountUrl = Uri.parse("$mainUrl/rh/agents/get-count/");
var agentChartPieSexeUrl = Uri.parse("$mainUrl/rh/agents/chart-pie-sexe/");

var listPaiementSalaireUrl = Uri.parse("$mainUrl/rh/paiement-salaires/");
var addPaiementSalaireUrl = Uri.parse("$mainUrl/rh/paiement-salaires/insert-new-paiement");

var listPresenceUrl = Uri.parse("$mainUrl/rh/presences/");
var addPresenceUrl =
    Uri.parse("$mainUrl/rh/presences/insert-new-presence");

var listPerformenceUrl = Uri.parse("$mainUrl/rh/performences/");
var addPerformenceUrl =
    Uri.parse("$mainUrl/rh/performences/insert-new-performence");
var listPerformenceNoteUrl = Uri.parse("$mainUrl/rh/performences-note/");
var addPerformenceNoteUrl =
    Uri.parse("$mainUrl/rh/performences-note/insert-new-performence-note");


// Finances
var banqueUrl = Uri.parse("$mainUrl/finances/transactions/banques/");
var addBanqueUrl = Uri.parse("$mainUrl/finances/transactions/banques/insert-new-transaction-banque");
var banqueDepotMouthUrl = Uri.parse("$mainUrl/finances/transactions/banques/chart-month-depot/");
var banqueRetraitMountUrl = Uri.parse("$mainUrl/finances/transactions/banques/chart-month-retrait/");
var banqueDepotYearUrl = Uri.parse("$mainUrl/finances/transactions/banques/chart-year-depot/");
var banqueRetraitYeartUrl = Uri.parse("$mainUrl/finances/transactions/banques/chart-year-retrait/");

var caisseUrl = Uri.parse("$mainUrl/finances/transactions/caisses/");
var addCaisseUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses/insert-new-transaction-caisse");
var caisseEncaissementMouthUrl = Uri.parse("$mainUrl/finances/transactions/caisses/chart-month-encaissement/");
var caisseDecaissementMouthUrl = Uri.parse("$mainUrl/finances/transactions/caisses/chart-month-decaissement/");
var caisseEncaissementYearUrl = Uri.parse("$mainUrl/finances/transactions/caisses/chart-year-encaissement/");
var caisseDecaissementYearUrl = Uri.parse("$mainUrl/finances/transactions/caisses/chart-year-decaissement/");

var creancesUrl = Uri.parse("$mainUrl/finances/transactions/creances/");
var addCreancesUrl = Uri.parse(
    "$mainUrl/finances/transactions/creances/insert-new-transaction-creance");

var dettesUrl = Uri.parse("$mainUrl/finances/transactions/dettes/");
var adddettesUrl = Uri.parse(
    "$mainUrl/finances/transactions/dettes/insert-new-transaction-dette");

var finExterieurUrl = Uri.parse("$mainUrl/finances/transactions/financements-exterieur/");
var addfinExterieurUrl = Uri.parse(
    "$mainUrl/finances/transactions/financements-exterieur/insert-new-transaction-finExterieur");

  
var creacneDetteUrl = Uri.parse("$mainUrl/finances/creance-dettes/");
var creacneDetteAddUrl = Uri.parse("$mainUrl/finances/creance-dettes/insert-new-creance-dette");


// Comptabilité
var bilansUrl = Uri.parse("$mainUrl/comptabilite/bilans/");
var addbilansUrl = Uri.parse("$mainUrl/comptabilite/bilans/insert-new-bilan");

var journalsUrl = Uri.parse("$mainUrl/comptabilite/journals/");
var addjournalsUrl = Uri.parse( "$mainUrl/comptabilite/journals/insert-new-journal");
var journalsChartMounthUrl = Uri.parse("$mainUrl/comptabilite/journals/journal-chart-month/");
var journalsChartYearUrl = Uri.parse("$mainUrl/comptabilite/journals/journal-chart-year/");

var comptesResultatUrl = Uri.parse("$mainUrl/comptabilite/comptes_resultat/");
var addComptesResultatUrl = Uri.parse(
    "$mainUrl/comptabilite/comptes_resultat/insert-new-compte-resultat");

var balanceComptessUrl = Uri.parse("$mainUrl/comptabilite/balance_comptes/");
var addBalanceComptesUrl =
    Uri.parse("$mainUrl/comptabilite/balance_comptes/insert-new-balance-compte");


// DEVIS
var devisUrl = Uri.parse("$mainUrl/devis/");
var addDevissUrl = Uri.parse("$mainUrl/devis/insert-new-devis");
var devisPieDepMounthUrl = Uri.parse("$mainUrl/devis/chart-pie-dep-mounth/");
var devisPieDepYearUrl = Uri.parse("$mainUrl/devis/chart-pie-dep-year/");

var devisListObjetUrl = Uri.parse("$mainUrl/devis-list-objets/");
var adddevisListObjetUrl = Uri.parse("$mainUrl/devis-list-objets/insert-new-devis-list-objet");

// Budget
var budgetDepartementsUrl = Uri.parse("$mainUrl/budgets/departements/");
var addBudgetDepartementsUrl = Uri.parse("$mainUrl/budgets/departements/insert-new-departement-budget");

var ligneBudgetairesUrl = Uri.parse("$mainUrl/budgets/ligne-budgetaires/");
var addbudgetLigneBudgetairesUrl = Uri.parse("$mainUrl/budgets/ligne-budgetaires/insert-new-ligne-budgetaire");

// Logistiques
var anguinsUrl = Uri.parse("$mainUrl/anguins/");
var aaddAnguinsUrl = Uri.parse("$mainUrl/anguins/insert-new-anguin");
var anguinsChartPieUrl = Uri.parse("$mainUrl/anguins/chart-pie-genre/");

var carburantsUrl = Uri.parse("$mainUrl/carburants/");
var addCarburantsUrl = Uri.parse("$mainUrl/carburants/insert-new-carburant");

var entretiensUrl = Uri.parse("$mainUrl/entretiens/");
var addEntretiensUrl = Uri.parse("$mainUrl/entretiens/insert-new-entretien");

var etatMaterielUrl = Uri.parse("$mainUrl/etat_materiels/");
var addEtatMaterielUrl = Uri.parse("$mainUrl/etat_materiels/insert-new-etat-materiel");
var etatMaterieChartPielUrl = Uri.parse("$mainUrl/etat_materiels/chart-pie-statut/");

var immobiliersUrl = Uri.parse("$mainUrl/immobiliers/");
var addImmobiliersUrl = Uri.parse("$mainUrl/immobiliers/insert-new-immobilier");

var mobiliersUrl = Uri.parse("$mainUrl/mobiliers/");
var addMobiliersUrl = Uri.parse("$mainUrl/mobiliers/insert-new-mobilier");

var trajetsUrl = Uri.parse("$mainUrl/trajets/");
var addTrajetssUrl = Uri.parse("$mainUrl/trajets/insert-new-trajet");



// Exploitations
var projetsUrl = Uri.parse("$mainUrl/projets/");
var addProjetssUrl = Uri.parse("$mainUrl/projets/insert-new-projet");

var tachesUrl = Uri.parse("$mainUrl/taches/");
var addTachessUrl = Uri.parse("$mainUrl/taches/insert-new-tache");

var versementProjetsUrl = Uri.parse("$mainUrl/versements-projets/");
var addVersementProjetsUrl = Uri.parse("$mainUrl/versements-projets/insert-new-versement-projet");

var rapporsUrl = Uri.parse("$mainUrl/rapports/");
var addRapportsUrl = Uri.parse("$mainUrl/rapports/insert-new-rapport");



// COMMERCIAL
var prodModelsUrl = Uri.parse("$mainUrl/produit-models/");
var addProdModelsUrl = Uri.parse("$mainUrl/produit-models/insert-new-produit-model");

var stockGlobalUrl = Uri.parse("$mainUrl/stocks-global/");
var addStockGlobalUrl = Uri.parse("$mainUrl/stocks-global/insert-new-stocks-global");

var succursalesUrl = Uri.parse("$mainUrl/succursales/");
var addSuccursalesUrl =
    Uri.parse("$mainUrl/succursales/insert-new-succursale");

var bonLivraisonsUrl = Uri.parse("$mainUrl/bon-livraisons/");
var addBonLivraisonsUrl = Uri.parse("$mainUrl/bon-livraisons/insert-new-bon-livraison");

var achatsUrl = Uri.parse("$mainUrl/achats/");
var addAchatsUrl = Uri.parse("$mainUrl/achats/insert-new-achat");

// var cartsUrl = Uri.parse("$mainUrl/carts/");
var addCartsUrl = Uri.parse("$mainUrl/carts/insert-new-cart");

var facturesUrl = Uri.parse("$mainUrl/factures/");
var addFacturesUrl = Uri.parse("$mainUrl/factures/insert-new-facture");

var factureCreancesUrl = Uri.parse("$mainUrl/facture-creances/");
var addFactureCreancesUrl = Uri.parse("$mainUrl/facture-creances/insert-new-facture-creance");

var ventesUrl = Uri.parse("$mainUrl/ventes/");
var addVentesUrl = Uri.parse("$mainUrl/ventes/insert-new-vente");

// Chart Commercial
var venteChartsUrl = Uri.parse("$mainUrl/ventes/vente-chart/");
var venteChartMonthsUrl = Uri.parse("$mainUrl/ventes/vente-chart-month/");
var venteChartYearsUrl = Uri.parse("$mainUrl/ventes/vente-chart-year/");
var gainChartMonthsUrl = Uri.parse("$mainUrl/gains/gain-chart-month/");
var gainChartYearsUrl = Uri.parse("$mainUrl/gains/gain-chart-year/");

var gainsUrl = Uri.parse("$mainUrl/gains/");
var addGainsUrl = Uri.parse("$mainUrl/gains/insert-new-gain");

var restitutionsUrl = Uri.parse("$mainUrl/restitutions/");
var addRestitutionsUrl = Uri.parse("$mainUrl/restitutions/insert-new-restitution");

var numberFactsUrl = Uri.parse("$mainUrl/number-facts/");
var addNumberFactsUrl =
    Uri.parse("$mainUrl/number-facts/insert-new-number-fact");

var historyRavitaillementsUrl = Uri.parse("$mainUrl/history-ravitaillements/");
var addHistoryRavitaillementsUrl =
    Uri.parse("$mainUrl/history-ravitaillements/insert-new-history-ravitaillement");

var historyLivraisonUrl = Uri.parse("$mainUrl/history-livraisons/");
var addHistoryLivraisonUrl =
    Uri.parse("$mainUrl/history-livraisons/insert-new-history_livraison");

// Marketing
var agendasUrl = Uri.parse("$mainUrl/agendas/");
var addAgendasUrl = Uri.parse("$mainUrl/agendas/insert-new-agenda");

var annuairesUrl = Uri.parse("$mainUrl/annuaires/");
var addAnnuairesUrl = Uri.parse("$mainUrl/annuaires/insert-new-annuaire");

var campaignsUrl = Uri.parse("$mainUrl/campaigns/");
var addCampaignsUrl = Uri.parse("$mainUrl/campaigns/insert-new-campaign");

// ARCHIVES
var archvesUrl = Uri.parse("$mainUrl/archves/");
var addArchvesUrl = Uri.parse("$mainUrl/archves/insert-new-archve");

// MAILS
var mailsUrl = Uri.parse("$mainUrl/mails/");
var addMailUrl = Uri.parse("$mainUrl/mails/insert-new-mail");

// Approbation
var approbationsUrl = Uri.parse("$mainUrl/approbations/");
var addapprobationsUrl = Uri.parse("$mainUrl/approbations/insert-new-approbation");
