import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final Function onPressed;
  final Widget child;

  RoundedButton({
    this.label = 'Кнопка',
    this.icon,
    this.color = Colors.black,
    this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[
      Text(
        label,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 9),
      )
    ];
    if (icon != null) {
      widgets.insert(
          0,
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ));
    }

    return Container(
      child: FlatButton(
        onPressed: onPressed ?? null,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: child != null
            ? child
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widgets,
              ),
      ),
    );
  }
}
