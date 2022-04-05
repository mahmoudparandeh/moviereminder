import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../helper/colors.dart';

class VideoScreen extends StatefulWidget {
  final String videoUrl;

  const VideoScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoState();
  }
}

class VideoState extends State<VideoScreen> {
  late VideoPlayerController controller;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    videoInitializer();
  }

  videoInitializer() async {
    controller = VideoPlayerController.network(widget.videoUrl);
    await Future.wait([
    controller.initialize()
    ]);
    chewieController = ChewieController(
      videoPlayerController: controller,
      autoPlay: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    chewieController!.pause();
    chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundMainColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: chewieController != null &&
                    chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: chewieController!,
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
                        Text(
                          "Loading...",
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
          ),
          Container(
            width: width,
            height: 48,
            color: blurBackground,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      "Back to movie",
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    ));
  }
}
