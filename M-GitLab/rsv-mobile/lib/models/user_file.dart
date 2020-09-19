class UserFile {
  int id;
  String url;
  DateTime createdAt;
  String name;
  int groupId;
  String groupName;
  bool isFavorite = false;
  bool isMine;

  UserFile(Map file, {this.isMine = false}) {
    id = file['id'];
    url = file['url'];
    createdAt = DateTime.parse(file['createdAt']);
    name = file['name'];
    groupId = file['groupId'];
    groupName = file['groupName'];
    isFavorite = file['isFavorite'] ?? false;
  }
}
