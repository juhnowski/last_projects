import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rsv_mobile/models/news_item.dart';
import 'package:rsv_mobile/screens/sub/news_open_screen.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class NewsFeature extends StatefulWidget {
  final NewsItem item;
  final bool isOpen;

  NewsFeature(this.item, {this.isOpen = false});

  @override
  _NewsFeatureState createState() => _NewsFeatureState();
}

class _NewsFeatureState extends State<NewsFeature> {
  String _strDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Intl.defaultLocale = 'ru';
    this._strDate = new DateFormat('dd.MM.yyyy').format(widget.item.createdAt);
  }

  @override
  Widget build(BuildContext context) {
    double height = 216;
    if (Device.get().isTablet) {
      height = 400;
    }

    var container = new Container(
      padding: new EdgeInsets.all(20.0),
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Expanded(
                  child: ClipRRect(
                borderRadius: new BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: CachedNetworkImageProvider(widget.item.preview),
                  height: height,
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/images/image.png'),
                ),
              )),
            ],
          ),
          new Container(
              padding: EdgeInsets.only(top: 12.0),
              child: new Column(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(widget.item.title,
                        style: new TextStyle(
                            fontSize: widget.isOpen ? 28.0 : 18.0,
                            color: Color(0xFF2A2A2A))),
                  ),
                  new Align(
                      alignment: Alignment.centerLeft,
                      child: new Container(
                        padding: EdgeInsets.only(top: 12.0),
                        child: new Text(_strDate,
                            style: new TextStyle(
                                color: Color(0xFF676767), fontSize: 16)),
                      ))
                ],
              ))
        ],
      ),
    );

    return widget.isOpen
        ? container
        : new InkWell(
            child: container,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewsOpenScreen(widget.item)));
            });
  }
}
