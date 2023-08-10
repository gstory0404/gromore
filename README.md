# 穿山甲gromore聚合广告插件flutter版

<p>
<a href="https://pub.flutter-io.cn/packages/gromore"><img src=https://img.shields.io/pub/v/gromore?color=orange></a>
<a href="https://pub.flutter-io.cn/packages/gromore"><img src=https://img.shields.io/pub/likes/gromore></a>
<a href="https://pub.flutter-io.cn/packages/gromore"><img src=https://img.shields.io/pub/points/gromore></a>
<a href="https://github.com/gstory0404/gromore/commits"><img src=https://img.shields.io/github/last-commit/gstory0404/gromore></a>
<a href="https://github.com/gstory0404/gromore"><img src=https://img.shields.io/github/stars/gstory0404/gromore></a>
</p>
<p>
<a href="http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=VhD0AZSmzvsD3fu7CeQFkzpBQHMHANb1&authKey=W7JGJ0HKklyhP1jyBvbTF2Dkw0cq4UmhVSx2zXVdIm6n48Xrto%2B7%2B1n9jbkAadyF&noverify=0&group_code=649574038"><img src=https://img.shields.io/badge/flutter%E4%BA%A4%E6%B5%81%E7%BE%A4-649574038-blue></a>
<a href="http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=9I9lyXewEsEnx0f00EOF_9hEcFmG5Bmg&authKey=AJfQ8%2FhOLcoJ0p5B16EITjFav1IIs3UAerZSUsWZfa0evuklgxibHti51AYlZgI3&noverify=0&group_code=769626410"><img src=https://img.shields.io/badge/flutter%E4%BA%A4%E6%B5%81%E7%BE%A42-769626410-blue></a>
</p>

目前仅支持ios 信息流、横幅、激励广告

## 官方文档
* [Android](https://www.csjplatform.com/union/media/union/download/detail?id=75&osType=android&locale=zh-CN)
* [IOS](https://www.csjplatform.com/union/media/union/download/detail?id=79&osType=ios&locale=zh-CN)

## 版本更新

[更新日志](https://github.com/gstory0404/gromore/blob/master/CHANGELOG.md)

## 本地开发环境
```
[✓] Flutter (Channel stable, 3.10.6, on macOS 13.5 22G74 darwin-x64, locale
    zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.1)
[✓] Xcode - develop for iOS and macOS (Xcode 14.3.1)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2022.1)
[✓] IntelliJ IDEA Ultimate Edition (version 2023.2)
[✓] VS Code (version 1.80.2)
[✓] Connected device (4 available)
[✓] Network resources
```

## 说明

### iOS
运行环境配置 
支持系统iOS 10.X 及以上; 
SDK编译环境 Xcode 13.1及以上版本; 

### 插件
当前使用gromore基础库Ads-Mediation-CN_4.3.0.1， 穿山甲ABUAdCsjAdapter_5.3.0.4.0已内置，其他的广告adapter根据文档导入到podfile中

## 集成步骤
#### pubspec.yaml
```Dart
gromore: ^0.0.3
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
        }, onAdInfo: (GromoreAdInfo info) {
          print("激励相关信息 ${info.toJson()}");
      }));
```

### 信息流广告
> 配置广告时请使用模板广告
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
          onAdInfo: (GromoreAdInfo info) {
            print("信息流广告相关信息 ${info.toJson()}");
          }),
),
```

### Banner(横幅)广告
> 配置广告时请使用模板广告
```dart
GromoreBannerAd(
     //android广告id
     androidId: "",
     //ios广告id
     iosId: "102110739",
     //宽
     width: 300,
     //高
     height: 200,
     callBack: GromoreBannerCallBack(
       onShow: () {
          print("banner广告显示");
       },
       onFail: (code,error) {
          print("banner广告失败 $error");
       },
       onClose: () {
          print("banner广告关闭");
       },
       onClick: () {
          print("banner广告点击");
       },
        onAdInfo: (GromoreAdInfo info) {
          print("信息流广告相关信息 ${info.toJson()}");
       }),
   ),
```

### 回调说明

#### GromoreAdInfo
广告加载相关信息
```dart
/// @Description: 广告加载相关信息
/// [adnName] ADN的名称，与平台配置一致，自定义ADN时为ADN唯一标识
/// [customAdnName] 自定义ADN的名称，与平台配置一致，非自定义ADN为nil
/// [slotID]  代码位
/// [levelTag] 价格标签，多阶底价下有效
/// [ecpm] 返回价格，nil为无权限
/// [biddingType] 广告类型
/// [errorMsg] 额外错误信息,一般为空(扩展字段)
/// [requestID]  adn提供的真实广告加载ID，可为空
GromoreAdInfo(
      {this.adnName,
        this.customAdnName,
        this.slotID,
        this.levelTag,
        this.ecpm,
        this.biddingType,
        this.errorMsg,
        this.requestID});
```

#### GromoreError
广告加载错误信息
```dart
/// [code] 错误码
/// [message] 错误信息
GromoreError(
    {this.code,
  this.message});
```

#### GromoreError
激励广告奖励信息
```dart
/// [verify] 是否有效
/// [transId] 验证id
/// [rewardName] 奖励名称
/// [rewardAmount] 奖励数量
GromoreVerify(
    {this.verify,
      this.transId,
      this.rewardName,
      this.rewardAmount});
```

## 插件链接

|插件|地址|
|:----|:----|
|字节穿山甲广告插件|[flutter_unionad](https://github.com/gstory0404/flutter_unionad)|
|腾讯优量汇广告插件|[flutter_tencentad](https://github.com/gstory0404/flutter_tencentad)|
|聚合广告插件|[flutter_universalad](https://github.com/gstory0404/flutter_universalad)|
|百度百青藤广告插件|[flutter_baiduad](https://github.com/gstory0404/flutter_baiduad)|
|字节穿山甲内容合作插件|[flutter_pangrowth](https://github.com/gstory0404/flutter_pangrowth)|
|文档预览插件|[file_preview](https://github.com/gstory0404/file_preview)|
|滤镜|[gpu_image](https://github.com/gstory0404/gpu_image)|
|Gromore聚合广告|[gromore](https://github.com/gstory0404/gromore)|

## 联系方式
* Email: gstory0404@gmail.com
* Blog：https://www.gstory.cn/

* QQ群: <a target="_blank" href="https://qm.qq.com/cgi-bin/qm/qr?k=4j2_yF1-pMl58y16zvLCFFT2HEmLf6vQ&jump_from=webapi"><img border="0" src="//pub.idqqimg.com/wpa/images/group.png" alt="649574038" title="flutter交流"></a>

