import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:russian_leaders/bloc/login/bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Login Page'),
            MaterialButton(
              onPressed: (){BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed("sss", "ssss"));},
              child: Text('Send Login'),
            )
          ],
        ),
      ),
    );
  }
}
