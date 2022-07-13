// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/administrations/actionnaire_cotisation_model.dart'; 
import 'package:http/http.dart' as http;

class ActionnaireCotisationApi {
  var client = http.Client(); 

  Future<List<ActionnaireCotisationModel>> getAllData() async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var res = await client.get(
      actionnaireCotisationListUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 200) {
      List<dynamic> bodyList = json.decode(res.body);
      List<ActionnaireCotisationModel> data = [];
      for (var u in bodyList) {
        data.add(ActionnaireCotisationModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<ActionnaireCotisationModel> getOneData(int id) async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/admin/actionnaire-cotisations/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return ActionnaireCotisationModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ActionnaireCotisationModel> insertData(
      ActionnaireCotisationModel actionnaireCotisationModel) async {
    String? token = await UserSharedPref().getAccessToken();

    var data = actionnaireCotisationModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(actionnaireCotisationAddUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (resp.statusCode == 200) {
      return ActionnaireCotisationModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(actionnaireCotisationModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ActionnaireCotisationModel> updateData(
      ActionnaireCotisationModel actionnaireCotisationModel) async {
    String? token = await UserSharedPref().getAccessToken();

    var data = actionnaireCotisationModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/admin/actionnaire-cotisations/update-actionnaire-cotisation/");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (res.statusCode == 200) {
      return ActionnaireCotisationModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    String? token = await UserSharedPref().getAccessToken();

    var deleteUrl =
        Uri.parse("$mainUrl/admin/actionnaire-cotisations/delete-actionnaire-cotisation/$id");

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
