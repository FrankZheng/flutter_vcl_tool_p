import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'home_view.dart';
import 'log_view.dart';
import 'settings_view.dart';

import 'sdk_manager.dart';
import 'web_server.dart';



void main() {
  //initialize sdk
  WebServer.shared.getWebServerURL().then((url) {
    if(url != null) {
      SDKManager.shared.start(url);
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt),
                  title: Text('Log'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ]
          ),
          tabBuilder: (BuildContext context, int index) {
            switch(index) {
              case 0:
                return CupertinoTabView(builder: (context) {
                  return HomeView();
                });
              case 1:
                return CupertinoTabView(builder: (context) {
                  return LogView();
                });
              case 2:
                return CupertinoTabView(builder: (context) {
                  return SettingsView();
                });
            }
          }
      ),
    );
  }
}
