// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/approbation/approbation_model.dart';
import 'package:http/http.dart' as http;

class ApprobationApi {
  var client = http.Client();
  // final storage = const FlutterSecureStorage();

  // Future<String?> getToken() async {
  //   final data = await storage.read(key: "accessToken");
  //   return data;
  // }

  Future<List<ApprobationModel>> getAllData() async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      approbationsUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ApprobationModel> data = [];
      for (var u in bodyList) {
        data.add(ApprobationModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<ApprobationModel> getOneData(int id) async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/approbations/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return ApprobationModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ApprobationModel> insertData(ApprobationModel devisModel) async {
    // String? token = await UserSharedPref().getAccessToken();
    final token = await UserSharedPref().getAccessToken();

    var data = devisModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addapprobationsUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (resp.statusCode == 200) {
      return ApprobationModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(devisModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ApprobationModel> updateData(
      ApprobationModel devisModel) async {
    // String? token = await UserSharedPref().getAccessToken();
    final token = await UserSharedPref().getAccessToken();

    var data = devisModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/devis/update-approbation/");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (res.statusCode == 200) {
      return ApprobationModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    // String? token = await UserSharedPref().getAccessToken();
    final token = await UserSharedPref().getAccessToken();

    var deleteUrl = Uri.parse("$mainUrl/devis/delete-approbation/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    if (res.statusCode == 200) {
      // return DevisModel.fromJson(json.decode(res.body)['data']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
