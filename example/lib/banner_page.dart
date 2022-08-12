import 'package:flutter/material.dart';
import 'package:gromore/gromore.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/12 16:40
/// @Email gstory0404@gmail.com
/// @Description: dart类作用描述

class BannerPage extends StatefulWidget {
  const BannerPage({Key? key}) : super(key: key);

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("横幅广告"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                "穿山甲--->",
                style: TextStyle(color: Colors.orangeAccent, fontSize: 18),
              ),
            ),
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
                  print("横幅广告显示");
                },
                onFail: (GromoreError error) {
                  print("横幅广告失败 ${error.toJson()}");
                },
                onClose: () {
                  print("横幅广告关闭");
                },
                onClick: () {
                  print("横幅广告点击");
                },
                onAdInfo: (GromoreAdInfo info){
                  print("横幅广告相关信息 ${info.toJson()}");
                }
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                "Mintegral--->",
                style: TextStyle(color: Colors.orangeAccent, fontSize: 18),
              ),
            ),
            GromoreBannerAd(
              androidId: "",
              iosId: "102114506",
              width: 400,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
