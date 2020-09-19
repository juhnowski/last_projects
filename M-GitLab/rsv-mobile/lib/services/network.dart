import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:rsv_mobile/models/auth.dart';
import 'dart:convert';

import 'package:rsv_mobile/models/user.dart';

const _debugNetwork = true;

const Map<String, String> _defaultHosts = {
  'default': 'rsv.ru',
};

class NetworkService extends ChangeNotifier {
  Map<String, String> _hosts;
  final AuthModel _authInstance;
  User _user = new User();
  User get user => _user;

  int userId;
  bool get isLoggedIn => userId != null;
  String get jwt => _authInstance.jwt;

  NetworkService(this._authInstance, {hosts = _defaultHosts}) {
    this._hosts = hosts;
    _loadAuth();
  }

  Map get authInfo => {
    'userId': _authInstance.userId,
    'jwt': _authInstance.jwt,
  };

  //
  // Authorization
  //

  Future _loadUser(int id) async {
    userId = id;
    _user = new User();
    if (userId != null) {
      await user.loadUser(this, userId);
    }
  }

  Future _loadAuth() async {
    await _authInstance.loadAuth();
    await _loadUser(_authInstance.userId);
    notifyListeners();
  }

  Future<int> authLogin(String login, String password) async {
    Map res;
    try {
      res = await _post(
        'authorization',
        'login/submit',
        data: {'email': login, 'password': password},
        isWrapped: false,
        auth: false,
      );
    } catch (e) {
      await authLogout();
      throw 'Неверный логин или пароль';
    }
    if (res['Status'] == 'success') {
      await _authInstance.setAuth(res['Data']);
      await _loadUser(_authInstance.userId);
      notifyListeners();
    } else {
      await authLogout();
      throw 'Приносим извенения. В данный момент сервис не доступен. Пожалуйста, попробуйте позже';
    }
    return userId;
  }

  Future authLogout() async {
    await _authInstance.logout();
    await _loadUser(null);
    notifyListeners();
  }

  Future<bool> authValidateJwt() async {
    if (jwt == null) {
      return false;
    }
    String query = Uri.encodeComponent(jwt);
    var res = await _get(
      'authorization',
      'api/v1/jwt/validate?jwt=$query',
      isWrapped: false,
      auth: false,
    );
    return res['status'] == 'success';
  }

  //
  // Cms
  //

  Future<Map> getCmsEntities(String type, List<int> ids) async {
    var qs =
    Uri(queryParameters: {'id[]': ids.map((v) => v.toString())}).toString();
    return getCmsEntity(type, query: qs);
  }

  Future<Map> getNews() async {
    return getCmsEntity('news', query: '?isPublic=0');
  }

  Future<Map> getCmsEntity(String entity, {String query}) async {
    return _get('cms', 'entity/select/$entity${query ?? ''}', auth: false);
  }

  //
  // Profile
  //

  Future<Map> getGroup(groupId) async {
    return _get('profile', 'group/$groupId');
  }

  Future<Map> getGroupPairs(groupId) async {
    return _get('profile', 'group/$groupId/pairs');
  }

  Future<Map> getEvents(int groupId) async {
    return _get('profile', 'events?group_id=$groupId');
  }

  Future<Map> setEventStatus(int eventId, String status) async {
    return _post('profile', 'event/$eventId/status/$status');
  }

  Future<Map> getGroupStudents(groupId) async {
    return _get('profile', 'group/$groupId/students');
  }

  Future<Map> getGroupLeaders(groupId) async {
    return _get('profile', 'group/$groupId/leaders');
  }

  Future<Map> bindFileToProfile(int fileId, String fileName) async {
    if (_debugNetwork) print({'file_id': fileId, 'name': fileName});
    return _post('profile', 'file/bind',
        data: {'file_id': fileId, 'name': fileName});
  }

  Future<Map> changeFileFavorite(int fileId, bool isFavorite) async {
    return _post('profile', 'file/change',
        data: {
          "user_file_id": fileId,
          "is_favorite": isFavorite,
        },
        isWrapped: false);
  }

  Future<Map> removeFileFromProfile(int fileId) async {
    return _get('profile', 'file/remove/$fileId', isWrapped: false);
  }

  Future<Map> userGroups(id) async {
    return _get('profile', 'user/$id/groups');
  }

  Future<Map> profileInfo(id) async {
    return _get('profile', 'user/$id');
  }

  Future<Map> profileEducation(id) async {
    return _get('profile', 'education/$id');
  }

  Future<Map> getLeader(groupId) async {
    return _get('profile', 'leader/info/$groupId');
  }

  Future<Map> getTasks(groupId) async {
    return _get('profile', 'tasks/$groupId');
  }

  Future<Map> createTask(data) async {
    return _post('profile', 'task/create', data: data);
  }

  Future<Map> updateTask(data) async {
    print(data);
    return _post('profile', 'task/update', data: data, isWrapped: false);
  }

  Future<Map> removeTask(id) async {
    return _get('profile', 'task/remove/$id', isWrapped: false);
  }

  Future<Map> getMeetings(int groupId) async {
    return _get('profile', 'meetings/$groupId');
  }

  Future<Map> createMeeting(data) async {
    if (_debugNetwork) print(data);
    return _post('profile', 'meeting/create', data: data);
  }

  Future<Map> updateMeeting(data) async {
    if (_debugNetwork) print(data);
    return _post('profile', 'meeting/update', data: data, isWrapped: false);
  }

  Future<Map> rateMeeting(data) async {
    if (_debugNetwork) print(data);
    return _post('profile', 'meeting/rating', data: data, isWrapped: false);
  }

  Future<Map> rejectMeeting(data) async {
    return _post('profile', 'meeting/reject', data: data, isWrapped: false);
  }

  Future<Map> whoAmI(String groupId) async {
    return _get('profile', 'group/$groupId/whoami');
  }

  Future<Map> getFiles() async {
    return _get('profile', 'file/self');
  }

  Future<Map> getGroupFiles(groupId) async {
    return _get('profile', 'file/group/$groupId');
  }

  Future<Map> uploadFileToProfile(File file) async {
    var req = await _prepareRequest('profile', 'file/upload', true);
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var uri = Uri.parse(req['host']);
    var request = new http.MultipartRequest("POST", uri);
    request.headers['X-AUTH-TOKEN'] = req['headers']['X-AUTH-TOKEN'];
    var fileName = basename(file.path);
    var multipartFile =
    new http.MultipartFile('file', stream, length, filename: fileName);
    request.files.add(multipartFile);
    var streamResponse = await request.send();

    if (streamResponse.statusCode != 200) {
      throw Exception('Upload file request failed');
    }
    var response = await streamResponse.stream.bytesToString();
    var body = jsonDecode(response);
    if (body['status'] != 'success') {
      throw Exception('Upload file request failed');
    }
    var uploaded = body['data']['file'];
    uploaded['name'] = fileName;
    uploaded['size'] = length;
    return uploaded;
  }

  //
  // Auth & Profile
  //

  Future<Map> getUsersBulk(Iterable<int> userIds) async {
    var qs = Uri(queryParameters: {'users[]': userIds.map((v) => v.toString())})
        .toString();
    var fromAuth =
    await _get('auth', 'api/v1/users/search-by-id$qs', isWrapped: false);
    var users;
    if (fromAuth['status'] != 'success') {
      throw Exception('Unable to get users');
    } else {
      users = Map.fromIterable(fromAuth['data'],
          key: (v) => v['user_id'], value: (v) => v);
    }
    var fromProfile = await _get('profile', 'user/info/list$qs');
    fromProfile['users'].forEach((v) {
      if (users.containsKey(v['userId'])) {
        users[v['userId']]['profile'] = v;
        print(v);
      }
    });
    return users;
  }

  getHost(String service) =>
      '$service.${_hosts.containsKey(service) ? _hosts[service] : _hosts['default']}';

  Future<Map> _get(
      String service,
      String path, {
        auth: true,
        isWrapped: true,
      }) async {
    var req = await _prepareRequest(service, path, auth);
    print('_get ${req['host']}');
    print('_get ${req['headers']}');
    final response = await http.get(
      req['host'],
      headers: req['headers'],
    );
    return _handleResponse(response, isWrapped, 'GET', req['host']);
  }

  Future<Map> _post(
      String service,
      String path, {
        data,
        auth = true,
        isWrapped = true,
      }) async {
    var req = await _prepareRequest(service, path, auth);
    var body = (data != null) ? jsonEncode(data) : '';
    final response = await http.post(
      req['host'],
      headers: req['headers'],
      body: body,
    );
    return _handleResponse(response, isWrapped, 'POST', req['host']);
  }

  Future<Map> _prepareRequest(
      String service, String path, bool withAuth) async {
    Map<String, String> headers = {};
    if (withAuth) {
      if (_authInstance.isExpired) {
        // listen for new jwt after refresh
//        if (_authInstance.isRefreshing) {

//        } else {
//             add refresh event
        try {
          await _authInstance
              .setAuth(await _refreshJwtToken(_authInstance.refresh));
          notifyListeners();
        } catch (e) {
          await authLogout();
        }
//        }
      }
      if (_authInstance.jwt == null) {
        throw Exception('Unable to send post request jwt is not defined');
      }
      headers['X-AUTH-TOKEN'] = _authInstance.jwt;
    }
    return {
      'host': 'https://${getHost(service)}/$path',
      'headers': headers,
    };
  }

  Map _handleResponse(
      http.Response response, bool isWrapped, String method, String host) {
    print('${response.statusCode} response.statusCode');
    if (response.statusCode != 200) {
      throw Exception('Fail $method $host');
    }
    Map body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw Exception('Invalid server response');
    }
    if (isWrapped) {
      if (body['status'] == 'success') {
        return body['data'];
      } else {
        throw Exception('Status ${body['status']} on $method $host');
      }
    } else {
      return body;
    }
  }

  Future<Map> _refreshJwtToken(String refreshToken) async {
    print(refreshToken);
    var res = await _post(
      'authorization',
      'jwt/update',
      data: {'refresh_token': refreshToken},
      isWrapped: false,
      auth: false,
    );
    if (res['Status'] == 'success') {
      return res['Data'];
    } else {
      return null;
    }
  }
}
