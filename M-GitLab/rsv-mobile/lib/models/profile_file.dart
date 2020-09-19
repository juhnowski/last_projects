import 'package:filesize/filesize.dart';

class ProfileFile {
  int id;
  String url;
  String name;
  int size;

  String get fileSize => filesize(size);

  ProfileFile(Map file) {
    id = file['id'];
    url = file['url'];
    name = file['name'];
    size = file['size'];
  }

  toMap() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'size': size,
    };
  }
}
