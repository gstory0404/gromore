//
//  ABUSDKManager.h
//  ABUAdSDK
//
//  Created by Makaiwen on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import "ABUUserConfig.h"
#import "ABUUserInfoForSegment.h"
#import "ABUAdSDKConst.h"
#import "ABUDictionary.h"

@class ABUBaseAd;
NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
/// SDK管理类
@interface ABUAdSDKManager : NSObject

/// GroMore SDK 版本
@property (readonly, class) NSString *SDKVersion;

/// 流量分组信息
@property (nonatomic, strong, readonly) ABUUserInfoForSegment *userInfoForSegment;

/// 初始化GroMore方法，不初始化将无法使用GroMore的相关功能
/// @param appId 在GroMore注册的应用ID
/// @param config 初始化配置回调
+ (void)initSDKWithAppId:(NSString *)appId config:(ABUUserConfig *(^)(ABUUserConfig *))config;

/// 启用GroMore的方法，需要在初始化之后调用才能够正常使用功能
+ (void)setup;

/// 获取初始化时使用的应用ID
+ (NSString *)appID;

/// 配置用户分组信息，可随时更新，但用户分组信息更新将触发配置重新加载，请谨慎使用
/// @param userInfo 分组信息
+ (void)setUserInfoForSegment:(nonnull ABUUserInfoForSegment *)userInfo;

/// 获取当前主题模式
+ (ABUAdSDKThemeStatus)themeStatus;

/// 获取各类补充信息
+ (nullable ABUDictionary *)getGMSDKExtraInfo;

/// 获取配置是否已经加载
+ (BOOL)configDidLoad;

/// 添加配置加载成功回调，该回调会主动触发配置加载，并且仅会回调一次，监听者从内存总消失则不会回调
/// @param observer 配置加载监听者，不会造成强引用，请放心使用
/// @param action 加载成功回调
+ (void)addConfigLoadSuccessObserver:(id _Nonnull)observer withAction:(void(^_Nonnull)(id _Nonnull observer))action;

/// SDK init后更新extraDeviceMap，主要用于初始化时开发者自己的参数还未生成，需后续传入；！！！该接口会覆盖初始化传入的extraDeviceMap，开发者需自己做增量处理
/// @param extraDeviceMap 额外信息
+ (void)updateExtraDeviceMap:(NSDictionary *)extraDeviceMap;

/// 设置广告主题，扩展暗黑模式
+ (void)setThemeStatus:(ABUAdSDKThemeStatus)themeStatus;

/// 设置自定义IDFA，格式需与IDFA格式相同，xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx，官方adapter中CSJ/KS/Klevin支持
+ (void)setCustomIDFA:(nonnull NSString *)customIDFA;

/// 触发首次预缓存,针对特定广告位
/// @param infos 广告对象
/// @param interval 指定每轮请求的时间间隔, 允许时间范围:1-10
/// @param concurrent 并发请求的广告数, 允许个数范围:1-20
+ (void)preloadAdsWithInfos:(NSArray<__kindof ABUBaseAd *> *)infos andInterval:(NSInteger)interval andConcurrent:(NSInteger)concurrent;

@end

NS_ASSUME_NONNULL_END
