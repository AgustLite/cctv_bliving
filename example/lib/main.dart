import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/cplayer.dart';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'package:flutter_vlc_player/player/players_with_controls.dart';

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
  double value = 1;

  @override
  void initState() {
    imageKey = new GlobalKey();
    _videoViewController = new VlcPlayerController(onInit: () => _videoViewController.play());
    _videoViewController.addListener(() => setState(() {}));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app'),),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: _createCameraImage,
        ),
        body: Column(
          children: <Widget>[
           PlayerWithControls(
              aspectRatio: 16 / 9,
              title: "RTSP Video Streaming",
              url: "rtsp://admin:admin@192.168.100.67:554/mode=real&idc=1&ids=1",
            ),
            Expanded(
              child: image == null
                  ? Container()
                  : Container(
                decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(image))),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 10),
              child: Text("Hello"), 
              opacity: 1.0,
            )
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
                url: "rtsp://admin:admin@192.168.100.67:554/mode=real&idc=1&ids=1"
              )),
            );
          },
        ),
      );
  }
}
