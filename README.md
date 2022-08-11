# 穿山甲gromore聚合广告插件flutter版
<p>
<a href="https://pub.flutter-io.cn/packages/gromore"><img src=https://img.shields.io/badge/gromore-v0.0.1-success></a>
</p>

## 官方文档
* [Android](https://www.csjplatform.com/union/media/union/download/detail?id=75&osType=android&locale=zh-CN)
* [IOS](https://www.csjplatform.com/union/media/union/download/detail?id=79&osType=ios&locale=zh-CN)

## 版本更新

[更新日志](https://github.com/gstory0404/gromore/blob/master/CHANGELOG.md)

## 本地开发环境
```
[✓] Flutter (Channel stable, 3.0.4, on macOS 12.5 21G72 darwin-x64, locale zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0-rc1)
[✓] Xcode - develop for iOS and macOS (Xcode 13.4.1)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2021.2)
[✓] IntelliJ IDEA Ultimate Edition (version 2022.1.1)
[✓] VS Code (version 1.69.2)
[✓] Connected device (3 available)
[✓] HTTP Host Availability
```

## 集成步骤
#### pubspec.yaml
```Dart
gromore: ^0.0.1
//或者使用git版本，体验最新版本
gromore:
    git:
      url: https://github.com/gstory0404/gromore.git
      ref: 46ed91678980dc663326a7b8a667d8133ab30ab1
```
#### 引入
```Dart
import 'package:gromore/gromore.dart';
```

## 使用

### SDK初始化
```Dart
await Gromore.register(
    //gromore广告 Android appid 必填
    androidAppId: "5205916",
    //gromore广告 ios appid 必填
    iosAppId: "5205916",
    //是否debug  上线改为false
    debug: false,
);
```

### 获取SDK版本
```Dart
await Gromore.sdkVersion();
```

### 激励视频广告
预加载激励视频广告
```Dart
await Gromore.loadRewardAd(
    //android广告ID
    androidId: "102110738",
    //ios广告ID
    iosId: "102110738",
    //奖励名称
    rewardName: "奖励100金币",
    //奖励金额
    rewardAmount: 100,
    //扩展参数，服务器回调使用
    extra: "111111",
    //用户id
    userID: "10000");
```
显示激励视频广告
```dart
  await Gromore.showRewardAd();
```
监听激励视频结果

```Dart
GromoreStream.initAdStream(
//激励广告
    gromoreRewardCallBack: GromoreRewardCallBack(
        onShow: () {
          print("激励广告显示");
        },
        onClick: () {
          print("激励广告点击");
        },
        onFail: (code, message) {
          print("激励广告失败 $code $message");
        },
        onClose: () {
          print("激励广告关闭");
        },
        onReady: () async {
          print("激励广告预加载准备就绪");
          await Gromore.showRewardAd();
        },
        onUnReady: () {
          print("激励广告预加载未准备就绪");
        },
        onVerify: (verify, transId, rewardName, rewardAmount) {
          print("激励广告奖励 $verify $transId   $rewardName   $rewardAmount");
        },
    ));
```

### 信息流广告
```dart
GroMoreNativeAd(
     //android广告id
     androidId: "102110836",
     //ios广告id
     iosId: "102110836",
     //宽
     width: 300,
     //高
     height: 200,
     callBack: GromoreNativeCallBack(
          onShow: () {
             print("信息流广告显示");
          },
          onFail: (code,error) {
             print("信息流广告失败 $error");
          },
          onClose: () {
             print("信息流广告关闭");
          },
          onClick: () {
             print("信息流广告点击");
           },
       ),
),
```
