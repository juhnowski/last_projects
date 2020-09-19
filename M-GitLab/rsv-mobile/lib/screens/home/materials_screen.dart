import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/files.dart';
import 'package:rsv_mobile/models/profile_file.dart';
import 'package:rsv_mobile/services/download_manager.dart';
import 'package:rsv_mobile/widgets/home/file_item.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class MaterialsScreen extends StatefulWidget {
  MaterialsScreen({Key key}) : super(key: key);

  @override
  _MaterialsScreenState createState() => new _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  File file;

  @override
  void initState() {
    Provider.of<DownloadManager>(context, listen: false).prepare();
    super.initState();
  }

  void _choose() async {
    var file = await FilePicker.getFile(type: FileType.ANY);
    var filesRepository = Provider.of<Files>(context, listen: false);
    print('upload file start');
    ProfileFile uploadedFile = await filesRepository.uploadFile(file);
    await filesRepository.saveToMe(uploadedFile);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: DecoratedBox(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/homebg.png'),
                  fit: BoxFit.cover),
              color: Colors.white),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
//              automaticallyImplyLeading: false,
              title: Row(
                children: <Widget>[
                  Text('Материалы'),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Color(0xff3AA0FD),
                    ),
                    onPressed: () {
                      _choose();
                    },
                  )
                ],
              ),
              bottom: TabBar(
                labelColor: Color(0xff1184ED),
                tabs: [
                  Tab(text: 'Мои'),
                  Tab(text: 'Общие'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Container(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Provider.of<Files>(context, listen: false)
                          .loadUserFiles();
                    },
                    child: Consumer<Files>(
                      builder: (context, files, child) {
                        if (files.userFiles.length == 0) {
                          return child;
                        } else {
                          return ListView.builder(
                              padding: Margin.all(context),
                              itemCount: files.userFiles.length,
                              itemBuilder: (context, i) {
                                return FileItem(files.userFiles[i]);
                              });
                        }
                      },
                      child: Center(
                        child: Text('Файлов пока нет.'),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Provider.of<Files>(context, listen: false)
                          .loadGroupFiles();
                    },
                    child: Consumer<Files>(
                      builder: (context, files, child) {
                        if (files.groupFiles.length == 0) {
                          return Center(
                            child: child,
                          );
                        } else {
                          return ListView.builder(
                              padding: Margin.all(context),
                              itemCount: files.groupFiles.length,
                              itemBuilder: (context, i) {
                                return FileItem(
                                  files.groupFiles[i],
                                  showFavorite: false,
                                );
                              });
                        }
                      },
                      child: Text('Файлов пока нет.'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
