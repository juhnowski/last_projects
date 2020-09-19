import 'package:bloc/bloc.dart';
import 'package:russian_leaders/bloc/main/block.dart';
import 'package:russian_leaders/model/drawer_items.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  @override
  MainState get initialState => MainAboutClubState();

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is DrawerItemChosen) yield _drawerItemChosen(event.itemSelected);
  }

  MainState _drawerItemChosen(DrawerItem newItem) {
    switch (newItem) {
      case DrawerItem.ABOUT_CLUB:
        return MainAboutClubState();
        break;
      case DrawerItem.RESULTS:
        return MainResultsState();
        break;
      case DrawerItem.PROJECTS:
        return MainProjectsState();
        break;
      case DrawerItem.EVENTS:
        return MainEventsState();
        break;
      case DrawerItem.NEWS:
        return MainNewsState();
        break;
      case DrawerItem.CLUB_MEMBERS:
        return MainClubMembersState();
        break;
      case DrawerItem.PHOTO:
        return MainPhotoState();
        break;
      case DrawerItem.MY_PROFILE:
        return MainMyProfileState();
        break;
      case DrawerItem.CONTACTS:
        return MainContactsState();
        break;
    }
    return MainAboutClubState();
  }
}
