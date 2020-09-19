import 'package:flutter/material.dart';

class ConfirmationDescription extends StatefulWidget {
  final String description;

  ConfirmationDescription(this.description);

  @override
  _ConfirmationDescriptionState createState() =>
      _ConfirmationDescriptionState();
}

class _ConfirmationDescriptionState extends State<ConfirmationDescription>
    with TickerProviderStateMixin {
  bool collapsed = true;
  AnimationController iconRotationController;

  @override
  void initState() {
    super.initState();
    iconRotationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
        upperBound: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              collapsed = !collapsed;
            });
            if (collapsed) {
              iconRotationController.reverse(from: 0.5);
            } else {
              iconRotationController.forward(from: 0.0);
            }
          },
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: Text(
                  'Подробности',
                  style:
                      TextStyle(fontSize: 16, color: const Color(0xFF979797)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4.0),
                child: RotationTransition(
                  turns: iconRotationController,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: const Color(0xFF979797),
                  ),
                ),
              )
            ],
          ),
        ),
        AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: Container(
            child: collapsed
                ? null
                : Text(
                    widget.description,
                    style: TextStyle(fontSize: 16),
                    softWrap: true,
                  ),
          ),
        )

//        AnimatedSize(
//          duration: Duration(seconds: 1),
//          child: Container(
//            constraints: collapsed
//                ? BoxConstraints(maxHeight: 0.0)
//                : BoxConstraints(maxHeight: double.infinity),
//            color: Colors.orange,
//            child: Text("Just some text Lorem Ipsum Dolar Sit"),
//          ),
//          vsync: this,
//        )
      ],
    );
  }
}
