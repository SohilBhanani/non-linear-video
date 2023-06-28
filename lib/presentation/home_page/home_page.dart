import 'package:flutter/material.dart';

import '../video_page/video_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[300],
          title: Text("Seamless Video Seek"),
        ),
        body: ListView(
          children: [
            ListTile(
              dense: true,
              title: const Text(
                "Adya-Care Reel 1",
              ),
              trailing: const Icon(
                Icons.play_arrow,
                color: Colors.black,
              ),
              subtitle: const Text("Click to play"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VideoPage(),
                    ));
              },
            )
          ],
        ));
  }
}
