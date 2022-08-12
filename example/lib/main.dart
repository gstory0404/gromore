import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gromore/gromore.dart';
import 'package:gromore/gromore_stream.dart';
import 'package:gromore_example/banner_page.dart';
import 'package:gromore_example/native_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IndexPage(),
    );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  bool _init = false;
  String _version = "";

  StreamSubscription? _adStream;

  @override
  void initState() {
    super.initState();
    _initSDK();
    _adStream = GromoreStream.initAdStream(
        //激励广告
        gromoreRewardCallBack: GromoreRewardCallBack(onShow: () {
      print("激励广告显示");
    }, onClick: () {
      print("激励广告点击");
    }, onFail: (GromoreError error) {
      print("激励广告失败 ${error.toJson()}");
    }, onClose: () {
      print("激励广告关闭");
    }, onReady: () async {
      print("激励广告预加载准备就绪");
      await Gromore.showRewardAd();
    }, onUnReady: () {
      print("激励广告预加载未准备就绪");
    }, onVerify: (GromoreVerify verify) {
      print("激励广告奖励 ${verify.toJson()}");
    }, onAdInfo: (GromoreAdInfo info) {
      print("激励相关信息 ${info.toJson()}");
    }));
  }

  //注册
  void _initSDK() async {
    _init = await Gromore.register(
      //gromore广告 Android appid 必填
      androidAppId: "5205916",
      //gromore广告 ios appid 必填
      iosAppId: "5205916",
      //是否debug  上线改为false
      debug: true,
    );
    print("sdk初始化 $_init");
    _version = await Gromore.sdkVersion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gromore插件demo"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: false,
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                child: Text("初始化状态>>>>>> ${_init ? "成功" : "失败"}"),
              ),
              Container(
                alignment: Alignment.center,
                height: 50,
                child: Text("SDK版本>>>>>> $_version"),
              ),
              //动态信息流/横幅/视频贴片广告
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('激励广告'),
                onPressed: () async {
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
                },
              ),
              //信息流广告
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('信息流广告'),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const NativePage();
                  }));
                },
              ),
              //横幅广告
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('横幅广告'),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const BannerPage();
                  }));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_adStream != null) {
      GromoreStream.deleteAdStream(_adStream!);
    }
    super.dispose();
  }
}
