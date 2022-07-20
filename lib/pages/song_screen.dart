import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/deezer_song.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({Key key, @required this.song}) : super(key: key);
  final DeezerSong song;

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  var audio = AudioPlayer();
  bool isPlaying = false;
  bool _loading = true;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff2C3137),
      appBar: AppBar(
        backgroundColor: const Color(0xff2C3137),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () async {
            if (isPlaying == true) {
              await audio.pause();
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            width: 56.w,
            height: 56.h,
            alignment: Alignment.center,
            child: Image.asset("assets/back.png"),
          ),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  //await audio.stop();
                  //Navigator.of(context).pop();
                },
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  alignment: Alignment.center,
                  child: Image.asset("assets/more.png"),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Center(
                  child: Container(
                    height: 267.h,
                    width: 267.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(400),
                      image: DecorationImage(
                        image: NetworkImage(widget.song?.album?.coverMedium ??
                            "http://www.dermalina.com/wp-content/uploads/2020/12/no-image.jpg"),
                        fit: BoxFit.contain,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white24,
                          blurRadius: 4.r,
                          spreadRadius: 3.r,
                          offset: const Offset(2, 2), // Shadow position
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: AutoSizeText(
                  widget.song?.title ?? "Not Found",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  widget.song?.artist?.name ?? " ",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),
              ),
              SizedBox(height: 70.h),
              /*Center(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: _loading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LinearProgressIndicator(
                              backgroundColor: Colors.cyanAccent,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(Colors.red),
                              value: _progressValue,
                            ),
                            Text('${(_progressValue * 100).round()}%'),
                          ],
                        )
                      : const LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          value: 0.0,
                        ),
                ),
              ),*/
              FadeInUp(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Slider.adaptive(
                    mouseCursor: MouseCursor.defer,
                    activeColor: const Color(0xffFF611A),
                    inactiveColor: const Color(0xff000000),
                    onChanged: (double value) {
                      setState(() {
                        audio.seek(Duration(seconds: value.toInt()));
                      });
                    },
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble(),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      FadeInUp(
                        child: InkWell(
                          onTap: () {
                            if (isPlaying == true) {
                              audio.pause();
                              launchURl(widget.song?.title +
                                  " " +
                                  widget.song?.artist?.name);
                            } else {
                              launchURl(widget.song?.title +
                                  " " +
                                  widget.song?.artist?.name);
                            }
                          },
                          child: Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: const Color(0xff1A1C20),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xffEC540E),
                                  blurRadius: 1.r,
                                  offset:
                                      const Offset(1, -0.1), // Shadow position
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_circle,
                              color: Color(0xff979797),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      FadeInUp(
                        child: Text(
                          "Youtube",
                          style: TextStyle(
                            color: const Color(0xff797C7F),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: InkWell(
                        onTap: () async {
                          print("This is song");
                          print(
                            widget.song?.preview.toString(),
                          );
                          _loading = !_loading;
                          //_updateProgress();
                          if (isPlaying == false) {
                            if (widget.song?.preview.toString() != "" &&
                                widget.song?.preview.toString() != null) {
                              print("Before print");
                              audio.play(
                                UrlSource(
                                  widget.song?.preview.toString(),
                                ),
                              );
                              audio.onDurationChanged.listen(
                                (Duration duration) {
                                  setState(() {
                                    _duration = duration;
                                  });
                                },
                              );
                              audio.onPositionChanged
                                  .listen((Duration duration) {
                                setState(() {
                                  _position = duration;
                                });
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 1000),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Preview Not Available!"),
                                ),
                              );
                              //print("Song Not Available!");
                            }
                          } else {
                            audio.pause();
                          }
                        },
                        child: Container(
                          height: 80.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffEC540E),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xffEC540E),
                                blurRadius: 1.r,
                                spreadRadius: 1.r,
                                offset: const Offset(2, 0), // Shadow position
                              ),
                            ],
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      FadeInUp(
                        child: InkWell(
                          onTap: () async {
                            print("tHIS IS ");
                            print(widget.song?.preview.toString());
                            if (widget.song.preview != "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 500),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Download in Progress...!"),
                                ),
                              );
                              await FlutterDownloader.enqueue(
                                url: widget.song?.preview.toString(),
                                savedDir: "/storage/emulated/0/Download",
                                saveInPublicStorage: true,
                                // show download progress in status bar (for Android)
                                showNotification: true,
                                // click on notification to open downloaded file (for Android)
                                openFileFromNotification: true,
                                fileName: widget.song?.title +
                                    " " +
                                    widget.song?.artist?.name,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 1000),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                      "Download is Not Available for this..!"),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: const Color(0xff1A1C20),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xffEC540E),
                                  blurRadius: 1.r,
                                  offset:
                                      const Offset(-0.9, 0), // Shadow position
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.download,
                              color: Color(0xff979797),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      FadeInUp(
                        child: Text(
                          "Download",
                          style: TextStyle(
                            color: const Color(0xff797C7F),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              //SizedBox(height: 20.h),
              /*TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ListView.builder(
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                                leading: const Icon(Icons.list),
                                trailing: const Text(
                                  "GFG",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 15),
                                ),
                                title: Text("List item $index")),
                          );
                        },
                      );
                    },
                  );
                },
                child: Image.asset(
                  'assets/pull Up.png',
                  height: 6.78.h,
                  width: 25.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 9.w),
                child: Text(
                  "Previous Findings",
                  style: TextStyle(
                    color: const Color(0xff797C7F),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    FlutterDownloader.registerCallback(TestClass.callback);
    audio.onPlayerStateChanged.listen((playerState) {
      print('-----------------');
      print(playerState.name);
      if (playerState.name == "stopped") {
        audio.stop();
        setState(() {
          isPlaying = false;
        });
      } else if (playerState.name == "paused") {
        setState(() {
          isPlaying = false;
        });
      } else if (playerState.name == "playing") {
        setState(() {
          isPlaying = true;
        });
      }
    });
    super.initState();
  }

  /*void _updateProgress() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _progressValue += 0.1;
        if (_progressValue.toStringAsFixed(1) == '1.0') {
          _loading = false;
          t.cancel();
          return;
        }
      });
    });
  }*/
}

class TestClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {}
}

void launchURl(String url) async {
  if (!await launchUrl(
      Uri.parse("https://www.youtube.com/results?search_query=" + url))) {
    throw 'Could not launch the url';
  }
}
