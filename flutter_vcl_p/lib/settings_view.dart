import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'app_config.dart';

const COLOR_HEADER = CupertinoColors.black;
const COLOR_TRAILING = CupertinoColors.inactiveGray;


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
      Text('App Version', style: TextStyle(color: COLOR_HEADER),),
      Spacer(),
      Text(_appVersion, style: TextStyle(color: COLOR_TRAILING),),
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

  final _appConfig = AppConfig.shared;

  void _onTap() {

    showCupertinoModalPopup(context: context, builder: (builderContext) {
      return CupertinoActionSheet(
        title: Text("Switch SDK Version"),
        message: Text("Please select which version you want to use?"),
        actions: _sdkVersions.map((v) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(builderContext, v);
            },
            child: Text(v),
            isDestructiveAction: true,
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(builderContext, null);
            }, child: Text('Cancel')),
      );
    }).then((ret) {
      if (ret != null && ret != _currentSDKVersion) {
        showCupertinoDialog(context: context, builder: (builderContext) {
          return CupertinoAlertDialog(
            title: Text('Confirm Switch SDK'),
            content: Text('To switch SDK version, you need restart the app.'),
            actions: <Widget>[
              CupertinoDialogAction(child: Text('OK'), isDestructiveAction: true,
                onPressed:() {
                  Navigator.pop(builderContext, ret);
                }),
              CupertinoDialogAction(child: Text('Cancel'), isDefaultAction: true,
                  onPressed:() {
                    Navigator.pop(builderContext, null);
                  }),
            ],
          );
        }).then((ret) {
          if(ret != null) {
            setState(() {
              _currentSDKVersion = ret;
            });
            _appConfig.setCurrentSDKVersion(ret);
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _appConfig.getCurrentSDKVersion().then((newValue) {
      setState(() {
        _currentSDKVersion = newValue;
      });
    });

    _appConfig.getSDKVersions().then((newValue){
      setState(() {
        _sdkVersions = newValue;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    //if have multiple version, could show forward icon
    //and tap the item could have action show multiple items
    var children = <Widget> [
      Text('SDK Version', style: TextStyle(color: COLOR_HEADER),),
      Spacer(),
      Text(_currentSDKVersion, style: TextStyle(color: COLOR_TRAILING),),
    ];
    if (_sdkVersions.length > 0 ) {
      children.add(
        Icon(CupertinoIcons.forward, color: COLOR_TRAILING,),
      );
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: Row(children: children),
      );
    } else {
      return Row(children: children);
    }

  }
}

class InspectJSItem extends StatefulWidget {

  @override
  InspectJsItemState createState() => InspectJsItemState();
}

class InspectJsItemState extends State<InspectJSItem> {
  bool _inspectJs;
  final _appConfig = AppConfig.shared;


  @override
  void initState() {
    super.initState();
    _appConfig.isCORsEnabled().then((v) {
      setState(() {
        _inspectJs = v;
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
          _appConfig.setCORsEnabled(newValue);
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
  final _appConfig = AppConfig.shared;

  @override
  void initState() {
    super.initState();
    _appConfig.isVerifyJsCallRequired().then((v){
      setState(() {
        _verifyJsCalls = v;
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
        _appConfig.setVerifyJsCallRequired(newValue);
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
              horizontal: 12),
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