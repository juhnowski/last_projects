import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/task.dart';
import 'package:rsv_mobile/repositories/tasks_repository.dart';
import 'package:rsv_mobile/widgets/home/backgrounded_scaffold.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:rsv_mobile/widgets/datetimepicker.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;
  final bool readonly;
  final int meetingId;

  AddTaskScreen({this.readonly = false, this.task, this.meetingId});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController taskNameController = new TextEditingController();
  TextEditingController taskDescriptionController = new TextEditingController();
  String taskNameError;
  String taskDescriptionError;
  DateTime _taskDate = new DateTime.now();
  DateTime _now = new DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      taskNameController.text = widget.task.name;
      taskDescriptionController.text = widget.task.description;
      _taskDate = widget.task.deadline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundedScaffold(
      appBar: AppBar(
          titleSpacing: 0.0,
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: widget.task != null
                      ? Text('Задача',
                          style: TextStyle(
                              color: Color(0xFF2A2A2A),
                              fontWeight: FontWeight.w600,
                              fontSize: 17))
                      : Text('Новая задача',
                          style: TextStyle(
                              color: Color(0xFF2A2A2A),
                              fontWeight: FontWeight.w600,
                              fontSize: 17)),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: MaterialButton(
                    onPressed: () {
                      saveTask();
                    },
                    child: Text(
                      'Сохранить',
                      style: TextStyle(
                          color: Color(0xFF1184ED),
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
              )
            ],
          )),
      body: Container(
        padding: Margin.all(context, def: 20),
        decoration: BoxDecoration(
//          color: Color.fromRGBO(255, 255, 255, 0.3),
          gradient: new LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 0)
              ],
//              colors: [Colors.red, Colors.blue, Colors.yellow],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.35, 0.75, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: taskNameController,
                readOnly: widget.readonly,
                decoration: InputDecoration(
                    labelText: 'Задача',
                    hintText: 'Название задачи',
                    errorText: taskNameError),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: taskDescriptionController,
                  readOnly: widget.readonly,
                  maxLines: null,
                  minLines: 4,
                  decoration: InputDecoration(
                      labelText: 'Описание', errorText: taskDescriptionError),
                  keyboardType: TextInputType.multiline,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DateInput(
                  onChange: widget.readonly
                      ? null
                      : (DateTime newDate) {
                          _taskDate = newDate;
                        },
                  labelText: 'Срок выполнения',
                  minimumDate: widget.task != null
                      ? _taskDate
                      : _now.subtract(Duration(days: 1)),
                  maximumDate: DateTime(_now.year + 1, _now.month, _now.day),
                  date: widget.task != null ? widget.task.deadline : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  createTask() {
    if (_valid()) {
      String taskName = taskNameController.text.toString();
      String taskDescription = taskDescriptionController.text.toString();
      Provider.of<TasksRepository>(context, listen: false).createTask(
          taskName, taskDescription, _taskDate,
          meetingId: widget.meetingId);
      Navigator.pop(context);
    }
  }

  updateTask() {
    if (_valid()) {
      String taskName = taskNameController.text.toString();
      String taskDescription = taskDescriptionController.text.toString();
      Provider.of<TasksRepository>(context, listen: false).updateTask(
          widget.task, taskName, taskDescription, _taskDate);
      Navigator.pop(context);
    }
  }

  saveTask() {
    if (widget.task != null) {
      updateTask();
    } else {
      createTask();
    }
  }

  _valid() {
    if (taskNameController.text.isEmpty) {
      setState(() {
        taskNameError = "Необходимо название";
      });
      return false;
    } else
      return true;
  }
}
