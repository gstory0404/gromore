//
//  RewardAd.h
//  gromore
//
//  Created by gstory on 2022/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RewardAd : NSObject

+ (instancetype)sharedInstance;
- (void)initAd:(NSDictionary *)arguments;
- (void)showAd;

@end

NS_ASSUME_NONNULL_END
