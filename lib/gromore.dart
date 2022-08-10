export 'gromore_code.dart';
export 'gromore_stream.dart';

import 'package:flutter/services.dart';

part 'gromore_callback.dart';

class Gromore {
  static const MethodChannel _channel = MethodChannel('gromore');

  static Future<bool> register({
    required String androidAppId,
    required String iosAppId,
    bool? debug,
  }) async {
    return await _channel.invokeMethod("register", {
      "iosAppId": androidAppId,
      "androidAppId": iosAppId,
      "debug": debug ?? false,
    });
  }

  /// # 获取SDK版本号
  static Future<String> sdkVersion() async {
    return await _channel.invokeMethod("sdkVersion");
  }

  ///
  /// # 激励视频广告预加载
  ///
  /// [androidId] android广告ID
  ///
  /// [iosId] ios广告ID
  ///
  /// [rewardName] 奖励名称
  ///
  /// [rewardAmount] 奖励金额
  ///
  /// [userID] 用户id
  ///
  /// [extra] 扩展参数，服务器回调使用
  ///
  ///
  static Future<bool> loadRewardAd({
    required String androidId,
    required String iosId,
    required String rewardName,
    required int rewardAmount,
    required String userID,
    String? extra,
  }) async {
    return await _channel.invokeMethod("loadRewardAd", {
      "androidId": androidId,
      "iosId": iosId,
      "rewardName": rewardName,
      "rewardAmount": rewardAmount,
      "userID": userID,
      "extra": extra ?? "",
    });
  }

  ///
  /// # 显示激励广告
  ///
  static Future<bool> showRewardAd() async {
    return await _channel.invokeMethod("showRewardAd", {});
  }
}
