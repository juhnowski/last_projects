import 'package:meta/meta.dart';
import 'package:russian_leaders/model/request_results.dart';
import 'package:russian_leaders/repository/settings_manager.dart';

abstract class UserRepository {
  Future<AuthResult> authenticate({
    @required String username,
    @required String password,
  });

  Future<void> deleteToken();

  Future<void> persistToken(String token);

  Future<bool> hasToken();
}

class MockUserRepository implements UserRepository {
  final SettingsManager settingsManager;

  MockUserRepository(this.settingsManager);

  @override
  Future<AuthResult> authenticate({String username, String password}) async {
    await Future.delayed(Duration(seconds: 1));
    return AuthResult(AuthError.OK, " jjj", null);
  }

  @override
  Future<void> deleteToken() async {
    await settingsManager.clearToken();
    return;
  }

  @override
  Future<void> persistToken(String token) async {
    await settingsManager.putToken(token);
    return;
  }

  @override
  Future<bool> hasToken() async {
    return settingsManager.hasToken();
  }
}
