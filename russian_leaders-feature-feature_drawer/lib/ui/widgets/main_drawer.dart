import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:russian_leaders/theme.dart';

import '../../localizations.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainDrawerState();
}

class MainDrawerState extends State<MainDrawer> {
  int _selectedPosition = 0;

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.of(context).size;
    return SizedBox(
      width: windowSize.width * 0.6,
      child: Drawer(
        child: Container(
          color: Colors.green,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: windowSize.height * 0.2,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset('assets/drawer_logo.svg'),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 9,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, position) {
                      return _drawerItem(position);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(int position) {
    bool selected = position == _selectedPosition;
    String title = "";
    String icon;
    bool dividers = false;
    double marginVertical = 8;
    switch (position) {
      case 0:
        icon = 'assets/drawer_about_club.svg';
        title = AppLocalizations.of(context).drawerAboutClub;
        break;
      case 1:
        icon = 'assets/drawer_results.svg';
        title = AppLocalizations.of(context).drawerResults;
        break;
      case 2:
        icon = 'assets/drawer_projects.svg';
        title = AppLocalizations.of(context).drawerProjects;
        break;
      case 3:
        icon = 'assets/drawer_events.svg';
        title = AppLocalizations.of(context).drawerEvents;
        break;
      case 4:
        icon = 'assets/drawer_news.svg';
        title = AppLocalizations.of(context).drawerNews;
        break;
      case 5:
        icon = 'assets/drawer_club_members.svg';
        title = AppLocalizations.of(context).drawerClubMembers;
        break;
      case 6:
        icon = 'assets/drawer_photos.svg';
        title = AppLocalizations.of(context).drawerPhotos;
        break;
      case 7:
        icon = 'assets/drawer_my_profile.svg';
        title = AppLocalizations.of(context).drawerMyProfile;
        dividers = true;
        marginVertical = 16;
        break;
      case 8:
        icon = 'assets/drawer_contacts.svg';
        title = AppLocalizations.of(context).drawerContacts  ;
        break;
    }

    return DrawerItem(icon, title, position, selected,
        onClick: _itemSelected,
        dividers: dividers,
        marginVertical: marginVertical);
  }

  void _itemSelected(int position) {
    setState(() {
      _selectedPosition = position;
    });
  }
}

class DrawerItem extends StatelessWidget {
  String _icon;
  String _title;
  bool _selected;
  int _position;
  Function(int) onClick;
  double margin = 16;
  double marginVertical = 8;
  bool dividers;

  DrawerItem(this._icon, this._title, this._position, this._selected,
      {this.onClick, this.marginVertical = 8, this.dividers = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onClick != null) onClick(_position);
      },
      child: Column(
        children: <Widget>[
          Visibility(
            visible: dividers,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: margin, vertical: marginVertical),
              child: Container(
                height: 1,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            decoration: _selected ?  BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                  AppColors.drawerItemSelectedStart,
                  AppColors.drawerItemSelectedEnd
                ]))
            : BoxDecoration(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: margin, vertical: margin / 2),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(_icon),
                  SizedBox(width: margin),
                  Text(
                    _title,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: dividers,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: margin, vertical: marginVertical),
              child: Container(
                height: 1,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
