//
//  GromoreEvent.h
//  gromore
//
//  Created by gstory on 2022/8/10.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface GromoreEvent : NSObject
+ (instancetype)sharedInstance;
- (void)initEvent:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)sentEvent:(NSDictionary*)arguments;
@end

NS_ASSUME_NONNULL_END
