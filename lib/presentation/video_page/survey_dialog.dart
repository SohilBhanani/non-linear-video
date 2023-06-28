import 'package:adya_assignment/presentation/video_page/v_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../domain/vid_model.dart';

class SurveyDialog extends StatelessWidget {
  const SurveyDialog({super.key, required this.controller});
  final VideoPlayerController controller;
  @override
  Widget build(BuildContext context) {
    // final cProvider = context.read<ControllerListenerCubit>();
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Tell us your feelings...",
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 19),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FeelTile(
                  emoji: '😊',
                  title: 'Happy',
                  onClick: () {
                    // cProvider.feelIntent = FeelIntent.happy;
                    // cProvider.play(controller);
                    context
                        .read<VideoPageProvider>()
                        .setFeelIntent(FeelIntent.happy);
                    context.read<VideoPageProvider>().setTotalDuration(
                        context.read<VideoPageProvider>().totalDuration +
                            videoData[1].length);
                    context.read<VideoPageProvider>().hideControls = false;
                    controller.play();
                    // context.read<VideoPageProvider>().listen(context);
                    Navigator.pop(context);
                  },
                ),
                FeelTile(
                  emoji: '😟',
                  title: 'Sad',
                  onClick: () {
                    context
                        .read<VideoPageProvider>()
                        .setFeelIntent(FeelIntent.sad);
                    context.read<VideoPageProvider>().setTotalDuration(
                        context.read<VideoPageProvider>().totalDuration +
                            videoData[2].length);
                    context.read<VideoPageProvider>().hideControls = false;
                    // cProvider.feelIntent = FeelIntent.sad;
                    // cProvider.play(controller);
                    controller.play();
                    // context.read<VideoPageProvider>().listen(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 19),
          ],
        ),
      ),
    );
  }
}

class FeelTile extends StatelessWidget {
  const FeelTile({
    super.key,
    required this.emoji,
    required this.title,
    required this.onClick,
  });
  final String emoji;
  final String title;
  final VoidCallback onClick;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: SizedBox(
        width: 60,
        child: Card(
          elevation: 4,
          child: Column(
            children: [
              Visibility(
                  visible: false,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12),
                  )),
              Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}
