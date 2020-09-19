import 'package:flutter/cupertino.dart';
import 'package:rsv_mobile/models/news_item.dart';
import 'package:rsv_mobile/services/network.dart';

class NewsRepository extends ChangeNotifier {
  NetworkService _networkService;
  List<NewsItem> items;

  NewsRepository(this._networkService) {
    getNews();
  }

  Future<List<NewsItem>> getNews({bool fromServer = false}) async {
    var data = await _networkService.getNews();
    items = data['list'].map<NewsItem>((v) => NewsItem.fromJson(v)).toList();
    notifyListeners();
    return items;
  }
}
