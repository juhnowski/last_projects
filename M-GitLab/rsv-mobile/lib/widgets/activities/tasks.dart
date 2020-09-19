import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/task.dart';
import 'package:rsv_mobile/repositories/tasks_repository.dart';
import 'package:rsv_mobile/screens/sub/add_task.dart';
import 'package:rsv_mobile/screens/sub/tasks_screen.dart';

class ActivityTasks extends StatelessWidget {

  final int meetingId;

  ActivityTasks(this.meetingId);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 32),
      padding: EdgeInsets.only(top: 24, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xffdddddd),
            offset: Offset(0.0, 0.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Text('Ближайшие задачи',
              style: TextStyle(color: Color(0xff2A2A2A), fontSize: 16)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 14.0),
            child: new MaterialButton(
              color: Color(0xff1184ED),
              textColor: Colors.white,
              child: new Text('Создать задачу',
                  style: new TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddTaskScreen(meetingId: meetingId)));
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
              height: 32.0,
            ),
          ),
          SizedBox(
            height: 250.0,
            child: Consumer<TasksRepository>(
              builder: (context, tasksRepository, child) {
                return RefreshIndicator(
                  displacement: 0.0,
                  onRefresh: () async {
                    await tasksRepository.loadTasks();
                  },
                  child: StreamBuilder<List<Task>>(
                      stream: tasksRepository.meetingTasks,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Task>> snapshot) {
                        if (!snapshot.hasData || snapshot.data.length == 0) {
                          return child;
                        }
                        return ListView.builder(
                            shrinkWrap: false,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              return TaskItem(
                                snapshot.data[i],
                              );
                            });
                      }),
                );
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Задач пока нет',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}