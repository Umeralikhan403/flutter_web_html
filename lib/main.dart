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
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(videoUrlFullScreen))
          ..initialize().then((_) {
            setState(() {});
          });
    // Setup an interop function so JavaScript knows what to call when the video ends
    js.context['onVideoEnd'] = js.allowInterop(onVideoEnd);
    super.initState();
  }

  void playVideos() {
    // Play the large video using the video_player package
    if (_controller.value.isInitialized) {
      _controller.play();
    }
    // Play the smaller video using JavaScript
    playSmallVideo(videoUrlSmallScreen);
  }

  void onVideoEnd() {
    print('The small video has finished playing');
    removeSmallVideo();
    // Navigator.pop(context);
  }

  Future playSmallVideo(String url) async {
    // Call JS function to create and play the video
    await js.context.callMethod('createSmallVideoElement', [url]);
  }

  Future removeSmallVideo() async {
    // Call JS function to remove the video
    await js.context.callMethod('removeSmallVideoElement');
  }

  @override
  void dispose() {
    _controller.dispose();
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
          if (_controller.value.isInitialized) VideoPlayer(_controller),
          Positioned(
            left: 20,
            bottom: 20,
            child: ElevatedButton(
              onPressed: playVideos, // Play videos when the button is tapped
              child: const Text('Play Videos'),
            ),
          ),
        ],
      ),
    );
  }
}
