import 'package:flutter/services.dart';

const SDK_CHANNEL_NAME = 'com.vungle.vcltool/sdk';
const SDK_CALLBACKS_CHANNEL_NAME = 'com.vungle.vcltool/sdkCallbacks';
const SDK_CHANNEL_METHOD_START = 'start';
const SDK_CHANNEL_METHOD_LOAD_AD = 'loadAd';
const SDK_CHANNEL_METHOD_PLAY_AD = 'playAd';

const METHOD_RETURN_VALUE = "return";
const ERROR_CODE = "errCode";
const ERROR_MESSAGE = "errMsg";

class VungleException implements Exception {
  final int code;
  final String message;
  VungleException(this.message, [this.code = 0]);
}


abstract class VungleSDKListener {
  void onSDKInitialized(VungleException e);

  void onAdLoaded(String placementId, VungleException e);

  void onAdDidPlay(String placementId, VungleException e);

  void onAdDidClose(String placementId, bool completed, bool isCTAClicked);
}


class VungleSDK {
  final VungleSDKListener listener;

  VungleSDK([this.listener]);

  final channel = MethodChannel('com.vungle.vcltool/sdk');
  final callbackChannel =  MethodChannel('com.vungle.vcltool/sdkCallbacks');

  start(String appId) async {
    const method = 'start';

    //register callbacks
    callbackChannel.setMethodCallHandler(_onCallback);

    final Map<String, dynamic> result = await channel.invokeMethod(method, appId);
    if(result.containsKey(METHOD_RETURN_VALUE)) {
      bool returned = result[METHOD_RETURN_VALUE] as bool;
      VungleException e;
      if(!returned) {
        //try to get error code and error msg
        if(result.containsKey(ERROR_MESSAGE)) {
          final errorMsg = result[ERROR_MESSAGE] as String;
          if (result.containsKey(ERROR_CODE)) {
            final errorCode = result[ERROR_CODE] as int;
            e = VungleException(errorMsg, errorCode);
          } else {
            e = VungleException(errorMsg);
          }
        } else {
          e = VungleException("unknown error");
        }
      }
      if(listener != null) {
        listener.onSDKInitialized(e);
      }
    }
  }

  loadAd(String placementId) {

  }

  playAd(String placementId) {

  }

  Future<dynamic> _onCallback(MethodCall call) async {
    switch (call.method) {
      case SDK_CHANNEL_METHOD_START:
        print("got start callbacks: ${call.arguments}");
        return null;
    }
  }
}