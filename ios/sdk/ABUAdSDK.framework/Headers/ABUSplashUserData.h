//
//  ABUNewSplashUserData.h
//  ABUAdSDK
//
//  Created by bytedance on 2021/7/30.
//

#import <Foundation/Foundation.h>
#import "ABUAdSDKConst.h"

NS_ASSUME_NONNULL_BEGIN

/// 开屏广告兜底数据
@interface ABUSplashUserData : NSObject

/// 对象初始化方法，请尽量使用该方法初始化
/// - Parameters:
///   - adnName: ADN的名称
///   - rit: ADN的代码位
///   - appID: ADN的app id
///   - appKey: ADN的app key
- (instancetype)initWithAdnName:(NSString *)adnName
                            rit:(NSString *)rit
                          appID:(NSString *)appID
                         appKey:(nullable NSString *)appKey;

/// adn的名字，请使用如下值 'pangle','baidu','gdt','ks'，其他值可能导致无法加载广告
@property (nonatomic, copy) NSString *adnName;

// adn对应代码位
@property (nonatomic, copy) NSString *rit;

// adn对应appID
@property (nonatomic, copy) NSString *appID;

// adn对应appKey, 没有时可不传
@property (nonatomic, copy, nullable) NSString *appKey;

@end

NS_ASSUME_NONNULL_END
