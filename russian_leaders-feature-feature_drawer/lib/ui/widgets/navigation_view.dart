import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:russian_leaders/theme.dart';

class NavigationIcon extends StatelessWidget {
  bool isBackIcon;
  Function onTap;

  NavigationIcon({this.isBackIcon = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Center(
          child: isBackIcon
              ? SvgPicture.asset('assets/drawer_back.svg')
              : Image.asset('assets/drawer_icon.png', width: 18,),
        ),
      ),
    );
  }
}

class AppScreenTitle extends StatelessWidget {
  String _title;

  AppScreenTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_title,
          style: TextStyle(
              color: AppColors.appTitle,
              fontSize: 18,
              fontWeight: FontWeight.bold)),
    );
  }
}
