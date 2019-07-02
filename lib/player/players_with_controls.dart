import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'controls.dart';

class PlayerWithControls extends StatefulWidget {
  String url, title;
  double aspectRatio;
  PlayerWithControls({
    @required this.url,
    this.title,
    this.aspectRatio
  });
  _PlayerWithControls createState() => _PlayerWithControls();
}

class _PlayerWithControls extends State<PlayerWithControls> {

  VlcPlayerController controller;

  @override
  void initState() {
    controller = VlcPlayerController(
      onInit: () => controller.play()
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          VlcPlayer(
            aspectRatio: widget.aspectRatio ?? _calculateAspectRatio(context),
            title: widget.url ?? "Video Streaming",
            url: widget.url,
            controller: controller,
          ),
          Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              child: _buildControls(),
            ),
            bottom: 0,
          )
        ],
      ),
    );
  }

  _buildControls() => controller != null ? PlayerControls(controller) : Container();

  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return width > height ? width / height : height / width;
  }
}