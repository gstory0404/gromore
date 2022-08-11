//
//  GromoreNativeAd.m
//  gromore
//
//  Created by gstory on 2022/8/11.
//

#import "GromoreNativeAd.h"
#import "ABUAdSDK/ABUSize.h"
#import "ABUAdSDK/ABUNativeAdsManager.h"
#import "ABUAdSDK/ABUAdSDK.h"
#import "GroLogUtil.h"
#import "ABUUIViewController+getCurrentVC.h"

#pragma mark - GromoreNativeAdFactory

@implementation GromoreNativeAdFactory{
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
    GromoreNativeAd * nativeAd = [[GromoreNativeAd alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return nativeAd;
}
@end

@interface GromoreNativeAd()<ABUNativeAdsManagerDelegate, ABUNativeAdViewDelegate, ABUNativeAdVideoDelegate>
@property (nonatomic, strong) ABUNativeAdsManager *adManager;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) NSInteger viewId;
@property(nonatomic,strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,assign) NSInteger width;
@property(nonatomic,assign) NSInteger height;
@end

#pragma mark - GromoreNativeAd
@implementation GromoreNativeAd

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        NSDictionary *dic = args;
        self.frame = frame;
        self.viewId = viewId;
        self.codeId = dic[@"iosId"];
        self.width =[dic[@"width"] intValue];
        self.height =[dic[@"height"] intValue];
        NSString* channelName = [NSString stringWithFormat:@"com.gstory.gromore/NativeAdView_%lld", viewId];
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
    if (self.adManager) {
        [self.adManager destory];
    }
    NSString *string = [NSString stringWithFormat:@"width=%d height=%d",self.width,self.height];
    [[GroLogUtil sharedInstance] print:string];
    CGSize size = CGSizeMake(self.width, self.height);
    ABUAdUnit *slot1 = [[ABUAdUnit alloc] init];
    ABUSize *imgSize1 = [[ABUSize alloc] init];
    imgSize1.width = self.width;
    imgSize1.height = self.height;
    slot1.imgSize = imgSize1;
    slot1.ID = self.codeId;
    slot1.getExpressAdIfCan = YES;
    // 如果是模板广告，返回高度将不一定是width，而是按照width和对应代码位在平台的配置计算出的高度
    slot1.adSize =  CGSizeMake(self.width, self.height);
    //v2700开始原生广告支持自渲染和模板类型混出，如果开发者在平台配置了对应代码位的该属性则无需设置；否则开发者需要设置getExpressAdIfCan属性来告知SDK当前广告位下配置的是否为模板类型；平台配置优先于getExpressAdIfCan设置
    //slot1.getExpressAdIfCan = YES;
    // 在getExpressAdIfCan=YES下，如果需要使用gdt express2.0，请设置useExpress2IfCanForGDT=YES;，如果开发者在平台配置了对应代码位的该属性则无需设置；否则开发者需要设置useExpress2IfCanForGDT属性来告知SDK当前广告位下配置的是否为模板2.0；平台配置优先于useExpress2IfCanForGDT设置
    //self.adManager.useExpress2IfCanForGDT = YES;
    self.adManager = [[ABUNativeAdsManager alloc] initWithSlot:slot1];
    self.adManager.rootViewController = [UIViewController jsd_getRootViewController];
    self.adManager.startMutedIfCan = NO;
    self.adManager.delegate = self;
    //该逻辑用于判断配置是否拉取成功。如果拉取成功，可直接加载广告，否则需要调用setConfigSuccessCallback，传入block并在block中调用加载广告。SDK内部会在配置拉取成功后调用传入的block
    //当前配置拉取成功，直接loadAdData
    if ([ABUAdSDKManager configDidLoad]) {
        [self.adManager loadAdDataWithCount:1];
    } else {
        //当前配置未拉取成功，在成功之后会调用该callback
        [ABUAdSDKManager addConfigLoadSuccessObserver:self withAction:^(id  _Nonnull observer) {
            [self.adManager loadAdDataWithCount:1];
        }];
    }

}

# pragma mark ---<ABUNativeAdsManagerDelegate>---
//广告加载成功
//当次加载成功标识/自渲染可展示条件/模板可调用render条件(参见5.2.6)/加载数据统计
- (void)nativeAdsManagerSuccessToLoad:(ABUNativeAdsManager *_Nonnull)adsManager nativeAds:(NSArray<ABUNativeAdView *> *_Nullable)nativeAdViewArray {
    [[GroLogUtil sharedInstance] print:@"信息流广告拉去成功"];
    //取第一条广告载入
    if([nativeAdViewArray count] > 0){
        ABUNativeAdView *view = nativeAdViewArray[0];
        view.rootViewController = [UIViewController jsd_getRootViewController];
        view.delegate = self;
        view.videoDelegate = self;
        if (view.hasExpressAdGot) {
            [view render];
        }
    }
//    for (ABUNativeAdView *view in nativeAdViewArray) {
//        view.rootViewController = [UIViewController jsd_getCurrentViewController];
//        view.delegate = self;
//        view.videoDelegate = self;
//        if (view.hasExpressAdGot) {
//            [view render];
//        }
//        [self.container addSubview:view];
//    }
}

//广告加载失败
//重新加载条件/加载数据统计/问题排查
- (void)nativeAdsManager:(ABUNativeAdsManager *_Nonnull)adsManager didFailWithError:(NSError *_Nullable)error {
    [[GroLogUtil sharedInstance] print:@"信息流拉去失败"];
    NSInteger code = error.code;
    NSString *message = error.userInfo;
    NSDictionary *dictionary = @{@"code":@(code),@"message":message};
    [self.channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}

# pragma mark ---<ABUNativeAdViewDelegate>---
//广告渲染成功(仅针对原生模板)
//当次模板广告可展示条件/模板渲染成功率统计
- (void)nativeAdExpressViewRenderSuccess:(ABUNativeAdView *_Nonnull)nativeExpressAdView {
    [[GroLogUtil sharedInstance] print:@"信息流广告渲染成功"];
    [self.container addSubview:nativeExpressAdView];
    NSDictionary *dictionary = @{@"width": @(nativeExpressAdView.frame.size.width),@"height":@(nativeExpressAdView.frame.size.height)};
    [self.channel invokeMethod:@"onShow" arguments:dictionary result:nil];
}

//广告渲染失败(仅针对原生模板)
//当次模板广告不可展示/模板渲染成功率统计/失败原因排查
- (void)nativeAdExpressViewRenderFail:(ABUNativeAdView *_Nonnull)nativeExpressAdView error:(NSError *_Nullable)error {
    [[GroLogUtil sharedInstance] print:@"信息流广告渲染失败"];
    NSInteger code = error.code;
    NSString *message = error.userInfo;
    NSDictionary *dictionary = @{@"code":@(code),@"message":message};
    [self.channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}

//广告展示
//当次展示标识/自定义预缓存时机/展示数据统计
- (void)nativeAdDidBecomeVisible:(ABUNativeAdView *_Nonnull)nativeAdView {
    [[GroLogUtil sharedInstance] print:@"信息流广告展示"];
}

//广告点击事件
- (void)nativeAdDidClick:(ABUNativeAdView *_Nonnull)nativeAdView withView:(UIView *_Nullable)view {
    [[GroLogUtil sharedInstance] print:@"信息流广告点击"];
    [self.channel invokeMethod:@"onClick" arguments:nil result:nil];
}

//点击广告视图后发送，广告横向视图将呈现模态内容
- (void)nativeAdViewWillPresentFullScreenModal:(ABUNativeAdView *_Nonnull)nativeAdView {
    [[GroLogUtil sharedInstance] print:@"信息流广告全屏内容展示"];
}

//不感兴趣点击
- (void)nativeAdExpressViewDidClosed:(ABUNativeAdView *)nativeAdView closeReason:(NSArray<NSDictionary *> *)filterWords {
    [[GroLogUtil sharedInstance] print:@"信息流广告不感兴趣"];
    [self.container removeFromSuperview];
    nativeAdView = nil;
    [self.channel invokeMethod:@"onClose" arguments:nil result:nil];
}

# pragma mark ---<ABUNativeAdVideoDelegate>---

//播放状态改变(仅三方adn支持的视频广告有)
//根据播放状态作个性化操作
- (void)nativeAdVideo:(ABUNativeAdView *_Nullable)nativeAdView stateDidChanged:(ABUPlayerPlayState)playerState {
    [[GroLogUtil sharedInstance] print:@"信息流广告视频播放状态"];
}

//当点击 videoadview 的结束视图时调用此方法。
- (void)nativeAdVideoDidClick:(ABUNativeAdView *_Nullable)nativeAdView {
    [[GroLogUtil sharedInstance] print:@"信息流广告视频播放点击"];
}

//播放结束
- (void)nativeAdVideoDidPlayFinish:(ABUNativeAdView *_Nullable)nativeAdView {
    [[GroLogUtil sharedInstance] print:@"信息流广告视频播放结束"];
}
@end
