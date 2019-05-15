import 'package:flutter/services.dart';

const String SDK_CHAN = "com.vungle.vcltool/sdk";
const String LOAD_AD = "loadAd";
const String PLAY_AD = "playAd";
const String FORCE_CLOSE_AD = "forceCloseAd";

const String SDK_CALLBACK_CHAN = "com.vungle.vcltool/sdkCallbacks";
const String AD_LOADED = "adLoaded";
const String AD_DID_PLAY = "adDidPlay";
const String AD_DID_CLOSE = "adDidClose";



abstract class SDKDelegate {
  void sdkDidInitialize();
  void onAdLoaded();
  void onAdDidPlay();
  void onAdDidClose();
  void onSDKLog(String message);


}

class SDKManager {
  static final shared = SDKManager();

  final sdkChan = MethodChannel(SDK_CHAN);
  final sdkCallChan = MethodChannel(SDK_CALLBACK_CHAN);

  SDKManager() {
    sdkCallChan.setMethodCallHandler(_onCallback);
  }

  var delegates = <SDKDelegate>[];

  void addDelegate(SDKDelegate delegate) {
    delegates.add(delegate);
  }

  void removeDelegate(SDKDelegate delegate) {
    delegates.remove(delegate);
  }

  Future<void> loadAd() async {
    return await sdkChan.invokeMethod(LOAD_AD);
  }

  Future<void> playAd() async {
    return await sdkChan.invokeMethod(PLAY_AD);
  }

  Future<void> forceCloseAd() async {
    return await sdkChan.invokeMethod(FORCE_CLOSE_AD);
  }

  Future<dynamic> _onCallback(MethodCall call) async {
    switch (call.method) {
      case AD_LOADED:
        delegates.forEach((delegate) {
          delegate.onAdLoaded();
        });
        return;
      case AD_DID_CLOSE:
        delegates.forEach((delegate) {
          delegate.onAdDidClose();
        });
        return;
      case AD_DID_PLAY:
        delegates.forEach((delegate) {
          delegate.onAdDidPlay();
        });
        return;
      default:
        throw MissingPluginException();
    }
  }

}