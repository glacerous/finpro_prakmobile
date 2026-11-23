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
    _initVideo();
  }

  Future<void> _initVideo() async {
    _controller = VideoPlayerController.asset(widget.videoAsset);
    try {
      await _controller.initialize();
      await _controller.setVolume(0.0);
      await _controller.setLooping(true);
      if (!mounted) return;
      setState(() => _ready = true);
      await _controller.play();
    } catch (e) {
      debugPrint('HeaderVideoBackground error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready && _controller.value.isInitialized) {
      final ratio = _controller.value.aspectRatio > 0
          ? _controller.value.aspectRatio
          : 16 / 9;
      return LayoutBuilder(
        builder: (context, constraints) {
          final boxRatio = constraints.maxWidth / constraints.maxHeight;
          final width = boxRatio > ratio
              ? constraints.maxWidth
              : constraints.maxHeight * ratio;
          final height = boxRatio > ratio
              ? constraints.maxWidth / ratio
              : constraints.maxHeight;
          return ClipRect(
            child: OverflowBox(
              maxWidth: width,
              maxHeight: height,
              child: SizedBox(
                width: width,
                height: height,
                child: VideoPlayer(_controller),
              ),
            ),
          );
        },
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
