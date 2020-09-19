import 'package:rsv_mobile/services/network.dart';

class Group {
  List<int> students = [];
  List<int> leaders = [];
  int _groupId;
  int leaderId;
  int studentId;
  int curatorId;

  int get id => _groupId;

  List<int> get memberIds =>
      [leaders, students].expand((x) => x).map<int>((v) => v).toList();

  Future<List<int>> loadGroup(
      NetworkService network, int userId, int groupId) async {
    _groupId = groupId;
    List pairs = (await network.getGroupPairs(groupId))['pairs'];

    List<int> studentIds = [];
    List<int> leaderIds = [];
    pairs.forEach((pair) {
      if (pair['studentId'] == userId || pair['leaderId'] == userId) {
        leaderId = pair['leaderId'];
        studentId = pair['studentId'];
      }
      studentIds.add(pair['studentId']);
      leaderIds.add(pair['leaderId']);
    });

    students = studentIds;
    leaders = leaderIds;

    try {
      curatorId = (await network.getGroup(groupId))['group']['curator'];
      print('curatorId $curatorId');
    } catch (e) {
      print(e);
    }

    return memberIds;
  }
}
