import 'package:intl/intl.dart';
import 'package:rsv_mobile/models/profile_file.dart';

class ChatRoomMessage {
  String id;
  String text;
  int authorId;
  DateTime createdAt;
  bool hasBeenRead = false;
  bool isNew;
  List<ProfileFile> attachments;

  get isMine => false;

  String get messageTime => (new DateFormat('HH:mm')).format(createdAt);

  ChatRoomMessage(
      {this.id,
      this.text,
      this.authorId,
      this.createdAt,
      this.isNew,
      this.hasBeenRead,
      List<Map> attachments}) {
    if (attachments != null) {
      this.attachments =
          attachments.map<ProfileFile>((v) => ProfileFile(v)).toList();
    }
  }

  factory ChatRoomMessage.fromJson(Map<String, dynamic> json) {
    return ChatRoomMessage(
      id: json['id'],
      text: json['text'],
      authorId: json['author_id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000),
      isNew: json['is_new'],
      attachments: json['attachments']?.cast<Map>() ?? [],
    );
  }
}
