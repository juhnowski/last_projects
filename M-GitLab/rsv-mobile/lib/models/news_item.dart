class NewsItem {
  final int id;
  final String title;
  final String preview;
  final String content;
  final List hashTags;
  final DateTime createdAt;

  NewsItem({
    this.id,
    this.title,
    this.preview,
    this.content,
    this.hashTags,
    this.createdAt,
  });

  factory NewsItem.fromJson(Map json) {
    return NewsItem(
      id: json['id'],
      title: json['title'],
      preview: json['preview'],
      content: json['text'],
      hashTags: json['hashtags'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          (json['createdAt'] as int) * 1000),
    );
  }
}
