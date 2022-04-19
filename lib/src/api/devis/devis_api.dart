// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:http/http.dart' as http;


class DevisAPi {
   var client = http.Client();
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    final data = await storage.read(key: "accessToken");
    return data;
  }


  Future<List<DevisModel>> getAllData() async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      devisUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<DevisModel> data = [];
      for (var u in bodyList) {
        data.add(DevisModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<DevisModel> getOneData(int id) async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/devis/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return DevisModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<DevisModel> insertData(DevisModel devisModel) async {
    final accessToken = await storage.read(key: 'accessToken');

    var data = devisModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addDevissUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (resp.statusCode == 200) {
      return DevisModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(devisModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<DevisModel> updateData(int id, DevisModel devisModel) async {
    final accessToken = await storage.read(key: 'accessToken');

    var data = devisModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/devis/update-devis/$id");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (res.statusCode == 200) {
      return DevisModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<DevisModel> deleteData(int id) async {
    final accessToken = await storage.read(key: 'accessToken');

    var deleteUrl = Uri.parse(
        "$mainUrl/devis/delete-devis/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    });
    if (res.statusCode == 200) {
      return DevisModel.fromJson(json.decode(res.body)['agents']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}