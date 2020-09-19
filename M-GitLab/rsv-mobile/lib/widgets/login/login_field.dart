import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final TextEditingController loginController;
  final String loginError;
  LoginField({this.loginController, this.loginError});

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: new Theme(
            data: new ThemeData(
                primaryColor: Theme.of(context).primaryColor,
                textSelectionColor: Theme.of(context).primaryColor),
            child: new TextField(
                keyboardType: TextInputType.emailAddress,
                controller: loginController,
                decoration: new InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                  errorText: loginError,
                  labelText: 'Email или телефон',
                  //hintText: 'Email или телефон'
                ))));
  }
}
