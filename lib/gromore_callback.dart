part of 'gromore.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/10 16:19
/// @Email gstory0404@gmail.com
/// @Description: 定义回调

///显示
typedef GroShow = void Function();

///失败
typedef GroFail = void Function(int code, dynamic message);

///点击
typedef GroClick = void Function();

///跳过
typedef GroSkip = void Function();

///加载超时
typedef GroTimeOut = void Function();

///倒计时结束
typedef GroFinish = void Function();

///关闭
typedef GroClose = void Function();

///广告预加载完成
typedef GroReady = void Function();

///广告预加载未完成
typedef GroUnReady = void Function();

///广告奖励验证
typedef GroVerify = void Function(
    bool verify, String transId, String rewardName, int rewardAmount);

///倒计时
typedef GroAdTick = void Function(int time);

///激励广告回调
class GromoreRewardCallBack {
  GroShow? onShow;
  GroClose? onClose;
  GroFail? onFail;
  GroClick? onClick;
  GroVerify? onVerify;
  GroReady? onReady;
  GroUnReady? onUnReady;

  ///[onShow] 展示
  ///
  /// [onClick] 点击
  ///
  /// [onClose] 关闭
  ///
  /// [onFail] 加载失败  code message
  ///
  /// [onVerify] 播放完成验证奖励 [verify]是否有效 [transId]验证id [rewardName]奖励名称 [rewardAmount]奖励数量
  ///
  /// [onReady] 广告准备就绪
  ///
  /// [onUnReady] 广告尚未准备完成
  ///
  GromoreRewardCallBack(
      {this.onShow,
      this.onClick,
      this.onClose,
      this.onFail,
      this.onVerify,
      this.onReady,
      this.onUnReady});
}

///信息流广告回调
class GromoreNativeCallBack {
  GroShow? onShow;
  GroClose? onClose;
  GroFail? onFail;
  GroClick? onClick;

  ///[onShow] 展示
  ///
  /// [onClick] 点击
  ///
  /// [onClose] 关闭
  ///
  /// [onFail] 加载失败  [code] [message]
  GromoreNativeCallBack({this.onShow, this.onClick, this.onClose, this.onFail});
}

///信息流广告回调
class GromoreBannerCallBack {
  GroShow? onShow;
  GroClose? onClose;
  GroFail? onFail;
  GroClick? onClick;

  ///[onShow] 展示
  ///
  /// [onClick] 点击
  ///
  /// [onClose] 关闭
  ///
  /// [onFail] 加载失败  [code] [message]
  GromoreBannerCallBack({this.onShow, this.onClick, this.onClose, this.onFail});
}
