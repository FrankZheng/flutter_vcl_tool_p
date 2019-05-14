import 'dart:async';


class LogItem {
  final DateTime timestamp;
  final String message;

  LogItem(this.message, this.timestamp);
}

class JSError extends LogItem {
  final String name;
  final List<String> stack;

  JSError(String message, DateTime timestamp, this.name, this.stack) :
        super(message, timestamp);
}

class JSTrace extends LogItem {
  final List<String> stack;
  JSTrace(String message, DateTime timestamp, this.stack) :
        super(message, timestamp);
}

class JSLog extends LogItem {
  JSLog(String message, DateTime timestamp) : super(message, timestamp);
}

class SDKLog extends LogItem {
  SDKLog(String message, DateTime timestamp) : super(message, timestamp);
}

abstract class LogModelListener {
  onNewLogs();
}

class LogModel {
  static final shared = LogModel();

  List<LogItem> logs = [];

  LogModelListener listener;

  LogModel();

  loadLogs() {
    //mock some logs
    var jsLog = new JSLog("Start", DateTime.now());
    var jsError = new JSError(
        "ReferenceError: Can't find variable: not_existed_function",
        DateTime.now(),
        "ReferenceError",
        ["doSomething -- index.html:34:25", "onClick -- index.html:48:12"]);

    var jsTrace = new JSTrace("Trace", DateTime.now(),
        [
          "test_trace -- index.html:40:16",
          "doSomething -- index.html:34:15",
          "onclick -- index.html.html:52:12"
        ]);

    var sdkLog = new SDKLog("SDK initialized ", DateTime.now());

    logs.addAll([jsLog, jsError, jsTrace, sdkLog]);

    new Timer(Duration(seconds: 2), () {
      if(listener != null) {
        listener.onNewLogs();
      }
    });

  }

  clearLogs() {
    logs = [];

    if(listener != null) {
      listener.onNewLogs();
    }
  }





}