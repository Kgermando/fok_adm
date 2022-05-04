// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart';
import 'package:http/http.dart' as http;

class AnnuaireApi {
   var client = http.Client();
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    final data = await storage.read(key: "accessToken");
    return data;
  }

  Future<List<AnnuaireModel>> getAllData() async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      annuairesUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<AnnuaireModel> data = [];
      for (var u in bodyList) {
        data.add(AnnuaireModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<AnnuaireModel>> getAllDataSearch(String query) async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      annuairesUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<AnnuaireModel> data = [];
      for (var u in bodyList) {
        data.add(AnnuaireModel.fromJson(u));
      }
      return data.toList().where((value) {
        final categorieLower = value.categorie.toLowerCase();
        final nomPostnomPrenomLower = value.nomPostnomPrenom.toLowerCase();
        final mobile1Lower = value.mobile1.toLowerCase();
        final mobile2Lower = value.mobile2.toLowerCase();
        final secteurActiviteLower = value.secteurActivite.toLowerCase();
        final searchLower = query.toLowerCase();
        return categorieLower.contains(searchLower) ||
            nomPostnomPrenomLower.contains(searchLower) ||
            mobile1Lower.contains(searchLower) ||
            mobile2Lower.contains(searchLower) ||
            secteurActiviteLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<AnnuaireModel> getOneData(int id) async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/annuaires/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return AnnuaireModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<AnnuaireModel> insertData(AnnuaireModel annuaireModel) async {
    final accessToken = await storage.read(key: 'accessToken');

    var data = annuaireModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addAnnuairesUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (resp.statusCode == 200) {
      return AnnuaireModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(annuaireModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<AnnuaireModel> updateData(int id, AnnuaireModel annuaireModel) async {
    final accessToken = await storage.read(key: 'accessToken');

    var data = annuaireModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/annuaires/update-annuaire/$id");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (res.statusCode == 200) {
      return AnnuaireModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<AnnuaireModel> deleteData(int id) async {
    final accessToken = await storage.read(key: 'accessToken');

    var deleteUrl = Uri.parse("$mainUrl/annuaires/delete-annuaire/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    });
    if (res.statusCode == 200) {
      return AnnuaireModel.fromJson(json.decode(res.body)['data']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}