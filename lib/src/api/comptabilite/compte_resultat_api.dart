// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_resultat_model.dart';
import 'package:http/http.dart' as http;


class CompteResultatApi {
  var client = http.Client();
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    final data = await storage.read(key: "accessToken");
    return data;
  }

  Future<List<CompteResulatsModel>> getAllData() async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      comptesResultatUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CompteResulatsModel> data = [];
      for (var u in bodyList) {
        data.add(CompteResulatsModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<CompteResulatsModel> getOneData(int id) async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/comptabilite/comptes_resultat/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return CompteResulatsModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CompteResulatsModel> insertData(CompteResulatsModel compteResulatsModel) async {
    final accessToken = await storage.read(key: 'accessToken');

    var data = compteResulatsModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addComptesResultatUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (resp.statusCode == 200) {
      return CompteResulatsModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(compteResulatsModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CompteResulatsModel> updateData(int id, CompteResulatsModel compteResulatsModel) async {
    final accessToken = await storage.read(key: 'accessToken');

    var data = compteResulatsModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/comptabilite/comptes_resultat/update-compte-resultat/$id");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (res.statusCode == 200) {
      return CompteResulatsModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<CompteResulatsModel> deleteData(int id) async {
    final accessToken = await storage.read(key: 'accessToken');

    var deleteUrl = Uri.parse(
        "$mainUrl/comptabilite/comptes_resultat/delete-compte-resultat/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    });
    if (res.statusCode == 200) {
      return CompteResulatsModel.fromJson(json.decode(res.body)['data']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}