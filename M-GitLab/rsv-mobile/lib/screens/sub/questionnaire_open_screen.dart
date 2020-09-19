import 'package:flutter/material.dart';
import 'package:rsv_mobile/widgets/home/backgrounded_scaffold.dart';
import 'package:rsv_mobile/utils/adaptive.dart';

class QuestionnareOpenScreen extends StatefulWidget {
  @override
  QuestionnareOpenScreenState createState() =>
      new QuestionnareOpenScreenState();
}

class QuestionnareOpenScreenState extends State<QuestionnareOpenScreen> {
  int _radioValue1 = 1;
  int _radioValue2 = 1;
  int _radioValue3 = 1;
  int _radioValue4 = 1;

  void _handleRadioValueChange1(int i) {
    setState(() {
      _radioValue1 = i;
    });
  }

  void _handleRadioValueChange2(int i) {
    setState(() {
      _radioValue2 = i;
    });
  }

  void _handleRadioValueChange3(int i) {
    setState(() {
      _radioValue3 = i;
    });
  }

  void _handleRadioValueChange4(int i) {
    setState(() {
      _radioValue4 = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundedScaffold(
      appBar: AppBar(
        title: Text('Опросы'),
      ),
      body: Container(
          child: ListView(
        padding: Margin.all(context, def: 20),
        children: <Widget>[
          Text(
            'Уважаемые участники программы «Я-наставник!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          Container(
              margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Text(
                  'Прошло 2 месяца с момента страта программы. Пожалуйста, ответьте на несколько вопросов анкеты. С помощью Ваших ответов мы сможем спланировать качественную поддержку и сопровождение программы наставничества.')),
          Text('Просим заполнить анкету до 11.02.2019.'),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('1. В этой программе я:'),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: _radioValue1,
                      onChanged: _handleRadioValueChange1,
                    ),
                    Text('Наставник')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 2,
                      groupValue: _radioValue1,
                      onChanged: _handleRadioValueChange1,
                    ),
                    Text('Наставляемый')
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    '2. Сколько раз с момента запуска программы Вы встречались со своей парой?'),
                TextField()
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('3. Какие отношения сложилисьв Вашей паре:'),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: _radioValue2,
                      onChanged: _handleRadioValueChange2,
                    ),
                    Text('Очень хорошние')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 2,
                      groupValue: _radioValue2,
                      onChanged: _handleRadioValueChange2,
                    ),
                    Text('Хорошие')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 3,
                      groupValue: _radioValue2,
                      onChanged: _handleRadioValueChange2,
                    ),
                    Text('Cредние')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 4,
                      groupValue: _radioValue2,
                      onChanged: _handleRadioValueChange2,
                    ),
                    Text('Есть недопонимание')
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('4. Влияние данной программына Вас:'),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: _radioValue3,
                      onChanged: _handleRadioValueChange3,
                    ),
                    Text('Позитивное')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 2,
                      groupValue: _radioValue3,
                      onChanged: _handleRadioValueChange3,
                    ),
                    Text('Очень позитивное')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 3,
                      groupValue: _radioValue3,
                      onChanged: _handleRadioValueChange3,
                    ),
                    Text('Не ощущаю влияния')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 4,
                      groupValue: _radioValue3,
                      onChanged: _handleRadioValueChange3,
                    ),
                    Text('Негативное воздействие')
                  ],
                ),
//                    Row(
//                      children: <Widget>[
//                        Radio(
//                          value: 5,
//                          groupValue: _radioValue3,
//                          onChanged: _handleRadioValueChange3,
//                        ),
//                        Text('Испытываю трудности с продолжением участия')
//                      ],
//                    )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    '5. Произошли ли с момента участия в программе значительные изменения в Вашей жизни? (значимое событие, прогресс или новый этап в личностном или карьерном развитии).'),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: _radioValue4,
                      onChanged: _handleRadioValueChange4,
                    ),
                    Text('Нет')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 2,
                      groupValue: _radioValue4,
                      onChanged: _handleRadioValueChange4,
                    ),
                    Text('Да')
                  ],
                ),
                TextField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Подробный ответ',
                      labelText: 'Опишите подробнее'),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
