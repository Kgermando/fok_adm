// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:http/http.dart' as http;

class PaiementSalaireApi {
  var client = http.Client();
  // final storage = const FlutterSecureStorage();

  // Future<String?> getToken() async {
  //   final data = await storage.read(key: "accessToken");
  //   return data;
  // }

  Future<List<PaiementSalaireModel>> getAllData() async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      listPaiementSalaireUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<PaiementSalaireModel> data = [];
      for (var u in bodyList) {
        data.add(PaiementSalaireModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<PaiementSalaireModel> getOneData(int id) async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/rh/paiement-salaires/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return PaiementSalaireModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<PaiementSalaireModel> insertData(
      PaiementSalaireModel paiementSalaireModel) async {
    String? token = await UserSharedPref().getAccessToken();

    var data = paiementSalaireModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addPaiementSalaireUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (resp.statusCode == 200) {
      return PaiementSalaireModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(paiementSalaireModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<PaiementSalaireModel> updateData(PaiementSalaireModel paiementSalaireModel) async {
    String? token = await UserSharedPref().getAccessToken();

    var data = paiementSalaireModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/rh/paiement-salaires/update-paiement/");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (res.statusCode == 200) {
      return PaiementSalaireModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<PaiementSalaireModel> deleteData(int id) async {
    String? token = await UserSharedPref().getAccessToken();

    var deleteUrl =
        Uri.parse("$mainUrl/rh/paiement-salaires/delete-paiement/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    if (res.statusCode == 200) {
      return PaiementSalaireModel.fromJson(json.decode(res.body)['agents']);
    } else {
      throw Exception(res.statusCode);
    }
  }
}
