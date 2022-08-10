//
//  GromoreEvent.m
//  gromore
//
//  Created by gstory on 2022/8/10.
//

#import "GromoreEvent.h"
#import <Flutter/Flutter.h>

@interface GromoreEvent()<FlutterStreamHandler>
@property(nonatomic,strong) FlutterEventSink eventSink;
@end

@implementation GromoreEvent

+ (instancetype)sharedInstance{
    static GromoreEvent *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[GromoreEvent alloc]init];
    }
    return myInstance;
}


- (void)initEvent:(NSObject<FlutterPluginRegistrar>*)registrar{
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"com.gstory.gromore/adevent"   binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:self];
}

-(void)sentEvent:(NSDictionary*)arguments{
    self.eventSink(arguments);
}



#pragma mark - FlutterStreamHandler
- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    self.eventSink = events;
    return nil;
}@end
