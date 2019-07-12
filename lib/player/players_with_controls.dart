import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'controls.dart';

class PlayerWithControls extends StatefulWidget {
  String url, title;
  double aspectRatio;
  bool autoPlay;
  PlayerWithControls({
    @required this.url,
    this.title,
    this.aspectRatio,
    this.autoPlay
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
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: <Widget>[
              _buildErrorPlayer(),
              Container(
                child: Column(
                  children: <Widget>[
                    _buildVideoPlayer(),
                    _buildControls()
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  _buildErrorPlayer() {
    return !controller.initialized ? Container(
      child: Row(
        children: <Widget>[
          Icon(Icons.info, size: 20, color: Colors.white,),
          Text("Error playing stream!", style: TextStyle(
            fontFamily: "Helvetica",
            fontSize: 20,
            color: Colors.white
          )),
        ],
      ),
    ) : Container();
  }

  _buildVideoPlayer() {
    return Stack(
      children: <Widget>[
        VlcPlayer(
          aspectRatio: widget.aspectRatio ?? _calculateAspectRatio(context),
          title: widget.url ?? "Video Streaming",
          url: widget.url,
          controller: controller,
        ) ?? Container(width: 0,),
        SizedBox(height: 10,),
        _buildProgress() ?? Container(width: 0,)      
      ],
    );
  }

  _buildProgress() => setState(() => controller.sPlaying == false ? CircularProgressIndicator() : Container(width: 0,));

  _buildControls() => controller != null ? PlayerControls(controller, widget.url) : Container();

  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return width > height ? width / height : height / width;
  }
}