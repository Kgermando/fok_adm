

const String mainUrl = "http://192.168.43.230/api";


var refreshTokenUrl = Uri.parse("$mainUrl/auth/reloadToken");
var loginUrl = Uri.parse("$mainUrl/auth/login");
var logoutUrl = Uri.parse("$mainUrl/auth/logout");
var registerUrl = Uri.parse("$mainUrl/user/insert-new-user");
var userUrl = Uri.parse("$mainUrl/user/");

// RH
var listAgentsUrl = Uri.parse("$mainUrl/rh/agents/");
var addAgentsUrl = Uri.parse("$mainUrl/rh/agents/insert-new-agent");
