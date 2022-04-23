// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/rh/perfomence_model.dart';
import 'package:http/http.dart' as http; 

class PerformenceApi {
   var client = http.Client();
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    final data = await storage.read(key: "accessToken");
    return data;
  }

  Future<List<PerformenceModel>> getAllData() async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      listPerformenceUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<PerformenceModel> data = [];
      for (var u in bodyList) {
        data.add(PerformenceModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<PerformenceModel> getOneData(int id) async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/rh/performences/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return PerformenceModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<PerformenceModel> insertData(
      PerformenceModel performenceModel) async {
    final accessToken = await storage.read(key: 'accessToken');

    var data = performenceModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addPerformenceUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (resp.statusCode == 200) {
      return PerformenceModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(performenceModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<PerformenceModel> updateData(int id, PerformenceModel performenceModel) async {
    final accessToken = await storage.read(key: 'accessToken');

    var data = performenceModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/rh/performences/update-performence/$id");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (res.statusCode == 200) {
      return PerformenceModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }


  Future<PerformenceModel> deleteData(int id) async {
    final accessToken = await storage.read(key: 'accessToken');

    var deleteUrl = Uri.parse("$mainUrl/rh/performences/delete-performence/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    });
    if (res.statusCode == 200) {
      return PerformenceModel.fromJson(json.decode(res.body)['agents']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

}