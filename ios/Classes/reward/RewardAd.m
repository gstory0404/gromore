//
//  RewardAd.m
//  gromore
//
//  Created by gstory on 2022/8/10.
//

#import "RewardAd.h"
#import "ABUAdSDK/ABURewardedVideoAd.h"
#import "ABUUIViewController+getCurrentVC.h"
#import "GroLogUtil.h"
#import "GromoreEvent.h"
#import "ABUAdSDK/ABUAdapterRewardAdInfo.h"

@interface RewardAd()<ABURewardedVideoAdDelegate>

@property(nonatomic,strong) ABURewardedVideoAd *reward;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,strong) NSString *rewardName;
@property(nonatomic,assign) NSInteger rewardAmount;
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *extra;

@end

@implementation RewardAd

+ (instancetype)sharedInstance{
    static RewardAd *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[RewardAd alloc]init];
    }
    return myInstance;
}

//预加载激励广告
-(void)initAd:(NSDictionary*)arguments{
    NSDictionary *dic = arguments;
    self.codeId = dic[@"iosId"];
    self.rewardName = dic[@"rewardName"];
    self.rewardAmount = [dic[@"rewardAmount"] intValue];
    self.userId =dic[@"userID"];
    self.extra = dic[@"extra"];
    // gdt和穿山甲激励服务端校验需要赋值ABURewardedVideoModel
    ABURewardedVideoModel *model = [[ABURewardedVideoModel alloc] init];
    model.userId = self.userId;
    model.rewardName = self.rewardName;
    model.rewardAmount = self.rewardAmount;
    model.extra = self.extra;
    self.reward = [[ABURewardedVideoAd alloc] initWithAdUnitID:_codeId];
    self.reward.delegate = self;
    self.reward.mutedIfCan = true;
    [self.reward loadAdData];
}

//展示广告
-(void)showAd{
    if(self.reward == nil){
        NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onUnReady"};
        [[GromoreEvent sharedInstance] sentEvent:dictionary];
    }else{
        if (self.reward.isReady) {
            [self.reward showAdFromRootViewController:[UIViewController jsd_getCurrentViewController]];
        }else{
            NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onFail",@"code":@(-1),@"message":@"广告不可用，请重新拉取"};
            [[GromoreEvent sharedInstance] sentEvent:dictionary];
        }
    }
}

#pragma mark - 广告请求delegate

//广告加载成功
//当次加载成功标识/可调用show的条件(大多在线播放)/加载数据统计
- (void)rewardedVideoAdDidLoad:(ABURewardedVideoAd *)rewardedVideoAd{
    [[GroLogUtil sharedInstance] print:@"激励广告加载成功"];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onReady"};
    [[GromoreEvent sharedInstance] sentEvent:dictionary];
}

//广告加载失败
//当次加载失败标识/重新加载条件/加载数据统计/失败原因排查
- (void)rewardedVideoAd:(ABURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error{
    [[GroLogUtil sharedInstance] print:@"激励广告加载失败"];
    NSInteger code = error.code;
    NSString *message = error.userInfo;
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onFail",@"code":@(code),@"message":message};
    [[GromoreEvent sharedInstance] sentEvent:dictionary];
}

//广告缓存(视频)成功
//视频缓存成功标识/可调用show的条件(离线播放更流畅)
- (void)rewardedVideoAdDidDownLoadVideo:(ABURewardedVideoAd *)rewardedVideoAd{
    [[GroLogUtil sharedInstance] print:@"激励广告缓存(视频)成功"];
}

//广告渲染失败
//当次渲染失败标识/重新加载条件/失败原因排查
- (void)rewardedVideoAdViewRenderFail:(ABURewardedVideoAd *_Nonnull)rewardedVideoAd error:(NSError * __nullable)error{
    [[GroLogUtil sharedInstance] print:@"激励广告渲染失败"];
    NSInteger code = error.code;
    NSString *message = error.userInfo;
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onFail",@"code":@(code),@"message":message};
    [[GromoreEvent sharedInstance] sentEvent:dictionary];
}

//广告展示成功
//当次展示标识/自定义预缓存时机(参见5.7.3.1.1)/展示数据统计
- (void)rewardedVideoAdDidVisible:(ABURewardedVideoAd *)rewardedVideoAd{
    [[GroLogUtil sharedInstance] print:@"激励广告展示成功"];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onShow"};
    [[GromoreEvent sharedInstance] sentEvent:dictionary];
}

//广告展示失败
//当次展示失败标识/重新加载条件/失败原因排查
- (void)rewardedVideoAdDidShowFailed:(ABURewardedVideoAd *)rewardedVideoAd error:(NSError *)error{
    [[GroLogUtil sharedInstance] print:@"激励广告展示失败"];
    NSInteger code = error.code;
    NSString *message = error.userInfo;
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onFail",@"code":@(code),@"message":message};
    [[GromoreEvent sharedInstance] sentEvent:dictionary];
}

//广告点击事件
//点击数据统计
- (void)rewardedVideoAdDidClick:(ABURewardedVideoAd *)rewardedVideoAd{
    [[GroLogUtil sharedInstance] print:@"激励广告点击"];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onClick"};
    [[GromoreEvent sharedInstance] sentEvent:dictionary];
}

//广告跳过事件
//点击数据统计
- (void)rewardedVideoAdDidSkip:(ABURewardedVideoAd *)rewardedVideoAd{
    [[GroLogUtil sharedInstance] print:@"激励广告跳过"];
}

//广告关闭
//广告销毁/自定义预缓存时机(参见5.7.3.1.1)
- (void)rewardedVideoAdDidClose:(ABURewardedVideoAd *)rewardedVideoAd{
    [[GroLogUtil sharedInstance] print:@"激励广告关闭"];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onClose"};
    [[GromoreEvent sharedInstance] sentEvent:dictionary];
}

//奖励发放的标识(包括adn的C2C/S2S)
//标识奖励发放的条件
- (void)rewardedVideoAdServerRewardDidSucceed:(ABURewardedVideoAd *)rewardedVideoAd rewardInfo:(ABUAdapterRewardAdInfo *)rewardInfo verify:(BOOL)verify{
 
   
    NSString *transId = rewardInfo.tradeId;
    if(transId == nil){
        transId = @"";
    }
    NSString *rewardAmount = [NSNumber numberWithInt:rewardInfo.rewardAmount];
    NSString *rewardName = rewardInfo.rewardName;
    NSString *rewardVerify = [NSNumber numberWithBool:verify];
    NSString * logs = [NSString stringWithFormat:@"激励奖励发放==>verify=%@,transId=%@,rewardAmount=%@,rewardName=%@", rewardVerify,transId,rewardAmount,rewardName];
    [[GroLogUtil sharedInstance] print:logs];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onVerify",@"verify":rewardVerify,@"transId":transId,@"rewardAmount":rewardAmount,@"rewardName":rewardName};
      [[GromoreEvent sharedInstance] sentEvent:dictionary];
}

//视频播放结束(可能因为错误非正常结束)
//标识播放结束(包括播放错误)/问题排查
- (void)rewardedVideoAd:(ABURewardedVideoAd *)rewardedVideoAd didPlayFinishWithError:(NSError *)error{
    [[GroLogUtil sharedInstance] print:@"视频播放结束(可能因为错误非正常结束)"];
    NSInteger code = error.code;
    NSString *message = error.userInfo;
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onFail",@"code":@(code),@"message":message};
    [[GromoreEvent sharedInstance] sentEvent:dictionary];
}
@end
