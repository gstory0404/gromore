import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gromore/gromore.dart';
import 'package:gromore/gromore_code.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/10 16:23
/// @Email gstory0404@gmail.com
/// @Description: stream

const EventChannel gromoreEventEvent =
    EventChannel("com.gstory.gromore/adevent");

class GromoreStream {
  ///
  /// # 注册stream监听原生返回的信息
  ///
  /// [rewardAdCallBack] 激励广告回调
  ///
  /// [interactionAdCallBack] 插屏广告回调
  ///
  static StreamSubscription initAdStream(
      {GromoreRewardCallBack? gromoreRewardCallBack}) {
    StreamSubscription groStream =
        gromoreEventEvent.receiveBroadcastStream().listen((data) {
      switch (data[GromoreAdType.adType]) {
        case GromoreAdType.rewardAd:
          switch(data[GromoreAdMethod.onAdMethod]){
            case GromoreAdMethod.onShow:
              if(gromoreRewardCallBack?.onShow != null) {
                gromoreRewardCallBack?.onShow!();
              }
              break;
            case GromoreAdMethod.onClose:
              if(gromoreRewardCallBack?.onClose != null){
                gromoreRewardCallBack?.onClose!();
              }
              break;
            case GromoreAdMethod.onFail:
              if(gromoreRewardCallBack?.onFail != null){
                gromoreRewardCallBack?.onFail!(data["code"], data["message"]);
              }
              break;
            case GromoreAdMethod.onClick:
              if(gromoreRewardCallBack?.onClick != null){
                gromoreRewardCallBack?.onClick!();
              }
              break;
            case GromoreAdMethod.onVerify:
              if(gromoreRewardCallBack?.onVerify != null){
                gromoreRewardCallBack?.onVerify!(data["verify"],data["transId"],data["rewardName"],data["rewardAmount"]);
              }
              break;
            case GromoreAdMethod.onReady:
              if(gromoreRewardCallBack?.onReady != null){
                gromoreRewardCallBack?.onReady!();
              }
              break;
            case GromoreAdMethod.onUnReady:
              if(gromoreRewardCallBack?.onUnReady != null){
                gromoreRewardCallBack?.onUnReady!();
              }
              break;
          }
          break;
      }
    });
    return groStream;
  }

  ///销毁stream
  static void deleteAdStream(StreamSubscription stream) {
    stream.cancel();
  }
}
