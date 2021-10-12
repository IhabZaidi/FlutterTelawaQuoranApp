import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:telewaquoranapp/sound_list.dart';

// ignore_for_file: prefer_const_constructors
// ignore: must_be_immutable
class PlayScreen extends StatefulWidget {
  int index = 0;
  PlayScreen({Key? key, required this.index}) : super(key: key);

  @override
  // ignore: unnecessary_this, no_logic_in_create_state
  _PlayScreenState createState() => _PlayScreenState(this.index);
}

class _PlayScreenState extends State<PlayScreen> {
  int index = 0;
  _PlayScreenState(this.index);
  int surahindex = 0;
  Color iconColor = Colors.grey;
  int playingStat = 0;
  final player = AudioPlayer();
  List<String> surahList = SourahList().surahName;
  List<String> linkList = [];
  List<String> authorList = [];
  Map<String, String> map = SoundList().map;
  late Stream<DurationState> durationState;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    map.forEach(
      (key, val) {
        authorList.add(key);
        linkList.add(val);
      },
    );
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
      player.positionStream,
      player.playbackEventStream,
      (position, playbackEvent) => DurationState(
        progress: position,
        buffered: playbackEvent.bufferedPosition,
        total: playbackEvent.duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  // ignore: prefer_const_literals_to_create_immutables
                  colors: [
                    Color.fromARGB(255, 140, 133, 247),
                    Color.fromARGB(255, 189, 107, 244),
                    Color.fromARGB(255, 83, 163, 250)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  // ignore: prefer_const_literals_to_create_immutables
                  stops: [0.2, 0.6, 1]),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Text(
                "Telawa Quoran App",
                style: GoogleFonts.notoSerif(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.232,
                width: MediaQuery.of(context).size.width * 0.53,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/pic1.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                authorList[index],
                style: GoogleFonts.notoSerif(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                "Surat ${surahList[surahindex]}",
                style: GoogleFonts.notoSerif(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: StreamBuilder<DurationState>(
                  stream: durationState,
                  builder: (context, snapshot) {
                    final durationState = snapshot.data;
                    final progress = durationState?.progress ?? Duration.zero;
                    final buffered = durationState?.buffered ?? Duration.zero;
                    final total = durationState?.total ?? Duration.zero;
                    return ProgressBar(
                      progress: progress,
                      buffered: buffered,
                      total: total,
                      onSeek: (duration) {
                        player.seek(duration);
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4656,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                if (surahindex != 0) {
                                  surahindex -= 1;
                                }
                              });
                              player.stop();
                              if (index < 9) {
                                var duration = await player.setUrl(
                                    '${linkList[index]}00${surahindex + 1}.mp3');
                              } else if (index < 99) {
                                var duration = await player.setUrl(
                                    '${linkList[index]}0${surahindex + 1}.mp3');
                              } else {
                                var duration = await player.setUrl(
                                    '${linkList[index]}${surahindex + 1}.mp3');
                              }

                              player.play();
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width * 0.12,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/backward_btn.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await player.stop();
                              if (surahindex < 9) {
                                var duration = await player.setUrl(
                                    '${linkList[index]}00${surahindex + 1}.mp3');
                              } else if (surahindex < 99) {
                                var duration = await player.setUrl(
                                    '${linkList[index]}0${surahindex + 1}.mp3');
                              } else {
                                var duration = await player.setUrl(
                                    '${linkList[index]}${surahindex + 1}.mp3');
                              }
                              //log('${linkList[index]}${surahindex + 1}.mp3');
                              player.play();
                              player.setVolume(1);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.15,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/play_btn.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await player.pause();
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width * 0.12,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/pause_btn.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                surahindex += 1;
                              });
                              player.stop();
                              if (index < 9) {
                                var duration = await player.setUrl(
                                    '${linkList[index]}00${surahindex + 1}.mp3');
                              } else if (index < 99) {
                                var duration = await player.setUrl(
                                    '${linkList[index]}0${surahindex + 1}.mp3');
                              } else {
                                var duration = await player.setUrl(
                                    '${linkList[index]}${surahindex + 1}.mp3');
                              }
                              player.play();
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width * 0.12,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/forward_btn.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authorList[index],
                                style: GoogleFonts.notoSerif(
                                  textStyle: TextStyle(
                                    color: Colors.black87,
                                    letterSpacing: .5,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Text(
                                "Surat ${surahList[surahindex]}",
                                style: GoogleFonts.notoSerif(
                                  textStyle: TextStyle(
                                    color: Colors.grey,
                                    letterSpacing: .5,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: IconButton(
                                  padding: EdgeInsets.all(0.0),
                                  color: iconColor,
                                  icon:
                                      Icon(Icons.favorite_outlined, size: 20.0),
                                  onPressed: () {
                                    setState(
                                      () {
                                        if (iconColor == Colors.red) {
                                          iconColor = Colors.grey;
                                        } else {
                                          iconColor = Colors.red;
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                              Text(
                                "125 Kb/s",
                                style: GoogleFonts.notoSerif(
                                  textStyle: TextStyle(
                                    color: Colors.grey,
                                    letterSpacing: .5,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.33,
                      child: ListView.builder(
                        itemCount: surahList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  player.stop();
                                  setState(() {
                                    surahindex = index;
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        // ignore: prefer_const_literals_to_create_immutables
                                        colors: [
                                          Color.fromARGB(255, 140, 133, 247),
                                          Color.fromARGB(255, 189, 107, 244),
                                          Color.fromARGB(255, 83, 163, 250)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        stops: [0.2, 0.6, 1]),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.005,
                                        ),
                                        Text(
                                          surahList[index],
                                          style: GoogleFonts.notoSerif(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.005,
                                        ),
                                        Text(
                                          '--:--',
                                          style: GoogleFonts.notoSerif(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                        ),
                                        Center(
                                          child: Text(
                                            "125 Kb/s",
                                            style: GoogleFonts.notoSerif(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: .5,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DurationState {
  final Duration? progress;
  final Duration? buffered;
  final Duration? total;
  const DurationState({this.progress, this.buffered, this.total});
}
