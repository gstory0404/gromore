//
//  GromoreBannerAd.m
//  gromore
//
//  Created by gstory on 2022/8/12.
//

#import "GromoreBannerAd.h"
#import "ABUAdSDK/ABUBannerAd.h"
#import "ABUUIViewController+getCurrentVC.h"
#import "ABUAdSDK/ABUAdSDK.h"
#import "GroLogUtil.h"
#import "MJExtension.h"

#pragma mark - GromoreNativeAdFactory

@implementation GromoreBannerAdFactory{
    NSObject<FlutterBinaryMessenger>*_messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    GromoreBannerAd * bannerAd = [[GromoreBannerAd alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return bannerAd;
}
@end

@interface GromoreBannerAd()<ABUBannerAdDelegate>
@property (nonatomic, strong) ABUBannerAd *bannerAd;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) NSInteger viewId;
@property(nonatomic,strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,assign) NSInteger width;
@property(nonatomic,assign) NSInteger height;
@end

#pragma mark - GromoreBannerAd
@implementation GromoreBannerAd

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        NSDictionary *dic = args;
        self.frame = frame;
        self.viewId = viewId;
        self.codeId = dic[@"iosId"];
        self.width =[dic[@"width"] intValue];
        self.height =[dic[@"height"] intValue];
        NSString* channelName = [NSString stringWithFormat:@"com.gstory.gromore/BannerAdView_%lld", viewId];
        self.channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        self.container = [[UIView alloc] initWithFrame:frame];
        [self loadNativeAd];
    }
    return self;
}

- (UIView*)view{
    return  self.container;
}

-(void)loadNativeAd{
    [self.container removeFromSuperview];
    self.bannerAd = [[ABUBannerAd alloc] initWithAdUnitID:self.codeId rootViewController:[UIViewController jsd_getRootViewController] adSize:CGSizeMake(self.width, self.height)];
    self.bannerAd.delegate = self;
    // 是否使用模板广告，只对支持模板广告的第三方SDK有效，默认为NO，仅在广告加载前设置有效，优先以平台配置为准
    self.bannerAd.getExpressAdIfCan = YES;
    //图片大小，包括视频媒体的大小设定
    self.bannerAd.imageOrVideoSize = CGSizeMake(self.width, self.height);
    //是否静音播放视频，是否真实静音由adapter确定，默认为YES，仅在广告加载前设置有效，优先以平台配置为准
    self.bannerAd.startMutedIfCan = YES;
    //当前配置拉取成功，直接loadAdData
    if ([ABUAdSDKManager configDidLoad]) {
        [self.bannerAd loadAdData];
    } else {
        //当前配置未拉取成功，在成功之后会调用该callback
        [ABUAdSDKManager addConfigLoadSuccessObserver:self withAction:^(id  _Nonnull observer) {
            [self.bannerAd loadAdData];
        }];
    }
}

# pragma mark ---<ABUBannerAdDelegate>---

/// banner广告加载成功回调
/// @param bannerAd 广告操作对象
/// @param bannerView 广告视图
- (void)bannerAdDidLoad:(ABUBannerAd *)bannerAd bannerView:(UIView *)bannerView{
    [[GroLogUtil sharedInstance] print:@"横幅广告加载成功回调"];
    [self.container addSubview:bannerView];
    NSDictionary *dictionary = @{@"width": @(bannerView.frame.size.width),@"height":@(bannerView.frame.size.height)};
    [self.channel invokeMethod:@"onShow" arguments:dictionary result:nil];
}

/// 广告加载失败回调
/// @param bannerAd 广告操作对象
/// @param error 错误信息
- (void)bannerAd:(ABUBannerAd *)bannerAd didLoadFailWithError:(NSError *_Nullable)error{
    [[GroLogUtil sharedInstance] print:@"横幅广告加载失败回调"];
    NSInteger code = error.code;
    NSString *message = error.userInfo;
    NSDictionary *dictionary = @{@"code":@(code),@"message":message};
    [self.channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}

/// 广告加载成功后为「混用的信息流自渲染广告」时会触发该回调，提供给开发者自渲染的时机
/// @param bannerAd 广告操作对象
/// @param canvasView 携带物料的画布，需要对其内部提供的物料及控件做布局及设置UI
/// @warning 轮播开启时，每次轮播到自渲染广告均会触发该回调，并且canvasView为其他回调中bannerView的子控件
- (void)bannerAdNeedLayoutUI:(ABUBannerAd *)bannerAd canvasView:(ABUCanvasView *)canvasView{
    
}

/// 广告展示回调
/// @param bannerAd 广告操作对象
/// @param bannerView 广告视图
- (void)bannerAdDidBecomeVisible:(ABUBannerAd *)bannerAd bannerView:(UIView *)bannerView{
    NSString *str = [NSString stringWithFormat:@"横幅广告展示 %@",bannerAd.getShowEcpmInfo.mj_keyValues];
    [[GroLogUtil sharedInstance] print:str];
    [self.channel invokeMethod:@"onAdInfo" arguments:bannerAd.getShowEcpmInfo.mj_keyValues result:nil];
}

/// 即将弹出广告详情页
/// @param ABUBannerAd 广告操作对象
/// @param bannerView 广告视图
- (void)bannerAdWillPresentFullScreenModal:(ABUBannerAd *)ABUBannerAd bannerView:(UIView *)bannerView{
    [[GroLogUtil sharedInstance] print:@"横幅广告详情页或appstore打开"];
}

/// 详情广告页将要关闭
/// @param ABUBannerAd 广告操作对象
/// @param bannerView 广告视图
- (void)bannerAdWillDismissFullScreenModal:(ABUBannerAd *)ABUBannerAd bannerView:(UIView *)bannerView{
    [[GroLogUtil sharedInstance] print:@"横幅广告详情页或appstore关闭"];
}

/// 广告点击事件回调
/// @param ABUBannerAd 广告操作对象
/// @param bannerView 广告视图
- (void)bannerAdDidClick:(ABUBannerAd *)ABUBannerAd bannerView:(UIView *)bannerView{
    [[GroLogUtil sharedInstance] print:@"横幅广告点击"];
    [self.channel invokeMethod:@"onClick" arguments:nil result:nil];
}

/// 广告关闭回调
/// @param ABUBannerAd 广告操作对象
/// @param bannerView 广告视图
/// @param filterwords 不喜欢广告的原因，由adapter开发者配置，可能为空
- (void)bannerAdDidClosed:(ABUBannerAd *)ABUBannerAd bannerView:(UIView *)bannerView dislikeWithReason:(NSArray<NSDictionary *> *_Nullable)filterwords{
    [[GroLogUtil sharedInstance] print:@"横幅广告关闭"];
    [self.container removeFromSuperview];
    [self.channel invokeMethod:@"onClose" arguments:nil result:nil];
}

@end
