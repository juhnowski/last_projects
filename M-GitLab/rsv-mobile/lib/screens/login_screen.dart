import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:rsv_mobile/widgets/login/login_field.dart';
import 'package:rsv_mobile/widgets/login/password_field.dart';
import 'package:rsv_mobile/utils/adaptive.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _obscureText = true;
  TextEditingController _loginController, _passwordController;
  String _loginError, _passwordError;

  @override
  void initState() {
    _checkAuth();
    super.initState();
    _loginController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: null,
      body: SafeArea(
          child: new Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: new Center(
            child: SingleChildScrollView(
                child: _isLoading ? _loadingScreen() : _loginForm())),
      )),
    );
  }

  Widget _loginForm() {
    return new Form(
        child: new Center(
            child: new Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: Margin.all(context, grid: 6, def: 20),
      height: 420.0,
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0), color: Colors.white),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: new Text(
              'Вход',
              style: new TextStyle(fontWeight: FontWeight.w700, fontSize: 26.0),
            ),
          ),
          new Container(
            margin: EdgeInsets.only(bottom: 15.0),
            child: new LoginField(
              loginController: _loginController,
              loginError: _loginError,
            ),
          ),
          new Container(
            margin: EdgeInsets.only(bottom: 15.0),
            child: new PasswordField(
              passwordController: _passwordController,
              obscureText: _obscureText,
              passwordError: _passwordError,
              togglePassword: _togglePassword,
            ),
          ),
          new SizedBox(
            width: double.infinity,
            child: new MaterialButton(
              color: Color(0xff1184ED),
              textColor: Colors.white,
              child: new Text('Войти',
                  style: new TextStyle(fontWeight: FontWeight.w700)),
              onPressed: () {
                _login();
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              height: 45.0,
            ),
          ),
          Container(
            child: GestureDetector(
              child: Text('Не помню пароль',
                  style: new TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline)),
              onTap: () {
                _forgotPassword();
              },
            ),
            padding: EdgeInsets.only(top: 20.0),
          )
        ],
      ),
    )));
  }

  Widget _loadingScreen() {
    return new Container(
        margin: const EdgeInsets.only(top: 100.0),
        child: new Center(
            child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation(Color(0xff1184ED)),
                strokeWidth: 4.0),
            new Container(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                'Пожалуйста подождите',
                style: new TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            )
          ],
        )));
  }

  _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  _forgotPassword() async {
    const url = 'https://auth.rsv.ru/reset-password/init/form';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _checkAuth() {
    _showLoading();
    if (Provider.of<NetworkService>(context, listen: false).isLoggedIn) {
      Navigator.popAndPushNamed(context, '/main');
    } else {
      _hideLoading();
    }
  }

  _valid() {
    bool valid = true;

    if (_loginController.text.isEmpty) {
      valid = false;
      _loginError = "Необходимо ввести логин";
    }

    if (_passwordController.text.isEmpty) {
      valid = false;
      _passwordError = "Необходимо ввести пароль";
    }
    return valid;
  }

  _login() async {
    _showLoading();
    if (_valid()) {
      try {
        await Provider.of<NetworkService>(context, listen: false)
            .authLogin(_loginController.text, _passwordController.text);
      } catch (e) {
        _scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: new Text('$e')));
      }
      _checkAuth();
    } else {
      _hideLoading();
    }
  }
}
