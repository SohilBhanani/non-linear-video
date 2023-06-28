import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../domain/vid_model.dart';
import 'replay_dialog.dart';
import 'survey_dialog.dart';

enum FeelIntent { happy, sad, na }

class VideoPageProvider extends ChangeNotifier {
  bool shouldAskForFeeling = true;
  bool shouldAskForReplay = true;
  bool hideControls = false;

  Duration? position = Duration.zero;
  Duration totalDuration = videoData[0].length;
  static const Duration haltDuration = Duration(seconds: 4);

  VideoPlayerController vController =
      VideoPlayerController.asset(videoData[0].path);
  FeelIntent feelIntent = FeelIntent.na;

  int currentVideoIndex = 0;

  Future<void> init() async {
    vController = VideoPlayerController.asset(videoData[0].path);
    notifyListeners();
    await vController.initialize();
    await vController.play();
    notifyListeners();
  }

  void listen(BuildContext context) {
    vController.addListener(() async {
      position = await vController.position;

      if (vController.value.position >= haltDuration &&
          shouldAskForFeeling &&
          feelIntent == FeelIntent.na) {
        shouldAskForFeeling = false;
        vController.pause();
        hideControls = true;
        showDialog(
          // context: navigatorKey.currentContext!,
          context: context,
          builder: (context) {
            return SurveyDialog(
              controller: vController,
            );
          },
        );
      }

      if (vController.value.position == vController.value.duration &&
          currentVideoIndex == 0) {
        log("Video-Completed~~~~~~~~");
        switch (feelIntent) {
          case FeelIntent.na:
            currentVideoIndex = 0;
            setTotalDuration(videoData[0].length);

            break;
          case FeelIntent.happy:
            currentVideoIndex = 1;
            break;
          case FeelIntent.sad:
            currentVideoIndex = 2;
            break;
        }
        notifyListeners();
        vController =
            VideoPlayerController.asset(videoData[currentVideoIndex].path);
        await vController.initialize();
        await vController.play();
        notifyListeners();
      }
    });
  }

  void setFeelIntent(FeelIntent i) {
    feelIntent = i;
    notifyListeners();
  }

  void toggleReplyDialog(bool t) {
    shouldAskForReplay = t;
    notifyListeners();
  }

  void toggleFeelDialog(bool t) {
    shouldAskForFeeling = t;
    notifyListeners();
  }

  Duration getPos(BuildContext context) {
    vController.addListener(() async {
      position = vController.value.position;
      notifyListeners();

      if (currentVideoIndex != 0 &&
          position! >=
              videoData[currentVideoIndex].length -
                  const Duration(milliseconds: 200) &&
          shouldAskForReplay) {
        shouldAskForReplay = false;
        hideControls = true;
        notifyListeners();
        showDialog(
          context: context,
          builder: (ctx) {
            return ReplayDialog(
              onAgreed: () {
                resetParams(context);
                hideControls = false;
                Navigator.pop(context);
                notifyListeners();
              },
            );
          },
        );
      }
    });
    if (currentVideoIndex == 0) {
      if (position! < Duration.zero) {
        return position! + videoData[0].length;
      }
      return position!;
    } else {
      return videoData[0].length + position!;
    }
  }

  Duration setPos(double val) {
    if (currentVideoIndex != 0) {
      int secs = val.toInt() - videoData[0].length.inSeconds;

      position = Duration(seconds: secs);
    } else {
      position = Duration(seconds: val.toInt());
    }
    notifyListeners();

    return position!;
  }

  void setTotalDuration(Duration duration) {
    totalDuration = duration;
    notifyListeners();
  }

  void resetParams(BuildContext context) {
    shouldAskForFeeling = true;
    feelIntent = FeelIntent.na;
    currentVideoIndex = 0;
    shouldAskForReplay = true;
    vController = VideoPlayerController.asset(videoData[0].path);
    totalDuration = videoData[0].length;
    position = Duration.zero;
    () async {
      await vController.initialize();
      await vController.play();
    }();
    listen(context);
    notifyListeners();
  }

  void backToDefaultVid(BuildContext context, int val) {
    currentVideoIndex = 0;
    if (val < haltDuration.inSeconds) {
      resetFeelings();
    }

    notifyListeners();
    vController = VideoPlayerController.asset(videoData[0].path);
    // totalDuration = videoData[0].length;
    () async {
      await vController.initialize();
      vController.seekTo(Duration(seconds: val));
      await vController.play();
    }();
    listen(context);
    notifyListeners();
  }

  void goToVidOne(BuildContext context, int val) {
    currentVideoIndex = 1;

    notifyListeners();
    vController = VideoPlayerController.asset(videoData[1].path);
    // totalDuration = videoData[0].length;
    () async {
      await vController.initialize();
      vController
          .seekTo(Duration(seconds: val - videoData[0].length.inSeconds));
      await vController.play();
    }();
    listen(context);
    notifyListeners();
  }

  void goToVidTwo(BuildContext context, int val) {
    currentVideoIndex = 2;

    notifyListeners();
    vController = VideoPlayerController.asset(videoData[2].path);
    // totalDuration = videoData[0].length;
    () async {
      await vController.initialize();
      vController
          .seekTo(Duration(seconds: val - videoData[0].length.inSeconds));
      await vController.play();
    }();
    listen(context);
    notifyListeners();
  }

  void resetFeelings() {
    shouldAskForFeeling = true;
    feelIntent = FeelIntent.na;
    totalDuration = videoData[0].length;
    notifyListeners();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   shouldAskForFeeling = true;
  //   feelIntent = FeelIntent.na;
  //   currentVideoIndex = 0;
  //   shouldAskForReplay = true;
  //   totalDuration = videoData[0].length;
  //   position = Duration.zero;
  //   // vController.dispose();
  //   // vController.pause();
  //   notifyListeners();
  //   super.dispose();
  // }
}
