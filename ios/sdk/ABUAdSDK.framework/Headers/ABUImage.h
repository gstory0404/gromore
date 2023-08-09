//
//  ABUImage.h
//  BUAdSDK
//
//  Copyright © 2017 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABUImage : NSObject
// image.If is nil,Please use imageURL as the standard to display image.
@property (nonatomic, copy, nullable) UIImage *image;

// image address URL
@property (nonatomic, copy, nullable) NSURL *imageURL;

// image width
@property (nonatomic, assign) float width;

// image height
@property (nonatomic, assign) float height;

// image scale
@property (nonatomic, assign) float scale;

@end

NS_ASSUME_NONNULL_END
