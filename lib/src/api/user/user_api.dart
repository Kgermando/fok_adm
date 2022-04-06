import 'dart:convert';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class UserApi {
  var client = http.Client();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    print('accessToken $accessToken');
    return accessToken;
  }

  Future<List<UserModel>> getAllData() async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      userAllUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<UserModel> data = [];
      for (var u in bodyList) {
        data.add(UserModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }


  Future<UserModel> getOneData(int id) async {
    String? token = await getToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var userUrl = Uri.parse("$mainUrl/user/$id");
    var resp = await client.get(
      userUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<UserModel> insertData(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    var data = userModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(registerUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return insertData(userModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<UserModel> updateData(int id, UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    var data = userModel.toJson();
    var body = jsonEncode(data);
    var updateAgentsUrl = Uri.parse("$mainUrl/user/");

    var res = await client.patch(updateAgentsUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);
    if (res.statusCode == 200) {
      return UserModel.fromJson(json.decode(res.body)['users']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");
    var deleteAgentsUrl = Uri.parse("$mainUrl/user/delete-user/$id");

    var res = await client.delete(deleteAgentsUrl, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    });
    if (res.statusCode == 200) {
  
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }


}