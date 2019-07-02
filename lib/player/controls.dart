import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'package:flutter_vlc_player/cplayer.dart';

class PlayerControls extends StatefulWidget {
  VlcPlayerController controller;
  PlayerControls(this.controller);
  _PlayerControls createState() => _PlayerControls();
}

class _PlayerControls extends State<PlayerControls> {

  bool hide = false;
  Timer _hideTimer;
  Timer _showTimer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          // _buildVideoPlayer(),
          _buildHitArea(),
          _buildBottomBar()
        ],
      ),
    );
  }

  _buildVideoPlayer() => setState(() => widget.controller.playing ? _buildHitArea() : Center(child: CircularProgressIndicator(),));

  _buildHitArea() {
    return Center(
      child: GestureDetector(
        child: Container(
          color: Colors.transparent,
          child: AnimatedOpacity(
            opacity: !widget.controller.sPlaying ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(48.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.play_arrow, size: 32.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _showTimer?.cancel();
    super.dispose();
  }

  _buildBottomBar() {
    return AnimatedOpacity(
      opacity: hide ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Opacity(
        opacity: 0.5,
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildPlayPause(),
              _buildFullScreen()
            ],
          ),
        ),
      ),
    );
  }

  _playPause() {
    setState(() {
      print(widget.controller.sPlaying);
      if(widget.controller.sPlaying) {
        hide = false;
        _hideTimer?.cancel();
        widget.controller.pause();
      } else {
        hide = true;
        _cancelAndRestartTimer();
        if(widget.controller.initialized) widget.controller.play();
      }
    });
  }

  _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() => hide = false);
  }

  _startHideTimer() {
    _hideTimer = Timer(
      const Duration(seconds: 3),
      () => setState(() => hide = true)
    );
  }

  _buildIcon() => widget.controller.sPlaying ? Icon(Icons.pause, color: Colors.white,) : Icon(Icons.play_arrow, color: Colors.white,);

  _buildPlayPause() {
    print(widget.controller.sPlaying);
    return GestureDetector(
      onTap: _playPause,
      child: _buildIcon(),
    );
  }

  _buildFullScreen() {
    return GestureDetector(
      onTap: _fullscreen,
      child: Icon(Icons.fullscreen, color: Colors.white,),
    );
  }

  _fullscreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CPlayer(
      
    )));
  }
}
