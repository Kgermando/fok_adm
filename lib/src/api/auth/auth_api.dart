// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/cupertino.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/api/auth/api_error.dart';
import 'package:fokad_admin/src/api/auth/token.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/helpers/user_preferences.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi extends ChangeNotifier {
  var client = http.Client();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    // print('agent accessToken $accessToken');
    return accessToken;
  }

  Future<bool> login(String matricule, String passwordHash) async {
    var data = {'matricule': matricule, 'passwordHash': passwordHash};
    var body = jsonEncode(data);

    var resp = await client.post(loginUrl, body: body);
    if (resp.statusCode == 200) {
      Token token = Token.fromJson(json.decode(resp.body));
      // Store the tokens
      UserPreferences.saveIdToken(token.id.toString()); // Id user
      UserPreferences.saveAccessToken(token.accessToken);
      UserPreferences.saveRefreshToken(token.refreshToken);
      return true;
    } else {
      throw ApiError.fromJson(json.decode(resp.body));
    }
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final accessToken = await getToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      // try {
      //   await refreshAccessToken();
      // } catch (e) {
      //   debugPrint('un soucis $e');
      // }
      return true;
    } else {
      return false;
    }
  }

  Future<void> refreshAccessToken() async {
    String? token = await getToken();
    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }

    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken!.isNotEmpty) {
      var splittedJwt = refreshToken.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }

    // print('refreshToken $refreshToken');

    var data = {'refresh_token': refreshToken};
    var body = jsonEncode(data);
    var resp = await client.post(
      refreshTokenUrl,
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (resp.statusCode == 200) {
      Token token = Token.fromJson(json.decode(resp.body));

      UserPreferences.saveAccessToken(token.accessToken);
      UserPreferences.saveRefreshToken(token.refreshToken);
    } else {
      UserPreferences.removeAccessToken();
      UserPreferences.removeRefreshToken();
      throw ApiError.fromJson(json.decode(resp.body));
    }
  }

  // A timer to refresh the access token one minute before it expires
  refreshAccessTokenTimer(int time) async {
    var newTime = time - 60000; // Renew 1min before it expires
    await Future.delayed(Duration(milliseconds: newTime));

    try {
      await refreshAccessToken();
    } catch (e) {
      await refreshAccessToken();
      refreshAccessTokenTimer(time);
      debugPrint('un soucis $e');
    }
  }

  Future<UserModel> getUserInfo() async {
    String? token = await getToken();
    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
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

  Future<UserModel> getUserId() async {
    String? token = await getToken();
    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }

    var _keyIdToken = 'idToken';
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyIdToken);
    String idPrefs = jsonDecode(data!);
    // print('idPrefs $idPrefs');
    int id = int.parse(idPrefs);
    var userIdUrl = Uri.parse("$mainUrl/user/$id");
    var resp = await client.get(
      userIdUrl, 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(UserModel.fromJson(json.decode(resp.body)));
    }
  }

  Future<void> logout() async {
    try {
      String? token = await getToken();
      if (token!.isNotEmpty) {
        var splittedJwt = token.split(".");
        var payload = json.decode(
            ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
      }
      var resp = await client.post(
        logoutUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );
      if (resp.statusCode == 200) {
        UserPreferences.removeIdToken();
        UserPreferences.removeAccessToken();
        UserPreferences.removeRefreshToken();
      }
    } catch (e) {
      throw Exception(['message']);
    }
  }
}
