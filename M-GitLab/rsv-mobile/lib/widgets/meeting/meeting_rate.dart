import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/activities/activity.dart';
import 'package:rsv_mobile/models/activities/meeting.dart';
import 'package:rsv_mobile/models/cms/activities.dart';
import 'package:rsv_mobile/widgets/meeting/rate.dart';

class RateMeeting extends StatefulWidget {
  final TextStyle titleStyle;
  final double buttonHeight;
  final double buttonRadius;
  final TextStyle buttonTextStyle;
  final Meeting meeting;
  final Function onRate;
  final bool withDate;

  RateMeeting(
    this.meeting, {
    this.titleStyle = const TextStyle(
      fontSize: 18,
      color: Color(0xFF2A2A2A),
      fontWeight: FontWeight.w600,
    ),
    this.buttonHeight = 48.0,
    this.buttonRadius = 8.0,
    this.withDate = false,
    this.onRate,
    this.buttonTextStyle = const TextStyle(fontSize: 16),
  }) {
    print('rate for ${meeting.id}');
  }

  RateMeeting.small(Meeting meeting)
      : this(
          meeting,
          titleStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xFF2A2A2A),
          ),
          buttonHeight: 32.0,
          buttonRadius: 32.0,
          buttonTextStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        );

  @override
  _RateMeetingState createState() => _RateMeetingState();
}

class _RateMeetingState extends State<RateMeeting> {
  int rating;
  bool canChangeRating;

  @override
  void initState() {
    super.initState();
    rating = widget.meeting.rating;
    canChangeRating = widget.meeting.status == ActivityStatus.missed;
  }

  _setRating(int v) {
    setState(() {
      rating = v;
    });
  }

  _confirm() async {
    if (rating != null) {
      if (rating != widget.meeting.rating) {
        var newStatus = await Provider.of<Activities>(context, listen: false)
            .rateActivity(widget.meeting, rating);
        setState(() {
          canChangeRating = newStatus == ActivityStatus.missed;
        });
        if (widget.onRate != null) {
          widget.onRate();
        }
        print('updated status: ${describeEnum(newStatus)}');
      } else {
        canChangeRating = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.meeting.rating != null && widget.meeting.rating > 0)
        ? _displayRating()
        : (canChangeRating) ? _changeRating() : _rateWidget();
  }

  Widget _changeRating() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: Text(
              'Встреча не состоялась',
              style: widget.titleStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          child: OutlineButton(
            onPressed: () {
              setState(() {
                canChangeRating = false;
              });
            },
            child: Text(
              'Изменить решение',
              style: TextStyle(
                  color: Color(0xFF1184ED),
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
            textColor: Colors.white,
            borderSide: BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.buttonRadius)),
          ),
        ),
      ],
    );
  }

  Widget _displayRating() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: Text(
              'Ваша оценка встречи',
              style: widget.titleStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          child: RatingSmile.forRate(rating, rating),
        ),
      ],
    );
  }

  Widget _rateWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: Text(
              (widget.withDate
                  ? 'Оцените встречу, состоявшуюся ${new DateFormat('dd.MM.y HH:mm').format(widget.meeting.dateTime)}'
                  : 'Оцените прошедшую встречу'),
              style:
                  widget.withDate ? widget.titleStyle : TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.only(bottom: 24),
            child: SmilesRow(50, true, rating, onChange: _setRating)),
        Container(
          margin: EdgeInsets.only(bottom: 24),
          child: Center(
            child: GestureDetector(
              onTap: () {
                _setRating(0);
                _confirm();
              },
              child: Text(
                'Встреча не состоялась',
                style: TextStyle(
                    color: Color(0xFF1184ED),
                    decoration: TextDecoration.underline,
                    fontSize: 16),
              ),
            ),
          ),
        ),
        Container(
          child: MaterialButton(
            onPressed: _confirm,
            child: Text('Подтвердить', style: widget.buttonTextStyle),
            color: Color(0xff1184ED),
            textColor: Colors.white,
            height: widget.buttonHeight,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.buttonRadius)),
          ),
        ),
      ],
    );
  }
}
