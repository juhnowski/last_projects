import 'package:flutter/material.dart';
import 'package:rsv_mobile/widgets/home/questionnaire_item.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:rsv_mobile/widgets/text.dart';

class QuestionnairesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Heading(
            'Опросы',
            arrow: false,
          ),
          Expanded(
              child: Container(
                  child: ListView(
            padding: Margin.all(context, def: 20),
            children: <Widget>[
              QuestionnaireItem(
                  'Первый опрос',
                  'Спланировать качественную поддержку и сопровождение программы наставничества',
                  DateTime(2019, 2, 11),
                  Color(0xff1184ED),
                  QuestionnaireStatus.normal),
              QuestionnaireItem(
                  'Название опроса',
                  'Спланировать качественную поддержку и сопровождение программы наставничества',
                  DateTime(2019, 2, 7),
                  Color(0xffEF627D),
                  QuestionnaireStatus.missed),
              QuestionnaireItem(
                  'Название опроса',
                  'Спланировать качественную поддержку и сопровождение программы наставничества',
                  DateTime(2019, 2, 7),
                  Color(0xff8F9398),
                  QuestionnaireStatus.past),
              QuestionnaireItem(
                  'Первый опрос',
                  'Спланировать качественную поддержку и сопровождение программы наставничества',
                  DateTime(2019, 2, 11),
                  Color(0xff1184ED),
                  QuestionnaireStatus.normal),
            ],
          )))
        ],
      ),
    );
  }
}
