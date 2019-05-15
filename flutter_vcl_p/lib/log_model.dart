import 'dart:async';
import 'package:flutter/services.dart';

const LOG_CHAN = "com.vungle.vcltool/logModel";
const LOGS = "logs";
const LOG_CALLBACK_CHAN = "com.vungle.vcltool/logModelCallback";
const NEW_LOGS = "newLogs";
const CLEAR_LOGS = "clearLogs";

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

  LogModelListener listener;

  final logChan = MethodChannel(LOG_CHAN);
  final logCallbackChan = MethodChannel(LOG_CALLBACK_CHAN);

  LogModel();

  start() {
    logCallbackChan.setMethodCallHandler((call) {
      if(call.method == NEW_LOGS) {
        if(listener != null) {
          listener.onNewLogs();
        }
      }
    });
  }

  Future<List<LogItem>> getLogs() async {
    final List<dynamic> res = await logChan.invokeMethod(LOGS);
    var logs = <LogItem>[];
    res.forEach((map) {
      if (map.containsKey("type")) {
        String type = map["type"];
        String message = map["message"];
        List<String> stack = [];
        if(map.containsKey("stack")) {
          List<dynamic> s = map["stack"];
          s.forEach((ss) {
            stack.add(ss as String);
          });

        }
        switch(type) {
          case "log":
            logs.add(new JSLog(message, DateTime.now()));
            break;
          case "error":
            logs.add(new JSError(message, DateTime.now(), map["name"], stack));
            break;
          case "trace":
            logs.add(new JSTrace(message, DateTime.now(), stack));
            break;
          case "sdk":
            logs.add(new SDKLog(message, DateTime.now()));
            break;
          default:
            break;
        }
      }
    });
    return logs;
  }

  clearLogs() {
    logChan.invokeMethod(CLEAR_LOGS);
  }





}