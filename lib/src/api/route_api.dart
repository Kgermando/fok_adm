

const String mainUrl = "http://192.168.43.230/api";


var refreshTokenUrl = Uri.parse("$mainUrl/auth/reloadToken");
var loginUrl = Uri.parse("$mainUrl/auth/login");
var logoutUrl = Uri.parse("$mainUrl/auth/logout");

var registerUrl = Uri.parse("$mainUrl/user/insert-new-user");
var userAllUrl = Uri.parse("$mainUrl/user/users/");
var userUrl = Uri.parse("$mainUrl/user/");

// RH
// Agent
var listAgentsUrl = Uri.parse("$mainUrl/rh/agents/");
var addAgentsUrl = Uri.parse("$mainUrl/rh/agents/insert-new-agent");
var agentCountUrl = Uri.parse("$mainUrl/rh/agents/get-count/");

// Paiement salaire
var listPaiementSalaireUrl = Uri.parse("$mainUrl/rh/paiement-salaires/");
var addPaiementSalaireUrl = Uri.parse("$mainUrl/rh/paiement-salaires/insert-new-paiement");

// Finances
var banqueUrl = Uri.parse("$mainUrl/finances/transactions/banques/");
var addBanqueUrl = Uri.parse("$mainUrl/finances/transactions/banques/insert-new-transaction-banque");

var caisseUrl = Uri.parse("$mainUrl/finances/transactions/caisses/");
var addCaisseUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses/insert-new-transaction-caisse");

var creancesUrl = Uri.parse("$mainUrl/finances/transactions/creances/");
var addCreancesUrl = Uri.parse(
    "$mainUrl/finances/transactions/creances/insert-new-transaction-creance");

var depensesUrl = Uri.parse("$mainUrl/finances/transactions/depenses/");
var adddepensesUrl = Uri.parse(
    "$mainUrl/finances/transactions/depenses/insert-new-transaction-depense");

var dettesUrl = Uri.parse("$mainUrl/finances/transactions/dettes/");
var adddettesUrl = Uri.parse(
    "$mainUrl/finances/transactions/dettes/insert-new-transaction-dette");

var finExterieurUrl = Uri.parse("$mainUrl/finances/transactions/financements-exterieur/");
var addfinExterieurUrl = Uri.parse(
    "$mainUrl/finances/transactions/financements-exterieur/insert-new-transaction-finExterieur");


// Comptabilité
var amortissementsUrl =
    Uri.parse("$mainUrl/finances/comptabilite/amortissements/");
var addamortissementsUrl = Uri.parse(
    "$mainUrl/finances/comptabilite/amortissements/insert-new-transaction-amortissement");

var bilansUrl =
    Uri.parse("$mainUrl/finances/comptabilite/bilans/");
var addbilansUrl = Uri.parse(
    "$mainUrl/finances/comptabilite/bilans/insert-new-transaction-bilan");


var journalsUrl = Uri.parse("$mainUrl/finances/comptabilite/journals/");
var addjournalsUrl = Uri.parse(
    "$mainUrl/finances/comptabilite/journals/insert-new-transaction-journal");


var valorisationsUrl = Uri.parse("$mainUrl/finances/comptabilite/valorisations/");
var addvalorisationsUrl = Uri.parse(
    "$mainUrl/finances/comptabilite/valorisations/insert-new-transaction-valorisation");
