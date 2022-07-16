// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/notify/notify_model.dart';
import 'package:http/http.dart' as http;

class CampaignNotifyApi extends ChangeNotifier {
  var client = http.Client();

  var getDGUrl = Uri.parse("$campaignsNotifyUrl/get-count-dg/");
  var getDDUrl = Uri.parse("$campaignsNotifyUrl/get-count-dd/");
  var getBudgetUrl = Uri.parse("$campaignsNotifyUrl/get-count-budget/");
  var getFinUrl = Uri.parse("$campaignsNotifyUrl/get-count-fin/");
  var getObsUrl = Uri.parse("$campaignsNotifyUrl/get-count-obs/");

  Future<NotifyModel> getCountDG() async {
    String? token = await UserSharedPref().getAccessToken();
    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      getDGUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return getCountDG();
    } else {
      throw Exception(resp.statusCode);
    }
  }

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

  Future<NotifyModel> getCountBudget() async {
    String? token = await UserSharedPref().getAccessToken();
    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      getBudgetUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return getCountBudget();
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifyModel> getCountFin() async {
    String? token = await UserSharedPref().getAccessToken();
    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      getFinUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return getCountFin();
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifyModel> getCountObs() async {
    String? token = await UserSharedPref().getAccessToken();
    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var resp = await client.get(
      getObsUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      await AuthApi().refreshAccessToken();
      return getCountObs();
    } else {
      throw Exception(resp.statusCode);
    }
  }
}
