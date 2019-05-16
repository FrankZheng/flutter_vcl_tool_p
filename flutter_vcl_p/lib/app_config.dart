import 'package:flutter/services.dart';

const APP_CONFIG_CHAN = "com.vungle.vcltool/appConfig";
const CURRENT_SDK_VERSION = "currentSDKVersion";
const SDK_VERSIONS = "sdkVersions";
const SET_CURRENT_SDK_VERSION = "setCurrentSDKVersion";
const IS_CORS_ENABLED = "isCORsEnabled";
const SET_CORS_ENABLED = "setCORsEnabled";
const VERIFY_JS_CALLS = "verifyJsCalls";
const SET_VERIFY_JS_CALLS = "setVerifyJsCalls";

class AppConfig {
  static final shared = AppConfig();

  final chan = MethodChannel(APP_CONFIG_CHAN);
  AppConfig();

  Future<String> getCurrentSDKVersion() async {
    return await chan.invokeMethod(CURRENT_SDK_VERSION);
  }

  Future<List<String>> getSDKVersions() async {
    List<dynamic> versions = await chan.invokeMethod(SDK_VERSIONS);
    var res = <String>[];
    versions.forEach((e) {
      res.add(e as String);
    });
    return res;
  }

  void setCurrentSDKVersion(String version) {
    chan.invokeMethod(SET_CURRENT_SDK_VERSION, version);
  }

  Future<bool> isCORsEnabled() async {
    return await chan.invokeMethod(IS_CORS_ENABLED);
  }

  void setCORsEnabled(bool enabled) {
    chan.invokeMethod(SET_CORS_ENABLED, enabled);
  }

  Future<bool> isVerifyJsCallRequired() async {
    return chan.invokeMethod(VERIFY_JS_CALLS);
  }

  void setVerifyJsCallRequired(bool enabled) {
    chan.invokeMethod(SET_VERIFY_JS_CALLS, enabled);
  }

}