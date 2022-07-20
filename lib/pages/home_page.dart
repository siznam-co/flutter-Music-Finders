import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shazam_clone/models/deezer_song_manager.dart';

import 'song_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final songManager = context.read<DeezerSongManager>();
    if (songManager.success && mounted) {
      Future.delayed(const Duration(seconds: 1));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SongScreen(
              song: songManager.currentSong,
            ),
          ),
        );
      });
    }
  }

  bool checkConnection = false;
  @override
  Widget build(BuildContext context) {
    final songManager = context.watch<DeezerSongManager>();
    return Scaffold(
      //backgroundColor: const Color(0xff2C3137),
      appBar: AppBar(
        backgroundColor: const Color(0xff17191D),
        elevation: 0.0,
        title: Text(
          "Music Finder",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20.sp,
            color: const Color(0xffAEAAAA),
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      /*drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.cyanAccent[700],
                ),
                child: const Text(
                  'Welcome to Shazam',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.music_note_outlined,
                ),
                title: const Text('One'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.music_note_outlined,
                ),
                title: const Text('Two'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),*/
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xff17191D),
            /*gradient: LinearGradient(
                colors: [
                  Color(0xff2C3137),
                  Color(0xff17191D),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),*/
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          final result =
                              await InternetAddress.lookup('google.com');
                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty) {
                            songManager.startRecognizing();
                          }
                        } on SocketException catch (_) {
                          print("Exception");
                          return ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(milliseconds: 1000),
                              content: Text("Connection not found...!"),
                            ),
                          );
                        }
                        return null;
                      },
                      child: !songManager.isRecognizing
                          ? FadeInUp(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage('assets/iconMain.png'),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                width: 130.w,
                                height: 136.h,
                              ),
                            )
                          : Column(
                              children: [
                                FadeInUp(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image:
                                            AssetImage("assets/listening.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width:
                                        songManager.isRecognizing ? 114.w : 0.w,
                                    height:
                                        songManager.isRecognizing ? 128.w : 0.w,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                FadeInUp(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    decoration: const BoxDecoration(
                                      //shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage("assets/shadow.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width:
                                        songManager.isRecognizing ? 77.w : 0.w,
                                    height:
                                        songManager.isRecognizing ? 20.w : 0.w,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              /* Positioned(
                  bottom: 4,
                  left: 10,
                  right: 10,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/listening.png"),
                      ),
                    ),
                    width: songManager.isRecognizing ? 160 : 0,
                    height: songManager.isRecognizing ? 160 : 0,
                  ),
                ),*/
              if (songManager.isRecognizing)
                Positioned(
                  bottom: 100.h,
                  left: 0.w,
                  right: 0.w,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'Horizon',
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        RotateAnimatedText('Listening...'),
                        RotateAnimatedText('Wait for the result'),
                        TyperAnimatedText('We are preparing everything',
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              songManager.isRecognizing
                  ? Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: FadeIn(
                        child: GestureDetector(
                          onTap: () {
                            songManager.stopRecognizing();
                          },
                          child: Container(
                            width: 85.w,
                            height: 26.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: Colors.white.withOpacity(0.2)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Icon(Icons.close, color: Colors.white),
                                Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
