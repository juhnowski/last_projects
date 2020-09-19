import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/files.dart';
import 'package:rsv_mobile/models/user_file.dart';
import 'package:rsv_mobile/services/download_manager.dart';

class FileItem extends StatelessWidget {
  final UserFile _file;
  final bool showFavorite;

  FileItem(this._file, {this.showFavorite = true});

  String get icon {
    var format = _file.name.split('.').last;
    switch (format) {
      case 'doc':
      case 'pdf':
      case 'ppt':
      case 'svg':
      case 'xls':
        return 'assets/images/$format.png';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return null;
      default:
        return 'assets/images/unknown.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    var rowWidgets = <Widget>[
      icon == null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(64.0),
              child: Container(
                decoration: new BoxDecoration(color: Color(0xFFDCE8FF)),
                height: 40,
                width: 40,
                child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: _file.url ?? ''),
//                  child: FadeInImage.assetNetwork(
//                    placeholder: 'assets/images/unknown.png',
//                    image: _file.url ?? ''
//                  ),
              ),
            )
          : Container(
              height: 40,
              width: 40,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: AssetImage(icon), fit: BoxFit.cover),
              ),
            ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _file.name,
                style: Theme.of(context).textTheme.body1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
//                Text(
//                  '',
//                  style: TextStyle(
//                      fontWeight: FontWeight.w300, color: Color(0xff8f9398)),
//                )
            ],
          ),
        ),
      ),
    ];

    if (showFavorite) {
      rowWidgets.add(IconButton(
        onPressed: () {
          Provider.of<Files>(context, listen: false).switchFavorite(_file);
        },
        padding: EdgeInsets.all(8),
        icon: Icon(_file.isFavorite ? Icons.star : Icons.star_border,
            color: Color(0xff1184ed)),
      ));
    }

    return InkWell(
        onTap: () {
          Future.delayed(Duration(milliseconds: 200), () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                var items = <Widget>[
                  Container(
                    height: 60,
                    child: SimpleDialogOption(
                      onPressed: () async {
                        Provider.of<DownloadManager>(context, listen: false)
                            .downloadFile(_file.url);
                        Navigator.of(context).pop();
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Скачать файл',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1184ED)),
                          )),
                    ),
                  ),
                ];

                if (_file.isMine) {
                  items.add(
                    Container(
                      height: 60,
                      child: SimpleDialogOption(
                        onPressed: () {
                          Provider.of<Files>(context, listen: false)
                              .removeFile(_file);
                          Navigator.of(context).pop();
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: const Text('Удалить файл')),
                      ),
                    ),
                  );
                }

                if (showFavorite) {
                  items.add(
                    Container(
                      height: 60,
                      child: SimpleDialogOption(
                        onPressed: () {
                          Provider.of<Files>(context, listen: false)
                              .switchFavorite(_file);
                          Navigator.of(context).pop();
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(_file.isFavorite
                                ? 'Убрать из избранного'
                                : 'Добавить в избранное')),
                      ),
                    ),
                  );
                }

                return SimpleDialog(
//                title: const Text('Select assignment'),
                  children: items,
                );
              },
            );
          });
        },
        child: Container(
            height: 80,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        style: BorderStyle.solid,
                        width: 1,
                        color: Color(0xfff2f2f2)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowWidgets,
            )));
  }
}
