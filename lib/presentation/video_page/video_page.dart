import 'dart:developer';

import 'package:adya_assignment/presentation/video_page/v_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../domain/vid_model.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPageProvider vidP;
  late BuildContext c;
  @override
  void initState() {
    super.initState();
    // _init(context);
    vidP = context.read<VideoPageProvider>();
    context.read<VideoPageProvider>().init();
    context.read<VideoPageProvider>().listen(context);
    // Future.delayed(Duration(milliseconds: 500), () {});
  }

  @override
  void dispose() {
    // vidP.resetFeelings();
    // vidP.dispose();
    // context.read<VideoPageProvider>().vController.pause();

    // context.read<VideoPageProvider>().vController.dispose();
    context.read<VideoPageProvider>().dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(body: Consumer<VideoPageProvider>(
        builder: (context, value, child) {
          VidModel defaultVid = videoData[0];

          double getVal() {
            if (value.getPos(context) >=
                value.totalDuration + const Duration(milliseconds: 20)) {
              log('Here');
              return videoData[0].length.inSeconds.toDouble();
            } else {
              // log('THere: ${value.getPos()}');
              return value.getPos(context).inSeconds.toDouble();
            }
          }

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(value.vController),
              Visibility(
                visible: !value.hideControls,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "00:${value.getPos(context).inSeconds.toString().padLeft(2, '0')}/00:${value.totalDuration.inSeconds.toString().padLeft(2, '0')}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 30)
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: value.vController.value.isPlaying
                                    ? const Icon(
                                        Icons.pause,
                                        color: Colors.white,
                                        size: 34,
                                      )
                                    : const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 34,
                                      ),
                                onPressed: () {
                                  if (value.vController.value.isPlaying) {
                                    value.vController.pause();
                                  } else {
                                    value.vController.play();
                                  }
                                },
                              ),
                              Expanded(
                                child: Slider(
                                  thumbColor: Colors.white,
                                  activeColor: Colors.orange,
                                  inactiveColor: Colors.white,
                                  // value: value.vController.value.position.inSeconds.toDouble(),
                                  value: getVal(),
                                  min: 0,
                                  max: value.totalDuration.inSeconds.toDouble(),
                                  onChangeStart: (_) {
                                    value.vController.pause();
                                  },
                                  onChangeEnd: (v) async {
                                    /*
                                    value< video[0].duration && cv=0
                                    value> video[0].duration && cv=0
                                    value< video[0].duration && cv=1
                                    value> video[0].duration && cv=1
                                    value< video[0].duration && cv=2
                                    value> video[0].duration && cv=2
                                              
                                    if(value< video[0].duration)
                                    {
                                      if(cv==0){
                                        simple seekto(value)
                                      }
                                      if(cv==1||cv==2){
                                        move to video 0(cv=0 )
                                        simple seekto(value)
                                      }
                                              
                                    }
                                    if(value> video[0].duration)
                                    {
                                      if(cv==1 || cv==2){
                                        seekto(video[0].duration + value)
                                      }
                                      if(cv==0){
                                        if(intent is happy){
                                          set current position = value-video[0].duration
                                          move to video happy
                                          seekto(value- video[0].duration)
                                        }
                                        if(intent is sad){
                                          set current position = value-video[0].duration
                                          move to video sad
                                          seekto(value-video[0].duration)
                                        }
                                        if(intent is na){
                                          
                                          seekto(5 seconds of video to show dialog)
                                        }
                                      }
                                              
                                    }
                                     */
                                    if (v < defaultVid.length.inSeconds) {
                                      if (value.currentVideoIndex == 0) {
                                        if (v <
                                            VideoPageProvider
                                                .haltDuration.inSeconds) {
                                          context
                                              .read<VideoPageProvider>()
                                              .resetFeelings();
                                        }
                                        value.vController.seekTo(
                                            Duration(seconds: v.toInt()));
                                        await value.vController.play();
                                        return;
                                      }
                                      if (value.currentVideoIndex == 1 ||
                                          value.currentVideoIndex == 2) {
                                        value.backToDefaultVid(
                                            context, v.toInt());
                                        return;
                                      }
                                    }
                                    if (v >= defaultVid.length.inSeconds) {
                                      if (value.currentVideoIndex == 1 ||
                                          value.currentVideoIndex == 2) {
                                        value.vController.seekTo(Duration(
                                            seconds: v.toInt() -
                                                videoData[0].length.inSeconds));
                                        await value.vController.play();
                                      }
                                      if (value.currentVideoIndex == 0) {
                                        if (value.feelIntent == FeelIntent.na) {
                                          value.vController.seekTo(
                                              const Duration(seconds: 8));
                                          return;
                                        }
                                        if (value.feelIntent ==
                                            FeelIntent.happy) {
                                          value.goToVidOne(context, v.toInt());
                                          return;
                                        }
                                        if (value.feelIntent ==
                                            FeelIntent.sad) {
                                          value.goToVidTwo(context, v.toInt());
                                          return;
                                        }
                                      }
                                    }
                                  },
                                  onChanged: (v) {
                                    value.setPos(v);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      )),
    );
  }
}
