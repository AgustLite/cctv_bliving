import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/cplayer.dart';
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
         _videoViewController.play();
      }
    );
     _videoViewController.addListener((){
       setState(() {});
     });

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
                child:
                
                Stack(
                  children: <Widget>[
                    VlcPlayer(
                      aspectRatio: 16 / 9,
                      title: "rtsp vid",
                      url: "rtsp://admin:admin@192.168.100.57:554/mode=real&idc=1&ids=1",
                      controller: _videoViewController,
                      placeholder: Container(
                        height: 250.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[CircularProgressIndicator()],
                        ),
                      ),
                    )
                    ],
                ),
              ),
            ),

            FirstRoute(),

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

//            Text("current=" + _videoViewController.currentTime.toString() + ", max=" + _videoViewController.totalTime.toString() + ", speed=" + _videoViewController.playbackSpeed.toString()),
//            Text("ratio=" + _videoViewController.aspectRatio.toString()),

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

  void _createCameraImage() async {
    Uint8List file = await _videoViewController.makeSnapshot();
    setState(() {
      image = file;
    });
  }
}
class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: FlatButton(
          child: Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CPlayer(
                title: "rtsp vid",
                  url: "rtsp://admin:admin@192.168.100.57:554/mode=real&idc=1&ids=1"
              )),
            );
          },
        ),
      );
  }
}
