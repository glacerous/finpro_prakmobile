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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.play();
      });
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
      final size = _controller.value.size;
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: size.width > 0 ? size.width : 640,
            height: size.height > 0 ? size.height : 320,
            child: VideoPlayer(_controller),
          ),
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
