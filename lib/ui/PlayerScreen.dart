import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ten_twenty/ui/MovieDetailed.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  static const Route = '/PlayerScreen';

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _controller;
  late ChewieController chewieController;

  bool _isPlaying = false;
  late Duration? _duration;
  late Duration? _position;
  bool _isEnd = false;

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller.removeListener(videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    _controller.setLooping(false);
    _controller.initialize().then((_) => setState(() {
          _controller.addListener(videoListener);
          chewieController.enterFullScreen();
          _controller.play();
        }));
    chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          // child: AspectRatio(
          //   aspectRatio: _controller.value.aspectRatio,
          //   child: Stack(
          //     alignment: Alignment.bottomCenter,
          //     children: <Widget>[
          //       // VideoPlayer(_controller),
          //       // ClosedCaption(text: _controller.value.caption.text),
          //       // _ControlsOverlay(controller: _controller),
          //       // VideoProgressIndicator(_controller, allowScrubbing: true),
          //     ],
          //   ),
          // ),
          child: Chewie(
            controller: chewieController,
          ),
        ),
      ),
    );
  }

  void videoListener() {
    Timer.run(() {
      this.setState(() {
        _position = _controller.value.position;
      });
    });
    setState(() {
      _duration = _controller.value.duration;
    });
    _duration?.compareTo(_position!) == 0 || _duration?.compareTo(_position!) == -1
        ? this.setState(() {
            _isEnd = true;
          })
        : this.setState(() {
            _isEnd = false;
          });
    if (_isEnd) {
      chewieController.exitFullScreen();
      Navigator.popUntil(context, (route) => route.settings.name == MovieDetailedScreen.Route);
    }
  }

// print('Position -> ${_controller.value.position.inMilliseconds}');
// print('Duration -> ${_controller.value.duration.inMilliseconds}');
// if (_controller.value.position.inSeconds == _controller.value.duration.inSeconds) {
//   print('Playing Finished');
// }
}
