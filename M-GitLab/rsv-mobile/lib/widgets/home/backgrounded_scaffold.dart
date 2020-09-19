import 'package:flutter/material.dart';

class BackgroundedScaffold extends StatelessWidget {
  AppBar _appBar;
  Widget _body;
  Color _bgColor;

  BackgroundedScaffold(
      {AppBar appBar, Widget body, Color bgColor = Colors.white}) {
    this._bgColor = bgColor;
    this._appBar = appBar;
    this._body = body;
  }
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/homebg.png'),
                fit: BoxFit.cover),
            color: this._bgColor),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _appBar,
            body: SafeArea(child: _body)));
  }
}
