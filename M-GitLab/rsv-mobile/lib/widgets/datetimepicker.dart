import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeDialogScreen extends StatefulWidget {
  final String title;
  final String actionText;
  final DateTime date;
  final DateTime minimumDate;
  final DateTime maximumDate;

  DateTimeDialogScreen(
      {this.title = '',
      this.actionText = '',
      this.minimumDate,
      this.maximumDate,
      this.date});

  @override
  DateTimeDialogScreenState createState() => new DateTimeDialogScreenState();
}

class DateTimeDialogScreenState extends State<DateTimeDialogScreen> {
  DateTime _selectedDate;
  DateTime initialDateTime;
  DateTime minimumDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date ?? new DateTime.now();
    initialDateTime = _selectedDate == null
        ? widget.minimumDate
        : _selectedDate.isBefore(widget.minimumDate)
            ? widget.minimumDate
            : _selectedDate;
    minimumDate = widget.minimumDate.subtract(Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
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
                    Navigator.of(context).pop(null);
                  },
                ),
              ),
            ),
            Expanded(
              child: Center(
                  child: Text(widget.title,
                      style: TextStyle(
                          color: Color(0xFF2A2A2A),
                          fontWeight: FontWeight.w600,
                          fontSize: 17))),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: MaterialButton(
                  onPressed: () {
                    if (_selectedDate
                        .isAfter(minimumDate.add(Duration(days: 1)))) {
                      Navigator.of(context).pop(_selectedDate);
                    } else {
                      print('date is before minimnum');
                    }
                  },
                  child: Text(
                    widget.actionText,
                    style: TextStyle(
                        color: Color(0xFF1184ED),
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        child: CupertinoDatePicker(
          onDateTimeChanged: (DateTime newDate) {
            _selectedDate = newDate;
          },
          use24hFormat: true,
          mode: CupertinoDatePickerMode.dateAndTime,
          initialDateTime: initialDateTime,
          minimumDate: minimumDate,
          maximumDate: widget.maximumDate,
        ),
      ),
    );
  }
}

class DateInput extends StatefulWidget {
  final DateTime date;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final String labelText;
  final TextStyle labelStyle;
  final Function onChange;

  DateInput({
    this.labelText,
    this.labelStyle,
    this.onChange,
    this.date,
    this.minimumDate,
    this.maximumDate,
  });

  @override
  _DateInputState createState() => _DateInputState();

  static Future<DateTime> openChangeTimeDialog(
    context, {
    DateTime minimumDate,
    DateTime maximumDate,
    DateTime date,
  }) async {
    return Navigator.of(context).push(new MaterialPageRoute<DateTime>(
        builder: (BuildContext context) {
          return new DateTimeDialogScreen(
            title: 'Выбор даты',
            actionText: 'Сохранить',
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            date: date,
          );
        },
        fullscreenDialog: true));
  }
}

class _DateInputState extends State<DateInput> {
  DateTime _selectedDate;
  TextStyle labelStyle;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date ?? new DateTime.now();
    if (widget.labelStyle != null) {
      labelStyle = widget.labelStyle;
    } else {
      labelStyle = (widget.onChange == null)
          ? TextStyle(fontSize: 15, color: Color(0xFF8F9398))
          : TextStyle(
              fontSize: 15,
              color: Color(0xFF1184ED),
              fontWeight: FontWeight.w600);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onChange == null
          ? null
          : () async {
              var date = await DateInput.openChangeTimeDialog(
                context,
                minimumDate: widget.minimumDate,
                maximumDate: widget.maximumDate,
                date: _selectedDate,
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
                widget.onChange(date);
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: const Color(0xFFF2F2F2)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.labelText,
              style: labelStyle,
            ),
            Text(
              new DateFormat('dd MMMM y г. HH:mm', 'ru').format(_selectedDate),
              style: widget.labelStyle ?? TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
