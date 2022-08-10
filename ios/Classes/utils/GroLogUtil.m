//
//  GroLogUtil.m
//  gromore
//
//  Created by gstory on 2022/8/10.
//

#import "GroLogUtil.h"
#import <Foundation/Foundation.h>

@interface GroLogUtil()
@property(nonatomic,assign) BOOL isDebug;
@end


@implementation GroLogUtil

+ (instancetype)sharedInstance{
    static GroLogUtil *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[GroLogUtil alloc]init];
    }
    return myInstance;
}

- (void)debug:(BOOL)isDebug{
    _isDebug = isDebug;
}

- (void)print:(NSString *)message{
    if(_isDebug){
        GLog(@"%@", message);
    }
}

@end
