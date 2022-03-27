import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/api/auth/api_error.dart';
import 'package:fokad_admin/src/api/auth/token.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:http/http.dart' as http;

class AuthApi extends ChangeNotifier {
  var client = http.Client();

  Future<bool> login(String matricule, String passwordHash) async {
    var data = {'matricule': matricule, 'passwordHash': passwordHash};
    var body = jsonEncode(data);

    var resp = await client.post(loginUrl, body: body);

    if (resp.statusCode == 200) {
      print('body ${json.decode(resp.body)}');
      const storage = FlutterSecureStorage();
      Token token = Token.fromJson(json.decode(resp.body));

      // Store the tokens
      await storage.write(key: 'idToken', value: token.id.toString());
      await storage.write(key: 'accessToken', value: token.accessToken);
      await storage.write(key: 'refreshToken', value: token.refreshToken);
      // await storage.write(key: 'expireIn', value: token.expiresIn.toString());

      var accessToken = await storage.read(key: 'accessToken'); // pour test
      print('accessToken $accessToken');

      // Add the timer to refresh the token
      // refreshAccessTokenTimer(token.expiresIn);

      return true;
    } else {
      throw ApiError.fromJson(json.decode(resp.body));
    }
  }

  Future<void> register(UserModel userModel) async {
    var data = userModel.toMap();
    var body = jsonEncode(data);
    const storage = FlutterSecureStorage();
    var accessToken = await storage.read(key: 'accessToken');
    var headers = {HttpHeaders.authorizationHeader: "Bearer $accessToken"};

    var resp = await client.post(loginUrl, body: body, headers: headers);
    if (resp.statusCode == 200) {
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');
    
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
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'accessToken');
  }

  Future<void> refreshAccessToken() async {
    const storage = FlutterSecureStorage();
    final refreshToken = await storage.read(key: 'refreshToken');
    var data = {'refresh_token': refreshToken};
    var body = jsonEncode(data);
    var resp = await client.post(refreshTokenUrl, body: body);
    if (resp.statusCode == 200) {
      Token token = Token.fromJson(json.decode(resp.body));
      // Store the tokens
      await storage.write(key: 'accessToken', value: token.accessToken);
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

  Future<UserModel> getuserLoggedIn() async {
    const storage = FlutterSecureStorage();
    var accessToken = await storage.read(key: 'accessToken');
    print('profile Token $accessToken');
    var headers = {
      // HttpHeaders.authorizationHeader: "Bearer $accessToken",
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    var resp = await client.get(userUrl, headers: headers);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }
}
