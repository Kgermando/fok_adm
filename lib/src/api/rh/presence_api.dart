// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';
import 'package:http/http.dart' as http;

class PresenceApi {
  var client = http.Client();
  // final storage = const FlutterSecureStorage();

  // Future<String?> getToken() async {
  //   final data = await storage.read(key: "accessToken");
  //   return data;
  // }

  Future<List<PresenceModel>> getAllData() async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));

      // print("payload $payload");
      // print("payload token $token");
    }
    var resp = await client.get(
      listPresenceUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<PresenceModel> data = [];
      for (var u in bodyList) {
        data.add(PresenceModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<PresenceModel> getOneData(int id) async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/rh/presences/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return PresenceModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<PresenceModel> insertData(PresenceModel presenceModel) async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    var data = presenceModel.toJson();
    var body = jsonEncode(data);

    var res = await client.post(addPresenceUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (res.statusCode == 200) {
      return PresenceModel.fromJson(json.decode(res.body));
    } else if (res.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(presenceModel);
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<PresenceModel> updateData(PresenceModel presenceModel) async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    var data = presenceModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/rh/presences/update-presence/");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (res.statusCode == 200) {
      return PresenceModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    var deleteUrl = Uri.parse("$mainUrl/rh/presences/delete-presence/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    if (res.statusCode == 200) { 
    } else {
      throw Exception(res.statusCode);
    }
  }
}
