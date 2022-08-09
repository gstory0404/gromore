import 'package:flutter/services.dart';

class Gromore {
  static const MethodChannel _channel = MethodChannel('gromore');

  static Future<bool> register({
    required String androidAppId,
    required String iosAppId,
  }) async {
    return await _channel.invokeMethod("register", {
      "iosAppId": androidAppId,
      "androidAppId": iosAppId,
    });
  }
}
