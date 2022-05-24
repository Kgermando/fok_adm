// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/rh/agent_count_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:http/http.dart' as http; 

class AgentsApi {
  var client = http.Client();
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    var data = await storage.read(key: "accessToken");
    return data;
  }


  Future<AgentCountModel> getCount() async {
    String? token = await getToken();
    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      agentCountUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      return AgentCountModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return getCount();
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<AgentModel>> getAllData() async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));

      // print("payload $payload");
      // print("payload token $token");
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

  Future<AgentModel> getOneData(int id) async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/rh/agents/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return AgentModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }


  Future<List<AgentPieChartModel>> getChartPieSexe() async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      agentChartPieSexeUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<AgentPieChartModel> data = [];
      for (var row in bodyList) {
        data.add(AgentPieChartModel.fromJson(row));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }


  Future<AgentModel> insertData(AgentModel agentModel) async {
    final accessToken = await storage.read(key: 'accessToken');
    var data = agentModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addAgentsUrl,
        headers: <String, String> {
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
    final accessToken = await storage.read(key: 'accessToken');

    var data = agentModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/rh/agents/update-agent/$id");

    var res = await client.put(
      updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (res.statusCode == 200) {
      return AgentModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<AgentModel> deleteData(int id) async {
    final accessToken = await storage.read(key: 'accessToken');

    var deleteUrl = Uri.parse("$mainUrl/rh/agents/delete-agent/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
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
