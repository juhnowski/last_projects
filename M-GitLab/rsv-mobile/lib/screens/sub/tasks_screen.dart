import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/task.dart';
import 'package:rsv_mobile/repositories/tasks_repository.dart';
import 'package:rsv_mobile/screens/sub/add_task.dart';
import 'package:rsv_mobile/widgets/home/backgrounded_scaffold.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:rxdart/subjects.dart';

class TasksScreen extends StatelessWidget {
  final failColor = Color(0xFFEF627D);
  final completeColor = Color(0xFF1184ED);

  @override
  Widget build(BuildContext context) {
    return BackgroundedScaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Text('Задачи'),
            Expanded(
              child: Container(),
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Color(0xff3AA0FD),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTaskScreen()));
              },
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<TasksRepository>(
            builder: (context, tasksRepository, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await tasksRepository.loadTasks();
            },
            child: StreamBuilder<Map<String, List<Task>>>(
                stream: tasksRepository.all,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, List<Task>>> snapshot) {
                  if (!snapshot.hasData) {
                    return ListView();
                  } else {
                    var current = snapshot.data['current'];
                    var completed = snapshot.data['completed'];
                    var failed = snapshot.data['failed'];

                    var failedStartIndex = current.length + 1;
                    var completedStartIndex =
                        failedStartIndex + failed.length + 1;
                    var itemCount = completedStartIndex + completed.length + 1;

                    return ListView.builder(
                      padding: Margin.all(context),
                      itemCount: itemCount,
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          var items = <Widget>[
                            TasksSubtitle('Предстоящие', current.length),
                          ];
                          if (current.length == 0) {
                            items.add(Center(
                                child: Text('Список пуст',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey,
                                        height: 3))));
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 8, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: items,
                            ),
                          );
                        } else if (i < failedStartIndex) {
                          return TaskItem(current[i - 1]);
                        } else if (i == failedStartIndex) {
                          var items = <Widget>[
                            TasksSubtitle('Пропущенные', failed.length,
                                color: failColor),
                          ];
                          if (failed.length == 0) {
                            items.add(Center(
                                child: Text('Список пуст',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey,
                                        height: 3))));
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 8, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: items,
                            ),
                          );
                        } else if (i < completedStartIndex) {
                          return TaskItem(failed[i - failedStartIndex - 1],
                              color: failColor);
                        } else if (i == completedStartIndex) {
                          var items = <Widget>[
                            TasksSubtitle('Выполненые', completed.length,
                                color: completeColor),
                          ];
                          if (completed.length == 0) {
                            items.add(Center(
                                child: Text('Список пуст',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey,
                                        height: 3))));
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 8, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: items,
                            ),
                          );
                        } else {
                          return TaskItem(
                            completed[i - completedStartIndex - 1],
                            color: completeColor,
                          );
                        }
                      },
                    );
                  }
                }),
          );
        }),
      ),
    );
  }
}

class TasksSubtitle extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  TasksSubtitle(this.title, this.count, {this.color});

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[
      Text(
        title,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black),
      ),
    ];
    if (count > 0) {
      items.add(Chip(
        backgroundColor: color ?? Color(0xFFF1F1F1),
        label: Text(
          count.toString(),
          style: TextStyle(
              fontSize: 11, color: color != null ? Colors.white : Colors.black),
        ),
      ));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: items);
  }
}

class TaskItem extends StatefulWidget {
  final Task task;
  final Color color;
  final int maxLines;

  TaskItem(this.task,
      {this.color = const Color(0xFF2A2A2A), this.maxLines = 2});

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool toggling = false;
  bool isToday;
  final deleteConfirmationSubject = new PublishSubject<bool>();

  formattedDate() {
    var now = new DateTime.now();
    var today = new DateTime(now.year, now.month, now.day);
    var deadline = widget.task.deadline;
    deadline = new DateTime(deadline.year, deadline.month, deadline.day);

//    var diff = deadline.difference(today).inDays;

    return deadline.millisecondsSinceEpoch == today.millisecondsSinceEpoch
        ? new DateFormat.Hm('ru').format(widget.task.deadline)
//        ? new DateFormat('y.MM.dd HH:mm').format(widget.task.deadline)
        : new DateFormat.yMd('ru').format(widget.task.deadline);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (DismissDirection direction) async {
        return await deleteConfirmationSubject.stream.first;
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<TasksRepository>(context, listen: false)
            .remove(widget.task);
      },
      key: ValueKey(widget.task.id.toString()),
      background: Container(),
      secondaryBackground: Container(
        padding: EdgeInsets.only(bottom: 15, left: 20),
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            deleteConfirmationSubject.add(true);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  'Удалить задачу?',
                  style: TextStyle(color: Color(0xFFEF627D)),
                ),
              ),
              Icon(
                Icons.delete_forever,
                color: Color(0xFFEF627D),
              ),
            ],
          ),
        ),
      ),
      child: Container(
//        decoration: BoxDecoration(
//          color: Colors.white,
//        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      toggling
                          ? Padding(
                              padding: EdgeInsets.all(13),
                              child: SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            widget.color),
                                    strokeWidth: 2,
                                  )))
                          : Checkbox(
                              value: widget.task.completed,
                              activeColor: widget.color,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (v) async {
                                if (toggling) {
                                  return;
                                }
                                setState(() {
                                  toggling = true;
                                });
                                bool success = false;
                                try {
                                  success =
                                  await Provider.of<TasksRepository>(context,
                                      listen: false)
                                      .toggleCompleted(widget.task);
                                } on TaskUpdateException catch (e) {
                                  print(e.cause);
                                  Flushbar(
                                    title:  'Задача: ${widget.task.name}',
                                    message:  e.cause,
                                    duration:  Duration(seconds: 3),
                                  )..show(context);
                                }
                                if (success) {
                                  setState(() {
                                    toggling = false;
                                  });
                                } else {
                                  new Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    setState(() {
                                      toggling = false;
                                    });
                                  });
                                }
                              }),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddTaskScreen(
                                          task: widget.task,
                                        )));
                          },
                          child: Text(
                            widget.task.name.substring(0, 1).toUpperCase() +
                                widget.task.name.substring(1).toLowerCase(),
                            style: TextStyle(
                              fontSize: FontSize.subtitle(),
                              color: widget.color,
                            ),
                            maxLines: widget.maxLines,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  formattedDate(),
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.color,
                  ),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
