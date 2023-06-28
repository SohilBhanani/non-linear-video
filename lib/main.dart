import 'nav_key.dart';
import 'presentation/video_page/v_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/home_page/home_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<VideoPageProvider>(
        create: (context) => VideoPageProvider(),
      ),
    ],
    child: MaterialApp(
      key: navigatorKey,
      home: const HomePage(),
    ),
  ));
}
