import 'package:flutter/material.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  VideoCallPageState createState() => VideoCallPageState();
}

class VideoCallPageState extends State<VideoCallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Video Call Page'),
      ),
    );
  }
}
