import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'web_server.dart';
import 'dart:async';

class HomeView extends StatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> implements WebServerListener {

  String _serverURL = "http://192.168.1.68:8091";
  String _endCardName = "bundle1.zip";
  bool _playButtonEnabled = true;
  String _sdkVersion = "v6.4.3";

  final WebServer webServer = WebServer.shared;

  void _onPlayButtonClicked() {
    print('onPlayButtonClicked');
  }


  @override
  onServerURLAvailable(String serverURL) {
    setState(() {
      _serverURL = serverURL;
    });
  }


  @override
  onEndCardUploaded(String zipName) {
    new Timer(Duration(seconds: 2), () {
      setState(() {
        _playButtonEnabled = true;
      });
    });

    setState(() {
      _endCardName = zipName;
      _playButtonEnabled = false;
    });
  }

  @override
  void initState() {
    super.initState();

    if(webServer.serverURL != null) {
      _serverURL = webServer.serverURL;
    }

    webServer.addListener(this);
    webServer.start();
  }


  @override
  void dispose() {
    super.dispose();
    webServer.removeListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Vungle Creative Tool'),
      ),
      child: SafeArea(
          child: Padding(
              padding: EdgeInsets.only(left: 15, top: 30, right: 15, bottom: 15),
              child: Column(
                children: <Widget>[
                  Text(
                    'Please open the browser on your computer and visit following url to upload creatives',
                    style: TextStyle(
                        color: CupertinoColors.activeBlue, fontSize: 20),
                        textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _serverURL,
                    style: TextStyle(
                        color: CupertinoColors.activeGreen, fontSize: 24),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    _endCardName,
                    style: TextStyle(
                        color: CupertinoColors.black, fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CupertinoButton(
                    child: Text('PLAY'),
                    onPressed: _playButtonEnabled ? _onPlayButtonClicked : null,
                  ),
                  Spacer(),
                  Text(
                    'SDK Version: $_sdkVersion',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 18),
                  ),

                ],
              )
          )
      ),
    );
  }
}
