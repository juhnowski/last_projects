import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/blocs/chat_bloc.dart';
import 'package:rsv_mobile/repositories/events_repository.dart';
import 'package:rsv_mobile/repositories/meetings_repository.dart';
import 'package:rsv_mobile/repositories/news.dart';
import 'package:rsv_mobile/repositories/tasks_repository.dart';
import 'package:rsv_mobile/models/auth.dart';
import 'package:rsv_mobile/services/calendars_manager.dart';
import 'package:rsv_mobile/services/chat_service.dart';
import 'package:rsv_mobile/repositories/room_member_repository.dart';
import 'package:rsv_mobile/routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rsv_mobile/screens/splash_screen.dart';
import 'package:rsv_mobile/models/cms/activities.dart';
import 'package:rsv_mobile/services/download_manager.dart';
import 'package:rsv_mobile/services/network.dart';

import 'models/files.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize();

  final networkService = new NetworkService(new AuthModel());
  await networkService.authValidateJwt();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(App(
    networkService: networkService,
  ));
}

class App extends StatefulWidget {
  final NetworkService networkService;
  App({Key key, @required this.networkService}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /*
        * Providers without dependencies
        * */
        Provider(create: (context) => new CalendarsManager()),
        Provider(
          create: (context) => DownloadManager(Theme.of(context).platform),
        ),
        ChangeNotifierProvider(
            create: (context) => NewsRepository(widget.networkService)),
        /*
         * Independent providers on which others depend
         */
        ChangeNotifierProvider<NetworkService>.value(
            value: widget.networkService),
        ChangeNotifierProxyProvider<NetworkService, Activities>(
            create: (context) => Activities(
              calendarsManager:
              Provider.of<CalendarsManager>(context, listen: false),
              meetingsRepository:
              new MeetingsRepository(widget.networkService),
              eventsRepository: new EventsRepository(widget.networkService),
            ),
            update: (_, networkService, activities) =>
            activities..user = networkService.user),
        ChangeNotifierProxyProvider<NetworkService, RoomMemberRepository>(
          create: (context) => RoomMemberRepository(),
          update: (_, networkService, roomMemberRepository) =>
          roomMemberRepository..update(networkService),
        ),
        ProxyProvider<NetworkService, ChatBLoC>(
          create: (context) => ChatBLoC(
            ChatService(domain: widget.networkService?.getHost('chat')),
            Provider.of<RoomMemberRepository>(context, listen: false),
          ),
          update: (_, networkService, chat) => chat..network = networkService,
          dispose: (_, value) => value.dispose(),
        ),
        ChangeNotifierProxyProvider<NetworkService, TasksRepository>(
            create: (context) => TasksRepository(widget.networkService),
            update: (_, networkService, chat) =>
            chat..groupId = networkService.user.groupId),
        ChangeNotifierProxyProvider<NetworkService, Files>(
            create: (context) => Files(widget.networkService),
            update: (_, networkService, files) => files
              ..groupId = networkService.user.groupId
              ..userId = networkService.user.userId),

      ],
      child: new MaterialApp(
          home: SplashScreen(),
          routes: appRoutes,
          locale: Locale('ru'),
          debugShowCheckedModeBanner: false,
          supportedLocales: [
            const Locale('ru'),
          ],
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: theme()),
    );
  }

  ThemeData theme() {
    return ThemeData(
      textTheme: TextTheme(
          body1: TextStyle(fontSize: 18),
          body2: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      //canvasColor: Colors.transparent,
      bottomSheetTheme:
      BottomSheetThemeData(backgroundColor: Colors.transparent),
      fontFamily: 'Segoe',
      // bottomAppBarColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xff1184ED),
        ),
        textTheme: TextTheme(
            title: TextStyle(
                color: Color(0xff1184ED), fontSize: 20, fontFamily: 'Segoe')),
      ),
    );
  }
}
