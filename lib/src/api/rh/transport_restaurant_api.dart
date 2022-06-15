// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:http/http.dart' as http;

class TransportRestaurationApi {
  var client = http.Client();

  Future<List<TransportRestaurationModel>> getAllData() async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      transportRestaurationUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<TransportRestaurationModel> data = [];
      for (var u in bodyList) {
        data.add(TransportRestaurationModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<TransportRestaurationModel> getOneData(int id) async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/rh/transport-restaurations/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return TransportRestaurationModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<TransportRestaurationModel> insertData(
      TransportRestaurationModel transRest) async {
    String? token = await UserSharedPref().getAccessToken();

    var data = transRest.toJson();
    var body = jsonEncode(data);

    var res = await client.post(addTransportRestaurationUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (res.statusCode == 200) {
      return TransportRestaurationModel.fromJson(json.decode(res.body));
    } else if (res.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(transRest);
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<TransportRestaurationModel> updateData(
      TransportRestaurationModel transRest) async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    var data = transRest.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/rh/transport-restaurations/update-transport-restauration/");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (res.statusCode == 200) {
      return TransportRestaurationModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<TransportRestaurationModel> deleteData(int id) async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    var deleteUrl = Uri.parse(
        "$mainUrl/rh/transport-restaurations/delete-transport-restauration/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    if (res.statusCode == 200) {
      return TransportRestaurationModel.fromJson(
          json.decode(res.body)['agents']);
    } else {
      throw Exception(res.statusCode);
    }
  }
}
