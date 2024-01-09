// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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
      home: const VideoPlayerPage(),
    );
  }
}

class VideoPlayerPage extends StatelessWidget {
  final String videoUrl1 =
      'https://kinterak-v2-assets.s3.eu-west-2.amazonaws.com/experience_videos/memories1.mp4';
  final String videoUrl2 =
      'https://kinterak-v2-assets.s3.eu-west-2.amazonaws.com/experience_videos/memories.mp4';

  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create two video elements
    final videoElement1 = html.VideoElement()
      ..src = videoUrl1
      ..autoplay = true
      ..controls = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..muted = true; // Mute the video
    final videoElement2 = html.VideoElement()
      ..src = videoUrl2
      ..autoplay = true
      ..controls = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..muted = false; // Mute the second video

    // Register both video elements with the platformViewRegistry
    ui.platformViewRegistry.registerViewFactory(
      'video_element_1',
      (int viewId) => videoElement1,
    );
    ui.platformViewRegistry.registerViewFactory(
      'video_element_2',
      (int viewId) => videoElement2,
    );

    // Maintain an aspect ratio of 16:9 for the videos
    const double aspectRatio = 16 / 9;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Web Video Player Example'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: HtmlElementView(viewType: 'video_element_1'),
              ),
            ),
            SizedBox(height: 10), // Spacing between the videos
            Flexible(
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: HtmlElementView(viewType: 'video_element_2'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
