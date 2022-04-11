// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class JournalApi {
  var client = http.Client();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    // print('accessToken $accessToken');
    return accessToken;
  }

  Future<List<JournalModel>> getAllData() async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      amortissementsUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<JournalModel> data = [];
      for (var u in bodyList) {
        data.add(JournalModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<JournalModel> getOneData(int id) async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/finances/comptabilite/journals/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return JournalModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<JournalModel> insertData(
      JournalModel journalModel) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    var data = journalModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addjournalsUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (resp.statusCode == 200) {
      return JournalModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(journalModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<JournalModel> updateData(
      int id, JournalModel journalModel) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    var data = journalModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/finances/comptabilite/journals/update-comptabilite-journal/$id");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (res.statusCode == 200) {
      return JournalModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<JournalModel> deleteData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    var deleteUrl = Uri.parse(
        "$mainUrl/finances/comptabilite/journals/delete-comptabilite-journal/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    });
    if (res.statusCode == 200) {
      return JournalModel.fromJson(json.decode(res.body)['agents']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}