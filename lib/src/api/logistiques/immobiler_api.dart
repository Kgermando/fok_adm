// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/logistiques/immobilier_model.dart';
import 'package:http/http.dart' as http;

class ImmobilierApi {
  var client = http.Client();
  // final storage = const FlutterSecureStorage();

  // Future<String?> getToken() async {
  //   final data = await storage.read(key: "accessToken");
  //   return data;
  // }

  Future<List<ImmobilierModel>> getAllData() async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));

      // print("payload $payload");
      // print("payload token $token");
    }
    var resp = await client.get(
      immobiliersUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ImmobilierModel> data = [];
      for (var u in bodyList) {
        data.add(ImmobilierModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<ImmobilierModel> getOneData(int id) async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/immobiliers/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return ImmobilierModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ImmobilierModel> insertData(ImmobilierModel anguinModel) async {
    String? token = await UserSharedPref().getAccessToken();

    var data = anguinModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addImmobiliersUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (resp.statusCode == 200) {
      return ImmobilierModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(anguinModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ImmobilierModel> updateData(
    ImmobilierModel anguinModel) async {
    String? token = await UserSharedPref().getAccessToken();

    var data = anguinModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/immobiliers/update-immobilier/");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (res.statusCode == 200) {
      return ImmobilierModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<ImmobilierModel> deleteData(int id) async {
    String? token = await UserSharedPref().getAccessToken();

    var deleteUrl = Uri.parse("$mainUrl/immobiliers/delete-immobilier/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    if (res.statusCode == 200) {
      return ImmobilierModel.fromJson(json.decode(res.body)['data']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
