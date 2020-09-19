import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const TOKEN = "token";

  Future<bool> hasToken() async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    return pf.containsKey(TOKEN);
  }

  Future<String> getToken() async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    String token = pf.containsKey(TOKEN) ? pf.getString(TOKEN) : "";
    return token;
  }

  Future<void> putToken(String value) async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    pf.setString(TOKEN, value);
  }

  Future<void> clearToken() async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    pf.remove(TOKEN);
  }
}
