import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:russian_leaders/bloc/login/bloc.dart';
import 'package:russian_leaders/repository/user_repository.dart';
import 'package:russian_leaders/theme.dart';
import 'package:russian_leaders/ui/screens/splash_screen.dart';

import 'bloc/auth/bloc.dart';
import 'localizations.dart';
import 'repository/settings_manager.dart';
import 'ui/screens/error_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/main_screen.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final settingsManager = SettingsManager();
  final UserRepository userRepository = MockUserRepository(settingsManager);
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository)..add(AppStarted());
      },
      child: RussianLeadersApp(
        userRepository: userRepository,
      ),
    ),
  );
}

class RussianLeadersApp extends StatelessWidget {
  final UserRepository userRepository;

  const RussianLeadersApp({Key key, @required this.userRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        FallbackCupertinoLocalisationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru'),
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      theme: appTheme(),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashScreen();
          } else if (state is AuthenticationAuthenticated) {
            return MainScreen();
          } else if (state is AuthenticationUnauthenticated) {
            return BlocProvider<LoginBloc>(
                create: (context) {
                  return LoginBloc(
                      userRepository: userRepository,
                      authenticationBloc:
                          BlocProvider.of<AuthenticationBloc>(context));
                },
                child: LoginScreen());
          } else if (state is AuthenticationLoading) {
            return SplashScreen();
          } else {
            return ErrorScreen();
          }
        },
      ),
    );
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
