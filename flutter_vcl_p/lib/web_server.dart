import 'package:flutter/services.dart';
import 'dart:async';

const String WEB_SERVER_CHAN = "com.vungle.vcltool/webserver";
const String SERVER_URL = "serverURL";
const String END_CARD_NAME = "endCardName";

const String WEB_SERVER_CALLBACK_CHAN = "com.vungle.vcltool/webserverCallbacks";
const String END_CARD_UPLOADED = "endcardUploaded";

abstract class WebServerListener {
  onEndCardUploaded(String zipName);
}

class WebServer {
  String serverURL;
  static final shared = WebServer();
  List<WebServerListener> _listeners = [];

  final webServerChan = MethodChannel(WEB_SERVER_CHAN);
  final webServerCallbackChan = MethodChannel(WEB_SERVER_CALLBACK_CHAN);

  WebServer();

  start() {
    webServerCallbackChan.setMethodCallHandler((call) {
      _listeners.forEach((listener) {
        listener.onEndCardUploaded(call.arguments);
      });
    });
  }

  Future<String> getWebServerURL() async {
    if(serverURL != null) {
      return serverURL;
    }
    serverURL = await webServerChan.invokeMethod(SERVER_URL);
    return serverURL;
  }

  Future<String> getEndCardName() async {
    return await webServerChan.invokeMethod(END_CARD_NAME);
  }

  addListener(WebServerListener listener) {
    _listeners.add(listener);
  }

  removeListener(WebServerListener listener) {
    _listeners.remove(listener);
  }



}