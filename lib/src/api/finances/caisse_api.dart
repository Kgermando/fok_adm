// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/finances/caisse_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CaisseApi {
  var client = http.Client();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    return accessToken;
  }

  Future<List<CaisseModel>> getAllData() async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      caisseUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CaisseModel> data = [];
      for (var u in bodyList) {
        data.add(CaisseModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<CaisseModel> getOneData(int id) async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/finances/transactions/caisses/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return CaisseModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CaisseModel> insertData(CaisseModel caisseModel) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    var data = caisseModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addCaisseUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (resp.statusCode == 200) {
      return CaisseModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(caisseModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CaisseModel> updateData(int id, CaisseModel caisseModel) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    var data = caisseModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/finances/transactions/caisses/update-transaction-caisse/$id");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (res.statusCode == 200) {
      return CaisseModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<CaisseModel> deleteData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    var deleteUrl = Uri.parse(
        "$mainUrl/finances/transactions/caisses/delete-transaction-caisse/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    });
    if (res.statusCode == 200) {
      return CaisseModel.fromJson(json.decode(res.body)['agents']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

}