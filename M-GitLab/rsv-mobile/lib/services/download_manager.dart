import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadManager {
  bool _permissionReady = false;
  String _localPath;
  TargetPlatform _platform;

  DownloadManager(this._platform) {
    prepare();
  }

  Future prepare() async {
    if (!_permissionReady) {
      _permissionReady = await _checkPermission();
      _localPath = (await _findLocalPath()) + '/Download';
      final savedDir = Directory(_localPath);
      print('PREPARE $_localPath');
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }
    }
  }

  Future<String> _findLocalPath() async {
    final directory = _platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> _checkPermission() async {
    if (_platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  downloadFile(url) async {
    await prepare();
    await FlutterDownloader.enqueue(
        url: url,
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }
}
