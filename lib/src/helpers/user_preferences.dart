import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences extends ChangeNotifier {
  static const _keyUser = 'userModel';
  static const _keyAuth = 'authJWT';

  static Future<UserModel> read() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyUser);
    if (json != null) {
      UserModel user = UserModel.fromJson(jsonDecode(json));
      return user;
    } else {
      final user = UserModel(
          nom: 'nom',
          prenom: 'prenom',
          matricule: 'matricule',
          role: 'role',
          isOnline: false,
          createdAt: DateTime.now(),
          passwordHash: 'passwordHash');
      return user;
    }
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<bool> getAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authJWT = prefs.getBool(_keyAuth) ?? false;
    // print('authJWT $authJWT');
    return authJWT;
  }

  static setAuth(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyAuth, value);
  }

  static removeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyAuth);
  }
}
