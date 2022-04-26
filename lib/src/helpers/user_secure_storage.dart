import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';


class UserSecureStorage {
  static const _keyUser = 'userModel';
  // static const _keyAuth = 'authJWT';
  static const _keyIdToken = 'idToken';
  static const _keyAccessToken = 'accessToken';
  static const _keyRefreshToken = 'refreshToken';

  // Init storage
  final storage = const FlutterSecureStorage();

  Future<UserModel> read() async {
    final prefs = await storage.read(key: _keyUser);
    if (prefs != null) {
      UserModel user = UserModel.fromJson(jsonDecode(prefs));
      return user;
    } else {
      final user = UserModel(
          nom: 'nom',
          prenom: 'prenom',
          matricule: 'matricule',
          departement: 'departement',
          servicesAffectation: 'servicesAffectation',
          fonctionOccupe: 'fonctionOccupe',
          role: 'role',
          isOnline: false,
          createdAt: DateTime.now(),
          passwordHash: 'passwordHash');
      return user;
    }
  }

  saveUser(value) async {
    await storage.write(key: _keyUser, value: json.encode(value));
  }

  removeUser() async {
    await storage.delete(key: _keyUser);
  }

  // ID User
  Future<String?> getIdToken() async {
    final data = await storage.read(key: _keyIdToken);
    return data;
  }

  saveIdToken(value) async {
    await storage.write(key: _keyIdToken, value: json.encode(value));
  }

  removeIdToken() async {
    await storage.delete(key: _keyIdToken);
  }

  // AccessToken
  Future<String?> getAccessToken() async {
    final data = await storage.read(key: _keyAccessToken);
    return data;
  }

  saveAccessToken(value) async {
    await storage.write(key: _keyAccessToken, value: json.encode(value));
  }

  removeAccessToken() async {
    await storage.delete(key: _keyAccessToken);
  }

  // RefreshToken
  Future<String?> getRefreshToken() async {
    final data = await storage.read(key: _keyRefreshToken);
    return data;
  }

  saveRefreshToken(value) async {
    await storage.write(key: _keyRefreshToken, value: json.encode(value));
  }

  removeRefreshToken() async {
    await storage.delete(key: _keyRefreshToken);
  }



  
}