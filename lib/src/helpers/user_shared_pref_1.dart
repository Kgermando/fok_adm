// import 'dart:convert';

// import 'package:fokad_admin/src/models/users/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserSharedPref {
//   static const _keyUser = 'userModel';
//   static const _keyIdToken = 'idToken';
//   static const _keyAccessToken = 'accessToken';
//   static const _keyRefreshToken = 'refreshToken';
  

//    Future<UserModel> getUser() async {
//     final userPrefs = await SharedPreferences.getInstance();
//     final String? prefs = userPrefs.getString(_keyUser);
//     if (prefs != null) {
//       UserModel user = UserModel.fromJson(jsonDecode(prefs));
//       return user;
//     } else {
//       UserModel user = UserModel(
//           nom: '-',
//           prenom: '-',
//           email: '-',
//           telephone: '-',
//           matricule: '-',
//           departement: '-',
//           servicesAffectation: '-',
//           fonctionOccupe: '-',
//           role: '5',
//           isOnline: 'false',
//           createdAt: DateTime.now(),
//           passwordHash: '-',
//           succursale: '-');
//       return user;
//     }
//   }

//   saveUser(value) async {
//     final userPrefs = await SharedPreferences.getInstance();
//     await userPrefs.setString(_keyUser, json.encode(value));
//   }

//   removeUser() async {
//     final userPrefs = await SharedPreferences.getInstance();
//     await userPrefs.remove(_keyUser);
//   }

//   // ID User
//   Future<String?> getIdToken() async {
//     final userPrefs = await SharedPreferences.getInstance();
//     final String? data = userPrefs.getString(_keyIdToken);
//     return data;
//   }


//   saveIdToken(value) async {
//     final userPrefs = await SharedPreferences.getInstance();
//     await userPrefs.setString(_keyIdToken, json.encode(value));
//   }

//   removeIdToken() async {
//     final userPrefs = await SharedPreferences.getInstance();
//     await userPrefs.remove(_keyIdToken);
//   }

//   // AccessToken
//   Future<String?> getAccessToken() async {
//     final userPrefs = await SharedPreferences.getInstance();
//     final String? data = userPrefs.getString(_keyAccessToken);
//     return data;
    
//   }

//   saveAccessToken(value) async {
//     final userPrefs = await SharedPreferences.getInstance();
//     await userPrefs.setString(_keyAccessToken, json.encode(value));
//   }

//   removeAccessToken() async {
//     final userPrefs = await SharedPreferences.getInstance();
//     await userPrefs.remove(_keyAccessToken);
//   }

//   // RefreshToken
//   Future<String?> getRefreshToken() async {
//     final userPrefs = await SharedPreferences.getInstance();
//     final String? data = userPrefs.getString(_keyRefreshToken);
//     return data;
//   }

//   saveRefreshToken(value) async {
//     final userPrefs = await SharedPreferences.getInstance();
//     await userPrefs.setString(_keyRefreshToken, json.encode(value));
//   }

//   removeRefreshToken() async {
//     final userPrefs = await SharedPreferences.getInstance();
//     await userPrefs.remove(_keyRefreshToken);
//   }
  
// }