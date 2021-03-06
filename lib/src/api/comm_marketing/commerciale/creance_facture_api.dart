// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/creance_cart_model.dart';
import 'package:http/http.dart' as http;

class CreanceFactureApi {
  var client = http.Client();
  // final storage = const FlutterSecureStorage();

  // Future<String?> getToken() async {
  //   final data = await storage.read(key: "accessToken");
  //   return data;
  // }

  Future<List<CreanceCartModel>> getAllData() async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      factureCreancesUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CreanceCartModel> data = [];
      for (var u in bodyList) {
        data.add(CreanceCartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<CreanceCartModel> getOneData(int id) async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/facture-creances/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return CreanceCartModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CreanceCartModel> insertData(CreanceCartModel creanceCartModel) async {
    String? token = await UserSharedPref().getAccessToken();

    var data = creanceCartModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addFactureCreancesUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (resp.statusCode == 200) {
      return CreanceCartModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(creanceCartModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CreanceCartModel> updateData(
      CreanceCartModel creanceCartModel) async {
    String? token = await UserSharedPref().getAccessToken();

    var data = creanceCartModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/facture-creances/update-facture-creance/");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (res.statusCode == 200) {
      return CreanceCartModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    String? token = await UserSharedPref().getAccessToken();

    var deleteUrl =
        Uri.parse("$mainUrl/facture-creances/delete-facture-creance/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    if (res.statusCode == 200) { 
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
