part of '../gromore.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/11 16:27
/// @Email gstory0404@gmail.com
/// @Description: 信息流广告
///

class GroMoreNativeAd extends StatefulWidget {
  final String androidId;
  final String iosId;
  final int width;
  final int height;
  final GromoreNativeCallBack? callBack;

  ///信息流广告
  ///目前仅支持模版广告
  ///
  /// [androidId] android广告id
  ///
  /// [iosId] ios广告id
  ///
  /// [width] 宽
  ///
  /// [height] 高
  ///
  /// [callBack] 广告回调，具体查看[GromoreNativeCallBack]
  ///
  GroMoreNativeAd(
      {Key? key,
      required this.androidId,
      required this.iosId,
      required this.width,
      required this.height,
      this.callBack})
      : super(key: key);

  @override
  State<GroMoreNativeAd> createState() => _GroMoreNativeAdState();
}

class _GroMoreNativeAdState extends State<GroMoreNativeAd> {

  final String _viewType = "com.gstory.gromore/NativeAdView";
  MethodChannel? _channel;

  //广告是否显示
  bool _isShowAd = true;

  double _width = 0;
  double _height = 0;

  @override
  void initState() {
    super.initState();
    _width = widget.width.toDouble();
    _height = widget.height.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShowAd) {
      return Container();
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        width: _width,
        height: _height,
        child: AndroidView(
          viewType: _viewType,
          creationParams: {
            "androidId": widget.androidId,
            "width": widget.width,
            "height": widget.height,
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        width: _width,
        height: _height,
        child: UiKitView(
          viewType: _viewType,
          creationParams: {
            "iosId": widget.iosId,
            "width": widget.width,
            "height": widget.height,
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else {
      return Container();
    }
  }

  //注册cannel
  void _registerChannel(int id) {
    _channel = MethodChannel("${_viewType}_$id");
    _channel?.setMethodCallHandler(_platformCallHandler);
  }

  //监听原生view传值
  Future<dynamic> _platformCallHandler(MethodCall call) async {
    print("${call.method}===>${call.arguments}");
    switch (call.method) {
    //显示广告
      case GromoreAdMethod.onShow:
        Map map = call.arguments;
        if (mounted) {
          setState(() {
            if(map["width"] != 0){
              _width = map["width"];
            }
            if(map["height"] != 0){
              _height = map["height"];
            }
            _isShowAd = true;
          });
        }
        widget.callBack?.onShow!();
        break;
      //广告加载失败
      case GromoreAdMethod.onFail:
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        Map<String,dynamic> map = call.arguments;
        widget.callBack?.onFail!(GromoreError.fromJson(map));
        break;
      //点击
      case GromoreAdMethod.onClick:
        widget.callBack?.onClick!();
        break;
      //关闭
      case GromoreAdMethod.onClose:
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        widget.callBack?.onClose!();
        break;
    //广告信息
      case GromoreAdMethod.onAdInfo:
        Map<String,dynamic> map = call.arguments;
        widget.callBack?.onAdInfo!(GromoreAdInfo.fromJson(map));
        break;
    }
  }
}