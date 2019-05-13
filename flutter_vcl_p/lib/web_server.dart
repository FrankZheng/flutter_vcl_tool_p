import 'dart:async';

abstract class WebServerListener {
  onServerURLAvailable(String serverURL);
  onEndCardUploaded(String zipName);
}

class WebServer {
  String serverURL;
  static final shared = WebServer();
  List<WebServerListener> _listeners = [];

  WebServer();

  start() {
    Timer(Duration(seconds: 1), () {
      _listeners.forEach((listener) {
        listener.onServerURLAvailable('http://192.168.1.88:8888');
      });
    });

    Timer(Duration(seconds: 5), () {
      _listeners.forEach((listener) {
        listener.onEndCardUploaded("some_new_bundle.zip");
      });
    });
  }

  addListener(WebServerListener listener) {
    _listeners.add(listener);
  }

  removeListener(WebServerListener listener) {
    _listeners.remove(listener);
  }



}