import 'package:flutter/material.dart';
import 'package:rsv_mobile/widgets/home/backgrounded_scaffold.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AddFileScreen extends StatefulWidget {
  _AddFileScreenState createState() => _AddFileScreenState();
}

class _AddFileScreenState extends State<AddFileScreen> {
  File file;

  void _choose() async {
    file = await FilePicker.getFile(type: FileType.ANY);
  }

  void _upload() async {}

  @override
  Widget build(BuildContext context) {
    return BackgroundedScaffold(
      appBar: AppBar(title: Text('Добавить файл')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _choose,
                  child: Text('Выбрать файл'),
                ),
                SizedBox(width: 10.0),
                RaisedButton(
                  onPressed: _upload,
                  child: Text('Загрузить'),
                )
              ],
            ),
            file == null ? Text('Файл не выбран') : Text('е файл')
          ],
        ),
      ),
    );
  }
}
