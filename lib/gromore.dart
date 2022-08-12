export 'gromore_code.dart';
export 'data/gromore_error.dart';
export 'data/gromore_verify.dart';
export 'data/gromore_ad_info.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gromore/data/gromore_ad_info.dart';

import 'gromore.dart';

part 'gromore_callback.dart';
part 'widget/gromore_native_ad_widget.dart';
part 'widget/gromore_banner_ad_widget.dart';

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
