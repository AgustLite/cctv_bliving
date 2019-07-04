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

  IconData icon;

  @override
  Widget build(BuildContext context) => _buildBottomBar() ?? Container();

  _buildBottomBar() => Container(
    color: Colors.transparent,
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildPlayPause(),
        _buildFullScreen()
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

  _buildSoundController() => IconButton(
    icon: Icon(Icons.volume_up, color: Colors.blueAccent,),
    onPressed: () {
      
    },
    iconSize: 17,
  );

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
