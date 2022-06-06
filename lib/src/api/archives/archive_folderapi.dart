// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:http/http.dart' as http;

class ArchiveFolderApi {
  var client = http.Client();

  Future<List<ArchiveFolderModel>> getAllData() async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      archvesUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ArchiveFolderModel> data = [];
      for (var u in bodyList) {
        data.add(ArchiveFolderModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<ArchiveFolderModel> getOneData(int id) async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var getUrl = Uri.parse("$mainUrl/archves/$id");
    var resp = await client.get(
      getUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return ArchiveFolderModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ArchiveFolderModel> insertData(ArchiveModel archiveModel) async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    var data = archiveModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addArchvesUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (resp.statusCode == 200) {
      return ArchiveFolderModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(archiveModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ArchiveFolderModel> updateData(int id, ArchiveFolderModel archiveModel) async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    var data = archiveModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/archves/update-archve/$id");

    var res = await client.put(updateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (res.statusCode == 200) {
      return ArchiveFolderModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<ArchiveFolderModel> deleteData(int id) async {
    // String? token = await UserSharedPref().getAccessToken();
    String? token = await UserSharedPref().getAccessToken();

    var deleteUrl = Uri.parse("$mainUrl/archves/delete-archve/$id");

    var res = await client.delete(deleteUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    if (res.statusCode == 200) {
      return ArchiveFolderModel.fromJson(json.decode(res.body)['data']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
