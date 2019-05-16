import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'web_server.dart';
import 'sdk_manager.dart';
import 'dart:async';

class HomeView extends StatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> implements WebServerListener, SDKDelegate {

  String _serverURL = "";
  String _endCardName = "";
  bool _playButtonEnabled = false;
  String _sdkVersion = "";

  final WebServer _webServer = WebServer.shared;
  final SDKManager _sdkManager = SDKManager.shared;
  bool _playingAd = false;

  void _onPlayButtonClicked() {
    _sdkManager.playAd();
  }


  @override
  void sdkDidInitialize() {

  }

  @override
  onServerURLAvailable(String serverURL) {
    setState(() {
      _serverURL = serverURL;
    });
  }


  @override
  onEndCardUploaded(String zipName) {
    if (!_playingAd) {

      new Timer(Duration(microseconds: 100), () {
        _sdkManager.loadAd();
      });

      setState(() {
        _endCardName = zipName;
        _playButtonEnabled = false;
      });
    }

  }

  @override
  void initState() {
    super.initState();

    _sdkManager.addDelegate(this);
    _sdkManager.getSDKVersion().then((v) {
      setState(() {
        _sdkVersion = v;
      });
    });

    if(_webServer.serverURL != null) {
      _serverURL = _webServer.serverURL;
    }

    _webServer.addListener(this);
    _webServer.start();
    _webServer.getEndCardName().then((name) {
      if(name != null ) {
        _sdkManager.loadAd();
        setState(() {
          _endCardName = name;
        });
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
    _webServer.removeListener(this);
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

  @override
  void onAdLoaded() {
    setState(() {
      _playButtonEnabled = true;
    });
  }

  @override
  void onAdDidPlay() {

    setState(() {
      _playingAd = true;
      _playButtonEnabled = false;
    });
  }

  @override
  void onAdDidClose() {
    setState(() {
      _playingAd = false;
    });
    new Timer(Duration(seconds: 1), () {
       _sdkManager.loadAd();
    });
  }

  @override
  void onSDKLog(String message) {

  }

}
