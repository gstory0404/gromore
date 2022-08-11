import 'package:flutter/material.dart';
import 'package:gromore/gromore.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/11 16:39
/// @Email gstory0404@gmail.com
/// @Description: 信息流

class NativePage extends StatefulWidget {
  const NativePage({Key? key}) : super(key: key);

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("信息流广告"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GroMoreNativeAd(
              //android广告id
              androidId: "",
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
            GroMoreNativeAd(
              androidId: "",
              iosId: "102110836",
              width: 400,
              height: 200,
            ),
            GroMoreNativeAd(
              androidId: "",
              iosId: "102110836",
              width: 800,
              height: 600,
            )
          ],
        ),
      ),
    );
  }
}
