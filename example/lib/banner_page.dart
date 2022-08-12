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
        title: const Text("信息流广告"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
              ),
            ),
            GromoreBannerAd(
              androidId: "",
              iosId: "102110739",
              width: 400,
              height: 200,
            ),
            GromoreBannerAd(
              androidId: "",
              iosId: "102110739",
              width: 800,
              height: 600,
            )
          ],
        ),
      ),
    );
  }
}


