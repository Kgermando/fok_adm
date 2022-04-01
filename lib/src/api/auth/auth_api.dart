import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/api/auth/api_error.dart';
import 'package:fokad_admin/src/api/auth/token.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi extends ChangeNotifier {
  var client = http.Client();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    print('agent accessToken $accessToken');
    return accessToken;
  }

  Future<bool> login(String matricule, String passwordHash) async {
    var data = {'matricule': matricule, 'passwordHash': passwordHash};
    var body = jsonEncode(data);

    var resp = await client.post(loginUrl, body: body);

    if (resp.statusCode == 200) {
      // print('body ${json.decode(resp.body)}');
      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      // const storage = FlutterSecureStorage();
      Token token = Token.fromJson(json.decode(resp.body));
      // Store the tokens
      await prefs.setString('idToken', token.id.toString());
      await prefs.setString('accessToken', token.accessToken);
      await prefs.setString('refreshToken', token.refreshToken);
      // await prefs.setString('expiresIn', token.expiresIn.toString());

      // Add the timer to refresh the token
      // refreshAccessTokenTimer(token.expiresIn);

      return true;
    } else {
      throw ApiError.fromJson(json.decode(resp.body));
    }
  }

  Future<void> register(UserModel userModel) async {
    var data = userModel.toJson();
    var body = jsonEncode(data);
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");
    var headers = {HttpHeaders.authorizationHeader: "Bearer $accessToken"};

    var resp = await client.post(registerUrl, body: body, headers: headers);
    if (resp.statusCode == 200) {
      Token token = Token.fromJson(json.decode(resp.body));
      // refreshAccessTokenTimer(token.expiresIn);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");

    if (accessToken != null && 'accessToken'.isNotEmpty) {
      try {
        await refreshAccessToken();
      } catch (e) {
        debugPrint('un soucis $e');
      }
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  // Retrieve the access token
  Future<String?> getAccessToken() async {
    // const storage = FlutterSecureStorage();
    //  await storage.read(key: 'accessToken');
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  Future<void> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    var refreshToken = prefs.getString("refreshToken");

    var data = {'refresh_token': refreshToken};
    var body = jsonEncode(data);
    var resp = await client.post(refreshTokenUrl, body: body);
    if (resp.statusCode == 200) {
      Token token = Token.fromJson(json.decode(resp.body));
      await prefs.setString('accessToken', token.accessToken);
      // refreshAccessTokenTimer(token.expiresIn);
    } else {
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
    var res = await client.get(
      userUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 200) {
      return UserModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
