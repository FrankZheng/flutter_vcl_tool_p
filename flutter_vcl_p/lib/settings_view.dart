import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'dart:async';

class AppVersionItem extends StatefulWidget {
  @override
  AppVersionItemState createState() => AppVersionItemState();
}

class AppVersionItemState extends State<AppVersionItem> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      setState(() {
        _appVersion = '${version}_$buildNumber';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Text('App Version'),
      Spacer(),
      Text(_appVersion),
    ]);
  }
}

class SDKVersionItem extends StatefulWidget {
  @override
  SDKVersionItemState createState() => SDKVersionItemState();
}

class SDKVersionItemState extends State<SDKVersionItem> {
  String _currentSDKVersion = '';
  List<String> _sdkVersions = [];

  void _onPressed() {

  }

  @override
  void initState() {
    super.initState();
    //get current sdk version and available sdk versions
    new Timer(Duration(seconds: 1), () {
      setState(() {
        _currentSDKVersion = '6.3.2';
        _sdkVersions = ['6.3.2', '5.3.2'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Text('SDK Version'),
      Spacer(),
      _sdkVersions.length > 1 ?
      CupertinoButton.filled(
        child: Text(_currentSDKVersion),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        onPressed: _onPressed,
      ) : Text(_currentSDKVersion)
    ]);
  }
}

class InspectJSItem extends StatefulWidget {

  @override
  InspectJsItemState createState() => InspectJsItemState();
}

class InspectJsItemState extends State<InspectJSItem> {
  bool _inspectJs;


  @override
  void initState() {
    super.initState();
    //get inspectJs from other model, like config
    new Timer(Duration(seconds: 1), () {
      setState(() {
        _inspectJs = true;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
      var head = Column(children: <Widget>[
        Text('Inspect javascript error'),
        Text('(This will enable CORs)', style: TextStyle(color: CupertinoColors.activeOrange),)
      ],);

      var row = Row(children: <Widget>[
        head,
        Spacer(),
      ],);

      if(_inspectJs != null) {
        row.children.add(CupertinoSwitch(value: _inspectJs, onChanged: (newValue) {
          print('new value: $newValue');
          setState(() {
            _inspectJs = newValue;
          });
        }));
      }
      return row;
  }
}

class VerifyJsCallsItem extends StatefulWidget {

  @override
  VerifyJsCallsItemState createState() => VerifyJsCallsItemState();
}

class VerifyJsCallsItemState extends State<VerifyJsCallsItem> {
  bool _verifyJsCalls;


  @override
  void initState() {
    super.initState();

    new Timer(Duration(seconds: 1), () {
      setState(() {
        _verifyJsCalls = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var row = Row(children: <Widget>[
      SizedBox(width: 200, child: Text('Verify required javascript calls in customized ads'),),
      Spacer(),
    ],);
    if(_verifyJsCalls != null) {
      row.children.add(CupertinoSwitch(value: _verifyJsCalls, onChanged: (newValue) {
        setState(() {
          _verifyJsCalls = newValue;
        });
      }));
    }
    return row;
  }
}

class SettingsView extends StatelessWidget {

  final List<Widget> items = [
    AppVersionItem(),
    SDKVersionItem(),
    InspectJSItem(),
    VerifyJsCallsItem(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
          child: Padding(padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10),
            child: ListView.builder(
              itemCount: items.length * 2,
              itemBuilder: (context, index) {
                if (index % 2 != 0) {
                  return Divider();
                }
                index = index ~/ 2;
                return items[index];
              })
          )

      )
    );
  }
}