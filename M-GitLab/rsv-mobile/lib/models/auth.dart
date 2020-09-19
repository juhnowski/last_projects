import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthModel {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  DateTime expireAt;
  String jwt;
  String refresh;
  int userId;

  bool get isExpired => expireAt?.isBefore(new DateTime.now()) ?? true;

  loadAuth() async {
    print('load auth');
    final SharedPreferences prefs = await _prefs;
    jwt = prefs.getString('access_token');
    if (jwt == null) {
      await logout();
      return;
    }
    Map payload;
    try {
      payload = _decodeJwt(jwt);
    } catch (e) {
      await logout();
      return;
    }
    userId = payload['user_id'] as int;
    refresh = prefs.getString('refresh_token');
    expireAt = _getJwtExpiration(payload);
  }

  Future<void> setAuth(Map authInfo) async {
    print('set auth');
    Map payload;
    try {
      payload = _decodeJwt(authInfo['jwt']);
    } catch (e) {
      await logout();
      return;
    }
    userId = payload['user_id'] as int;
    jwt = authInfo['jwt'];
    refresh = authInfo['refresh_token'];
    expireAt = _getJwtExpiration(payload);

    final SharedPreferences prefs = await _prefs;
    await prefs.setString('access_token', jwt);
    await prefs.setString('refresh_token', refresh);

    print('new jwt = $jwt');
  }

  Future logout() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    userId = null;
    jwt = null;
    refresh = null;
    expireAt = null;
  }

  DateTime _getJwtExpiration(Map payload) {
    int expires;
    if (payload != null && payload is Map) {
      expires = payload['expires_at'] as int;
    }
    return DateTime.fromMillisecondsSinceEpoch(expires * 1000);
  }

  Map _decodeJwt(String jwt) {
    var parts = jwt.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid jwt');
    }
    Map payload;
    try {
      payload = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    } catch (e) {
      throw Exception('Unable to parse jwt');
    }
    return payload;
  }
}
