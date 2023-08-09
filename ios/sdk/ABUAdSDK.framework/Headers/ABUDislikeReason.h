//
// Created by bytedance on 2022/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABUDislikeReason : NSObject

- (instancetype)initWithID:(nullable NSString *)ID name:(nullable NSString *)name subReasons:(nullable NSArray<ABUDislikeReason *> *)reasons;

@property (nonatomic, copy, readonly, nullable) NSString *ID;

@property (nonatomic, copy, readonly, nullable) NSString *name;

@property (nonatomic, copy, readonly, nullable) NSArray<ABUDislikeReason *> *subReasons;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
