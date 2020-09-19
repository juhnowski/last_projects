import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsv_mobile/models/user.dart';
import 'package:rsv_mobile/services/network.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController _controller;
  int _played = 0;

  Future checkLoginState() async {
    if (Provider.of<NetworkService>(context, listen: false).user.isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/splash.mp4')
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying == false) {
          _played++;
          if (_played >= 2) {
            checkLoginState();
          }
        }
      })
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: new Scaffold(
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
