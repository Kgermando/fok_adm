import 'dart:convert';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AgentsApi {
  var client = http.Client();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    print('accessToken $accessToken');
    return accessToken;
  }

  Future<List<AgentModel>> getAllData() async {
    String? token = await getToken();
    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      listAgentsUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
     List<dynamic> bodyList = json.decode(resp.body);
      List<AgentModel> data = [];
      for (var u in bodyList) {
        data.add(AgentModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }


  Future<List<AgentModel>> getAllSearch(String query) async {
    String? token = await getToken();
    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      listAgentsUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);

      return bodyList.map((json) => AgentModel.fromJson(json)).where((data) {
        final nomLower = data.nom.toLowerCase();
        final postNomLower = data.postNom.toLowerCase();
        final matriculeLower = data.matricule.toLowerCase();
        final sexeLower = data.sexe.toLowerCase();
        final searchLower = query.toLowerCase();

        return nomLower.contains(searchLower) ||
            postNomLower.contains(searchLower) ||
            matriculeLower.contains(searchLower) ||
            sexeLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }


  Future<AgentModel> insertData(AgentModel agentModel) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    var data = agentModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(
      addAgentsUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (resp.statusCode == 200) {
      return AgentModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(agentModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<AgentModel> updateData(int id, AgentModel agentModel) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    var data = agentModel.toJson();
    var body = jsonEncode(data);
    var updateAgentsUrl = Uri.parse("$mainUrl/rh/agents/update-agent/$id");

    var res = await client.put(updateAgentsUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: body);
    if (res.statusCode == 200) {
      return AgentModel.fromJson(json.decode(res.body)['agents']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<AgentModel> deleteData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    var deleteAgentsUrl = Uri.parse("$mainUrl/rh/agents/delete-agent/$id");

    var res = await client.delete(deleteAgentsUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        });
    if (res.statusCode == 200) {
      return AgentModel.fromJson(json.decode(res.body)['agents']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}