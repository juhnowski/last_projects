import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  @override
  List<Object> get props => [];

  const MainState();
}

class MainAboutClubState extends MainState {
  @override
  String toString() => "MainAboutClubState";

  const MainAboutClubState();
}

class MainResultsState extends MainState {
  @override
  String toString() => "MainResultsState";

  const MainResultsState();
}

class MainProjectsState extends MainState {
  @override
  String toString() => "MainProjectsState";

  const MainProjectsState();
}

class MainEventsState extends MainState {
  @override
  String toString() => "MainEventsState";
}

class MainNewsState extends MainState {
  @override
  String toString() => "MainNewsState";

  const MainNewsState();
}

class MainClubMembersState extends MainState {
  @override
  String toString() => "MainClubMembersState";

  const MainClubMembersState();
}

class MainPhotoState extends MainState {
  @override
  String toString() => "MainPhotoState";

  const MainPhotoState();
}

class MainMyProfileState extends MainState {
  @override
  String toString() => "MainMyProfileState";

  const MainMyProfileState();
}

class MainContactsState extends MainState {
  @override
  String toString() => "MainContactsState";

  const MainContactsState();
}
