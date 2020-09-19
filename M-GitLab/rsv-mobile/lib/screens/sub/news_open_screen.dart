import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rsv_mobile/models/news_item.dart';
import 'package:rsv_mobile/widgets/news/news_feature.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class NewsOpenScreen extends StatelessWidget {
  final NewsItem item;

  NewsOpenScreen(this.item);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/homebg.png'),
                fit: BoxFit.cover),
            color: Colors.white),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            elevation: 0.8,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
            title: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                new Text('Новости',
                    style: new TextStyle(color: Color(0xff1184ED))),
              ],
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: Margin.all(context),
//              shrinkWrap: false,
              children: <Widget>[
                new NewsFeature(item, isOpen: true),
                new HtmlWidget(
                  item.content,
                  webView: true,
                  webViewJs: true,
                )
              ],
            ),
          ),
        ));
  }
}
