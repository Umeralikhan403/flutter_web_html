import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Video Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
            icon: const Icon(Icons.forward),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VideoPlayerPage()));
            }),
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  // late html.VideoElement _smallVideoElement;
  final String videoUrlFullScreen =
      'https://kinterak-v2-assets.s3.eu-west-2.amazonaws.com/experience_videos/memories1.mp4';
  final String videoUrlSmallScreen =
      'https://kinterak-v2-assets.s3.eu-west-2.amazonaws.com/experience_videos/memories.mp4';

  @override
  void initState() {
    super.initState();
    // Initialize the large video controller
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(videoUrlFullScreen))
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                _controller.play();
              });
            }
          });
    playSmallVideo(videoUrlSmallScreen);
    /////
    js.context['onVideoEnd'] = js.allowInterop(onVideoEnd);
  }

  void onVideoEnd() {
    print('The small video has finished playing');
    Navigator.pop(context);
  }

  void playSmallVideo(String url) {
    // Call JS function to create and play the video
    js.context.callMethod('createSmallVideoElement', [url]);
  }

  void removeSmallVideo() {
    // Call JS function to remove the video
    js.context.callMethod('removeSmallVideoElement');
  }

  @override
  void dispose() {
    _controller.dispose();
    removeSmallVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Web Video Player Example'),
      ),
      body: Stack(
        children: [
          // Fullscreen video using the video_player package
          VideoPlayer(_controller),
        ],
      ),
    );
  }
}
