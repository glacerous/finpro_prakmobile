import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HeaderVideoBackground extends StatefulWidget {
  final String videoAsset;
  final String fallbackImage;

  const HeaderVideoBackground({
    super.key,
    this.videoAsset = 'assets/videos/header.mp4',
    this.fallbackImage = 'assets/images/alpine_dawn_frames/f_0.png',
  });

  @override
  State<HeaderVideoBackground> createState() => _HeaderVideoBackgroundState();
}

class _HeaderVideoBackgroundState extends State<HeaderVideoBackground> {
  late VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _ready = true);
        _controller.play();
      }).catchError((_) {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready && _controller.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      );
    }
    return Image.asset(
      widget.fallbackImage,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Image.asset(
        'assets/images/dither_landscape.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
