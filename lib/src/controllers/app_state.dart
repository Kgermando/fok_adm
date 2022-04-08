import 'package:flutter/material.dart';
import 'package:fokad_admin/src/helpers/user_preferences.dart';
import 'package:provider/provider.dart';

class AppState extends ChangeNotifier {
  AppState({this.darkTheme = false});
  bool isLoading = false;
  bool scrollEnabled = true;
  ScrollController scrollController = ScrollController();
  String? error;
  String? currentId;
  bool isLoggedIn = false;
  GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey();
  bool darkTheme = false;
  bool mapPanning = true;
  void _setLoading(bool state) {
    isLoading = state;
    notifyListeners();
  }

  void setMapPanning(bool state){
    mapPanning = state;
    notifyListeners();
  }

  void _setError(String? err) {
    error = err;
    notifyListeners();
  }

  void setScroll(bool state) {
    scrollEnabled = state;
    notifyListeners();
  }

  static void setLoading(BuildContext context, bool state) {
    context.read<AppState>()._setLoading(state);
  }

  static void setError(BuildContext context, String? error) {
    context.read<AppState>()._setError(error);
  }

  openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
    // mainScaffoldKey.currentState?.openEndDrawer();
  }

  closeDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
    //mainScaffoldKey.currentState?.openDrawer();
  }

  Future<String?> handleAfterLogin(String id) async {
    currentId = id;
    isLoggedIn = true;
    String? res = await UserPreferences.getIdToken();
    notifyListeners();
    return res;
  }

  Future<String?> handleAfterUserUpdate(String id) async{
    return handleAfterLogin(id);
  }

  void setLogin(String id) { 
    currentId = id;
    isLoggedIn = true;
    notifyListeners();
  }

  Future<bool> handleAfterLogout() async {
    currentId = null;
    isLoggedIn = false;
    bool res = await UserPreferences.removeIdToken() ?? false;
    notifyListeners();
    return res;
  }
}
