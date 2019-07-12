import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'package:flutter_vlc_player/cplayer.dart';

class PlayerControls extends StatefulWidget {
  VlcPlayerController controller;
  String url;
  PlayerControls(this.controller, this.url);
  _PlayerControls createState() => _PlayerControls();
}

class _PlayerControls extends State<PlayerControls> {

  IconData icon, sound;
  double volume = 1.0;

  @override
  Widget build(BuildContext context) => _buildBottomBar() ?? Container();

  @override
  void initState() {
    icon = Icons.pause;
    sound = Icons.volume_up;
    super.initState();
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
    print("Playing : ${widget.controller.sPlaying}");
    return IconButton(
      onPressed: _playPause,
      icon: Icon(icon, color: Colors.blueAccent,),
      color: Colors.blueAccent,
    );
  }

  _buildSoundController() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.volume_up, color: Colors.blueAccent, size: 18,),
        Container(
          width: 100,
          child: Slider(
            onChanged: (value) => setState(() {
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
    final result = Navigator.push(context, MaterialPageRoute(builder: (context) => CPlayer(
      url: widget.url ?? "",
      title: "CCTV Streaming",
    )));
    if(result != null) print("Result from cplayer : $result");
    if(widget.controller != null && widget.controller.sPlaying) widget.controller.pause();
  }
}
