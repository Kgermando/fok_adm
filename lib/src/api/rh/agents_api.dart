import 'dart:convert';
import 'dart:io';

import 'package:fokad_admin/src/api/route_api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/api/auth/api_error.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';

class AgentsApi extends ChangeNotifier {
  var client = http.Client();
  final storage = const FlutterSecureStorage();

  UserModel? user;

  Future<List<UserModel?>> getAllData() async {
    var accessToken = await storage.read(key: 'accessToken');
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      "Content-Security-Policy": "default-src self",
      "X-Frame-Options": "deny"
    };
    final resp = await client.get(listAgentsUrl, headers: headers);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body)["users"];
      List<UserModel> data = [];
      for (var u in bodyList) {
        data.add(UserModel.fromJson(u));
      }
      return data;
    } else {
      throw ApiError.fromJson(json.decode(resp.body));
    }
  }

  Future<void> insertData(UserModel userModel) async {
    var data = userModel.toMap();
    var body = jsonEncode(data);
    var accessToken = await storage.read(key: 'accessToken');
    var headers = {HttpHeaders.authorizationHeader: "Bearer $accessToken"};

    var resp = await client.post(loginUrl, body: body, headers: headers);
    if (resp.statusCode == 200) {
    } else {
      throw ApiError.fromJson(json.decode(resp.body));
    }
  }

  Future<UserModel> updateData(int id, UserModel userModel) async {
    var accessToken = await storage.read(key: 'accessToken');
    var headers = {HttpHeaders.authorizationHeader: "Bearer $accessToken"};
    var updateAgentsUrl = Uri.parse("$mainUrl/rh/agents/update-agent/$id");
    final resp = await client.put(updateAgentsUrl,
        body: jsonEncode(userModel.toMap()), headers: headers);

    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw ApiError.fromJson(json.decode(resp.body));
    }
  }

  Future<void> deleteData(int id) async {
    var deleteAgentsUrl = Uri.parse("$mainUrl/rh/agents/delete-agent/$id");
    var accessToken = await storage.read(key: 'accessToken');
    var headers = {HttpHeaders.authorizationHeader: "Bearer $accessToken"};

    final resp = await client.delete(deleteAgentsUrl, headers: headers);

    if (resp.statusCode == 200) {
      // AchatModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 204) {
      // AchatModel.fromJson(json.decode(resp.body));
    } else {
      throw ApiError.fromJson(json.decode(resp.body));
    }
  }

  Future<List<UserModel>> getAllSearch(String query) async {
    var accessToken = await storage.read(key: 'accessToken');
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    };
    final resp = await client.get(listAgentsUrl, headers: headers);

    if (resp.statusCode == 200) {
      final List datalist = json.decode(resp.body);

      return datalist.map((json) => UserModel.fromJson(json)).where((data) {
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
      throw Exception();
    }
  }
}
