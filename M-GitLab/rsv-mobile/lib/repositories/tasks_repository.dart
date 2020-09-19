import 'package:flutter/foundation.dart';
import 'package:rsv_mobile/models/task.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:rxdart/rxdart.dart';

class TasksRepository extends ChangeNotifier {
  NetworkService _networkService;

  TasksRepository(this._networkService);

  final _currentTasksStreamController = BehaviorSubject<List<Task>>();
  Stream<List<Task>> get current => _currentTasksStreamController.stream;

  final _allTasksStreamController = BehaviorSubject<Map<String, List<Task>>>();
  Stream<Map<String, List<Task>>> get all => _allTasksStreamController.stream;

  int _currentMeetingId;
  final _meetingTasksStreamController = BehaviorSubject<List<Task>>();
  Stream<List<Task>> get meetingTasks => _meetingTasksStreamController.stream;

  setMeeting(int id) {
    _currentMeetingId = id;
    var items = tasks.where((v) => v.meetingId == id).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
    _meetingTasksStreamController.sink.add(items);
  }

  List<Task> tasks = [];

  int _groupId;

  set groupId(id) {
    if (_groupId != id) {
      _groupId = id;
      if (_groupId == null) {
        tasks.clear();
        updateTasksLists();
      } else {
        loadTasks();
      }
    }
  }

  createTask(String name, String description, DateTime date,
      {int meetingId}) async {
    await _networkService.createTask({
      'name': name,
      'description': description,
      'meeting_id': meetingId,
      'deadline': date.toUtc().toIso8601String(),

      'group_id': _groupId,
    });
    tasks.add(Task(null, name, description, false, DateTime.now(), date.toLocal(), meetingId));
    loadTasks();
    updateTasksLists();
  }

  updateTask(Task task, String name, String description, DateTime date) async {
    await _networkService.updateTask({
      'task_id': task.id,
      'name': name,
      'description': description,
      'deadline': date.toUtc().toIso8601String(),
    });
    task.name = name;
    task.description = description;
    task.deadline = date.toLocal();
    loadTasks();
  }

  toggleCompleted(Task task) async {
    Map res;
    try {
      res = await _networkService.updateTask({
        'task_id': task.id,
        'completed': !task.completed,
      });
    } catch (e) {
      return false;
    }
    if (res['status'] == 'error') {
      throw TaskUpdateException('Задача не может быть изменена, т.к. она создана не вами.');
    }
    task.completed = !task.completed;
    updateTasksLists();
    return true;
  }

  remove(Task task) async {
    try {
      await _networkService.removeTask(task.id);
    } catch (e) {
      return false;
    }
    tasks.remove(task);
    updateTasksLists();
    loadTasks();
    return true;
  }

  loadTasks() async {
    if (_groupId == null) {
      throw Exception('Unable load tasks for group: $_groupId');
    }
    Map data = await _networkService.getTasks(_groupId);
    tasks = (data['tasks'] as List).map<Task>((v) => Task.fromJson(v)).toList();
    updateTasksLists();
  }

  updateTasksLists() {
    var now = new DateTime.now();
    var today = new DateTime(now.year, now.month, now.day);

    var current = tasks
        .where((v) => !v.completed && v.deadline.isAfter(today))
        .toList()
          ..sort((a, b) => a.deadline.compareTo(b.deadline));
    _currentTasksStreamController.sink.add(current);

    _allTasksStreamController.sink.add({
      'current': current,
      'failed': tasks
          .where((v) => !v.completed && v.deadline.isBefore(today))
          .toList()
            ..sort((a, b) => b.deadline.compareTo(a.deadline)),
      'completed': tasks.where((v) => v.completed).toList()
        ..sort((a, b) => b.deadline.compareTo(a.deadline))
    });
    setMeeting(_currentMeetingId);
  }

  @override
  void dispose() {
    _currentTasksStreamController.close();
    _allTasksStreamController.close();
    _meetingTasksStreamController.close();
    super.dispose();
  }
}

class TaskUpdateException implements Exception {
  String cause;
  TaskUpdateException(this.cause);
}