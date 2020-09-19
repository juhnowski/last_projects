import 'dart:io';

import 'package:rsv_mobile/models/profile_file.dart';
import 'package:rsv_mobile/models/user_file.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:flutter/cupertino.dart';

class Files extends ChangeNotifier {
  NetworkService _networkService;
  List<UserFile> _groupFiles = [];
  List<UserFile> _userFiles = [];

  int _userId;
  int _groupId;

  Files(this._networkService);

  set userId(id) {
    if (_userId != id) {
      _userId = id;
      if (_userId == null) {
        _userFiles.clear();
        notifyListeners();
      } else {
        loadUserFiles();
      }
    }
  }

  set groupId(id) {
    if (_groupId != id) {
      _groupId = id;
      if (_groupId == null) {
        _groupFiles.clear();
        notifyListeners();
      } else {
        loadGroupFiles();
      }
    }
  }

  List<UserFile> get groupFiles => _groupFiles;
  List<UserFile> get userFiles => _userFiles
    ..sort((a, b) {
      return (b.isFavorite ? 1 : 0) - (a.isFavorite ? 1 : 0);
    });
  List<UserFile> get allFiles {
    List<UserFile> files = [];
    files
      ..addAll(_userFiles)
      ..addAll(_groupFiles)
      ..sort((a, b) {
        return a.createdAt.compareTo(b.createdAt);
      });
    return files.toList();
  }

  loadGroupFiles() async {
    if (_groupId == null) {
      throw Exception('Unable to load files for group: $_groupId');
    }
    _groupFiles = (await _networkService.getGroupFiles(_groupId))['files']
        .map((file) {
          return UserFile(file, isMine: false);
        })
        .toList()
        .cast<UserFile>();
    notifyListeners();
  }

  loadUserFiles() async {
    _userFiles = (await _networkService.getFiles())['files']
        .map((file) {
          print(file);
          return UserFile(file, isMine: true);
        })
        .toList()
        .cast<UserFile>();
    notifyListeners();
  }

  Future<ProfileFile> uploadFile(File file) async {
    Map uploaded = await _networkService.uploadFileToProfile(file);
    return ProfileFile(uploaded);
  }

  Future<Map> saveToMe(ProfileFile file) async {
    var binding = await _networkService.bindFileToProfile(file.id, file.name);
    loadUserFiles();
    return binding['userFile'];
  }

  Future removeFile(UserFile file) async {
    await _networkService.removeFileFromProfile(file.id);
    loadUserFiles();
  }

  Future switchFavorite(UserFile file) async {
    await _networkService.changeFileFavorite(file.id, !file.isFavorite);
    _userFiles[_userFiles.indexOf(file)].isFavorite = !file.isFavorite;
    notifyListeners();
    return;
  }
}
