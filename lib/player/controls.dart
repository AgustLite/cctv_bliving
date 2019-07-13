import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'package:flutter_vlc_player/cplayer.dart';

class PlayerControls extends StatefulWidget {
  VlcPlayerController controller;
  String url, title;
  PlayerControls(this.controller, this.url, {this.title});
  _PlayerControls createState() => _PlayerControls();
}

class _PlayerControls extends State<PlayerControls> with WidgetsBindingObserver {

  IconData icon, sound;
  double volume = 0;

  @override
  Widget build(BuildContext context) => _buildBottomBar() ?? Container();

  @override
  void initState() {
    icon = Icons.pause;
    sound = Icons.volume_up;
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.suspending:
        break;
      case AppLifecycleState.resumed:
        print("Application resumed");
        break;
    }
  }

  _buildBottomBar() => Container(
    color: Colors.transparent,
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildPlayPause(),
        Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildSoundController(),
              _buildFullScreen()
            ],
          ),
        )
      ],
    ),
  );

  _playPause() => setState(() {
    if(widget.controller.sPlaying) widget.controller.pause(); 
    else if(widget.controller.initialized) widget.controller.play();
    _buildIcon();
  });

  _buildIcon() => widget.controller.sPlaying == true ? icon = Icons.pause : icon = Icons.play_arrow;

  _buildPlayPause() {
    return IconButton(
      onPressed: () {
        if(widget.controller.initialized) _playPause();
        else print("Can't control");
      },
      icon: Icon(icon, color: Colors.blueAccent,),
      color: Colors.blueAccent,
    );
  }

  _buildSoundController() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(widget.controller.initialized ? Icons.volume_up : Icons.volume_off, color: Colors.blueAccent, size: 18,),
        Container(
          width: 100,
          child: Slider(
            onChanged: (value) => setState(() {
              sound = Icons.volume_up;
              volume = value;
              widget.controller.soundController(value);
            }),
            min: 0,
            max: 1,
            value: volume,
          ),
        )
      ],
    );
  }

  _buildFullScreen() => IconButton(
    onPressed: _fullscreen,
    icon: Icon(Icons.fullscreen, color: Colors.blueAccent,),
    color: Colors.blueAccent,
  );

  _fullscreen() {
    widget.controller.setFullScreen(true);
    Navigator.push(context, MaterialPageRoute(builder: (context) => CPlayer(
      url: widget.url ?? "",
      title: widget.title ?? "CCTV Streaming",
    )));
    if(widget.controller != null && widget.controller.sPlaying) {
      widget.controller.pause();
      _buildIcon();
    }
  }
}
