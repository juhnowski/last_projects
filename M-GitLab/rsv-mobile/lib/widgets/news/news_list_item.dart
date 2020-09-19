import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rsv_mobile/models/news_item.dart';
import 'package:rsv_mobile/screens/sub/news_open_screen.dart';

class NewsListItem extends StatefulWidget {
  final NewsItem item;

  NewsListItem(this.item);

  @override
  _NewsListItemState createState() => _NewsListItemState();
}

class _NewsListItemState extends State<NewsListItem> {
  String _strDate;

  @override
  void initState() {
    super.initState();
    this._strDate =
        new DateFormat('dd.MM.yyyy', 'ru').format(widget.item.createdAt);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 80.0,
        margin: EdgeInsets.only(bottom: 24),
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                ClipRRect(
                    child: FadeInImage(
                      image: CachedNetworkImageProvider(widget.item.preview),
                      placeholder: AssetImage('assets/images/image.png'),
                      width: 80.00,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                new Expanded(
                  child: new Container(
                    // color: Colors.white,
                    padding: new EdgeInsets.only(left: 15.0),
                    child: new Column(
                      children: <Widget>[
                        new Align(
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            widget.item.title,
                            style: new TextStyle(
                                fontSize: 18.0, color: Color(0xFF2A2A2A)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        new Expanded(child: new Container()),
                        new Container(
                            child: new Align(
                          alignment: Alignment.centerLeft,
                          child: new Text(_strDate,
                              style: new TextStyle(
                                  color: Color(0xFF676767), fontSize: 16.0)),
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsOpenScreen(widget.item)));
          },
        ));
  }
}
