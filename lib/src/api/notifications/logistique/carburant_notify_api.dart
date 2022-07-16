// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/notify/notify_model.dart';
import 'package:http/http.dart' as http;

class CarburantNotify extends ChangeNotifier {
  var client = http.Client();

  var getDDUrl = Uri.parse("$carburantsNotifyUrl/get-count-dd/");

  Future<NotifyModel> getCountDD() async {
    String? token = await UserSharedPref().getAccessToken();
    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      getDDUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return getCountDD();
    } else {
      throw Exception(resp.statusCode);
    }
  }
}
