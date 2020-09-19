import 'dart:convert';

enum MembershipType { Leader, Student, GroupMember }

class Member {
  String fullName = '';
  String email;
  String userImage = '';
  String type = '';

  Member(jsonString) {
    Map userMap = jsonDecode(jsonString);
    fullName = userMap['user_name'];
    email = userMap['user_email'];
    userImage = userMap['userImage'];
    type = userMap['type'];
  }

}

List<String> users = [
  '{"user_name" : "Екатерина Файль", "userImage": "https://seafile.rsv.ru:9443/thumbnail/8bef3e29ab5a426587fa/1024/%D0%A4%D0%B0%D0%B9%D0%BB%D1%8C%20%D0%95%D0%BA%D0%B0%D1%82%D0%B5%D1%80%D0%B8%D0%BD%D0%B0.jpg"}',
  '{"user_name" : "Михаил Мартыненков", "userImage": "https://seafile.rsv.ru:9443/thumbnail/46acac74623a458b980f/1024/%D0%9C%D0%B0%D1%80%D1%82%D1%8B%D0%BD%D0%B5%D0%BD%D0%BA%D0%BE%D0%B2%20%D0%9C%D0%B8%D1%85%D0%B0%D0%B8%D0%BB.jpg", "type":"leader"}',
  '{"user_name" : "Артём Ланцев", "userImage": "https://seafile.rsv.ru:9443/thumbnail/e5b0749677e44473bd64/1024/%D0%9B%D0%B0%D0%BD%D1%86%D0%B5%D0%B2%20%D0%90%D1%80%D1%82%D1%91%D0%BC.jpg"}',
  '{"user_name" : "Алекснй Варяница", "userImage": "https://seafile.rsv.ru:9443/thumbnail/35b1873059f244558a10/1024/%D0%92%D0%B0%D1%80%D1%8F%D0%BD%D0%B8%D1%86%D0%B0%20%D0%90%D0%BB%D0%B5%D0%BA%D1%81%D0%B5%D0%B9.jpg"}',
  '{"user_name" : "Надежда Галкина", "userImage": "https://seafile.rsv.ru:9443/thumbnail/bd35eb450985420da022/1024/%D0%93%D0%B0%D0%BB%D0%BA%D0%B8%D0%BD%D0%B0%20%D0%9D%D0%B0%D0%B4%D0%B5%D0%B6%D0%B4%D0%B0.jpg"}',
  '{"user_name" : "Юрий Зобов", "userImage": "https://seafile.rsv.ru:9443/thumbnail/774c63e0798c45cf95b0/1024/%D0%97%D0%BE%D0%B1%D0%BE%D0%B2%20%D0%AE%D1%80%D0%B8%D0%B9.jpg"}',
  '{"user_name" : "Владимир Остроменский", "userImage": "https://seafile.rsv.ru:9443/thumbnail/ca4b965e9f044b04ac9d/1024/%D0%9E%D1%81%D1%82%D1%80%D0%BE%D0%BC%D0%B5%D0%BD%D1%81%D0%BA%D0%B8%D0%B9%20%D0%92%D0%BB%D0%B0%D0%B4%D0%B8%D0%BC%D0%B8%D1%80.jpg"}',
  '{"user_name" : "Юлия Симонова", "userImage": "https://seafile.rsv.ru:9443/thumbnail/e132f8c9fc7941bfbd76/1024/%D0%A1%D0%B8%D0%BC%D0%BE%D0%BD%D0%BE%D0%B2%D0%B0%20%D0%AE%D0%BB%D0%B8%D1%8F.jpg"}',
  '{"user_name" : "Александр Швалев", "userImage": "https://seafile.rsv.ru:9443/thumbnail/30a7f4002add4f39b272/1024/%D0%A8%D0%B2%D0%B0%D0%BB%D0%B5%D0%B2%20%D0%90%D0%BB%D0%B5%D0%BA%D1%81%D0%B0%D0%BD%D0%B4%D1%80.jpg"}',
];
