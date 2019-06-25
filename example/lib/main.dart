import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/vlc_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uint8List image;
  GlobalKey imageKey;
  VlcPlayer videoView;
  VlcPlayerController _videoViewController;

  @override
  void initState() {
    imageKey = new GlobalKey();
    _videoViewController = new VlcPlayerController(
      onInit: (){
        // _videoViewController.play();
      }
    );
    // _videoViewController.addListener((){
    //   setState(() {});
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: _createCameraImage,
        ),
        body: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    VlcPlayer(
                      aspectRatio: 16 / 9,
                      url: "rtsp://admin:admin@192.168.100.155:554/mode=real&idc=1&ids=1",
                      controller: _videoViewController,
                      placeholder: Container(
                        height: 250.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[CircularProgressIndicator()],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: _buildController(_videoViewController),
                    )                  ],
                ),
              ),
            ),

            FlatButton(
              child: Text("Change URL"),
              onPressed: () => _videoViewController.setStreamUrl("http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_2160p_60fps_normal.mp4"),
            ),

            FlatButton(
              onPressed: () {
                _videoViewController.stop();
                // if(_videoViewController.buffering == true) print("Hello");
                // else print(_videoViewController.playing);
              },
              child: Text("Stop"),
            ),

            FlatButton(
              onPressed: () {
                _videoViewController.pause();
                // if(_videoViewController.buffering == true) print("Hello");
                // else print(_videoViewController.playing);
              },
              child: Text("Pause"),
            ),

            FlatButton(
              onPressed: () {
                if (!_videoViewController.playing) _videoViewController.play();
              },
              child: Text("Play"),
            ),

            Text("current=" + _videoViewController.currentTime.toString() + ", max=" + _videoViewController.totalTime.toString() + ", speed=" + _videoViewController.playbackSpeed.toString()),
            Text("ratio=" + _videoViewController.aspectRatio.toString()),

            Expanded(
              child: image == null
                  ? Container()
                  : Container(
                decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(image))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildController(VlcPlayerController controller) {
    return Opacity(
      opacity: 0.6,
      child: Material(
        color: Colors.black,
        child: Container(
          // width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                color: Colors.white,
                iconSize: 15,
                icon: controller.playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                onPressed: () {
                  controller.playing ? controller.pause() : controller.play();
                },
              ),
              IconButton(
                color: Colors.white,
                iconSize: 15,
                icon: Icon(Icons.fullscreen),
                onPressed: () {

                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _createCameraImage() async {
    Uint8List file = await _videoViewController.makeSnapshot();
    setState(() {
      image = file;
    });
  }
}
