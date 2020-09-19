import 'package:flutter/material.dart';

class SelectUsersButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xfff2f2f2)))),
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Пригласить друзей в сообщество',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                ),
                Text('Выбрать')
              ],
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
