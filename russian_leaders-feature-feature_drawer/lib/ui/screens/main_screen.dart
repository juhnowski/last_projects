import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:russian_leaders/bloc/main/block.dart';
import 'package:russian_leaders/localizations.dart';
import 'package:russian_leaders/ui/widgets/main_drawer.dart';
import 'package:russian_leaders/ui/widgets/navigation_view.dart';

class MainScreen extends StatelessWidget {
  Widget _contentWidget = Container();
  String _title = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: BlocProvider(
        create: (context) => MainBloc(),
        child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
          _handleState(state, context);

          return Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  child:
                      Stack(alignment: Alignment.centerLeft, children: <Widget>[
                    NavigationIcon(
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                    AppScreenTitle(_title)
                  ]),
                ),
                _contentWidget
              ],
            ),
          );
        }),
      ),
    );
  }

  void _handleState(MainState state, BuildContext context) {
    if (state is MainAboutClubState) {
      //_contentWidget = AboutClubScreen();
      _title = AppLocalizations.of(context).drawerAboutClub;
    } else if (state is MainResultsState) {
      //...
      _title = AppLocalizations.of(context).drawerResults;
    } else if (state is MainProjectsState) {
      _title = AppLocalizations.of(context).drawerProjects;
    } else if (state is MainEventsState) {
      _title = AppLocalizations.of(context).drawerEvents;
    } else if (state is MainNewsState) {
      _title = AppLocalizations.of(context).drawerNews;
    } else if (state is MainClubMembersState) {
      _title = AppLocalizations.of(context).drawerClubMembers;
    } else if (state is MainPhotoState) {
      _title = AppLocalizations.of(context).drawerPhotos;
    } else if (state is MainMyProfileState) {
      _title = AppLocalizations.of(context).drawerMyProfile;
    } else {
      _title = AppLocalizations.of(context).drawerContacts;
    }
  }
}
