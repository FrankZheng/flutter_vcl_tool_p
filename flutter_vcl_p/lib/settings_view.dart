import 'package:flutter/cupertino.dart';


class SettingsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: Center(
        child: Text(
            'settings'),
      ),
    );
  }
}