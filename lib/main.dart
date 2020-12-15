import 'package:flutter/material.dart';

import 'src/PlayList/presentation/ui/playlist_page.dart';
import 'src/Video/presentation/ui/videos_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      title: "Javier García",
      routes: {
        "/home": (_) => PlayListPage(),
        "/videos": (_) => VideosPage(),
      },
    );
  }
}
