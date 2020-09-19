import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/widgets/news/news_feature.dart';
import 'package:rsv_mobile/widgets/news/news_list_item.dart';
import 'package:rsv_mobile/widgets/text.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:rsv_mobile/repositories/news.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Heading('Новости', arrow: false),
          Expanded(
            child: Consumer<NewsRepository>(
              builder: (context, news, child) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await news.getNews();
                  },
                  child: news.items == null
                      ? ListView()
                      : ListView.builder(
                          padding: Margin.all(context),
                          itemCount: news.items.length,
                          itemBuilder: (context, i) {
                            return i == 0
                                ? NewsFeature(news.items[i])
                                : NewsListItem(news.items[i]);
                          }),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
