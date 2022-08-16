#import "GromorePlugin.h"
#import "ABUAdSDK/ABUAdSDKManager.h"
#import "GromoreRewardAd.h"
#import "GroLogUtil.h"
#import "GromoreEvent.h"
#import "GromoreNativeAd.h"
#import "GromoreBannerAd.h"

@implementation GromorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"gromore"
                                     binaryMessenger:[registrar messenger]];
    GromorePlugin* instance = [[GromorePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    //注册event
    [[GromoreEvent sharedInstance]  initEvent:registrar];
    //注册native
    [registrar registerViewFactory:[[GromoreNativeAdFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.gstory.gromore/NativeAdView"];
    //注册banner
    [registrar registerViewFactory:[[GromoreBannerAdFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.gstory.gromore/BannerAdView"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    //初始化
    if ([@"register" isEqualToString:call.method]) {
        BOOL debug = [call.arguments[@"debug"] boolValue];
        [[GroLogUtil sharedInstance] debug:debug];
        if(debug){
            [ABUAdSDKManager setLoglevel:ABUAdSDKLogLevelDebug language:ABUAdSDKLogLanguageCH];
        }else{
            [ABUAdSDKManager setLoglevel:ABUAdSDKLogLevelNone language:ABUAdSDKLogLanguageCH];
        }
        NSString *appId = call.arguments[@"iosAppId"];
        //        NSDictionary *didDic = @{ @"device_id": @"1234567" };
        [ABUAdSDKManager setupSDKWithAppId:appId config:^ABUUserConfig *(ABUUserConfig *c) {
            c.logEnable = YES;
            //              c.extraDeviceMap = didDic;
            return c;
        }];
        result(@YES);
        //获取sdk版本号
    }else if([@"sdkVersion" isEqualToString:call.method]){
        NSString *version = [ABUAdSDKManager SDKVersion];
        result(version);
        //预加载激励广告
    }else if([@"loadRewardAd" isEqualToString:call.method]){
        [[GromoreRewardAd sharedInstance] initAd:call.arguments];
        result(@YES);
        //显示激励广告
    }else if([@"showRewardAd" isEqualToString:call.method]){
        [[GromoreRewardAd sharedInstance] showAd];
        result(@YES);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
