import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
    locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appTitle {
    return Intl.message('Russian Leaders',
        name: 'appTitle');
  }

  String get drawerAboutClub {
    return Intl.message('About club',
        name: 'drawerAboutClub');
  }

  String get drawerResults {
    return Intl.message('Results 2019',
        name: 'drawerResults');
  }

  String get drawerProjects {
    return Intl.message('Projects 2020',
        name: 'drawerProjects');
  }

  String get drawerEvents {
    return Intl.message('Events',
        name: 'drawerEvents');
  }

  String get drawerNews{
    return Intl.message('News',
        name: 'drawerNews');
  }

  String get drawerClubMembers {
    return Intl.message('Club members',
        name: 'drawerClubMembers');
  }

  String get drawerPhotos{
    return Intl.message('Photo / Video',
        name: 'drawerPhotos');
  }

  String get drawerMyProfile {
    return Intl.message('My Profile',
        name: 'drawerMyProfile');
  }

  String get drawerContacts {
    return Intl.message('Contacts',
        name: 'drawerContacts');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}