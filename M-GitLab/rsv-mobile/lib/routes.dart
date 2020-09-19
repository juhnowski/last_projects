import 'package:flutter/material.dart';
import 'package:rsv_mobile/screens/home/materials_screen.dart';
import 'package:rsv_mobile/screens/login_screen.dart';
import 'package:rsv_mobile/screens/main_screen.dart';

final appRoutes = {
  '/main': (BuildContext context) => new MainScreen(),
  '/login': (BuildContext context) => new LoginScreen(),
  '/files': (BuildContext context) => new MaterialsScreen(),
};
