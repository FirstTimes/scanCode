//
//  LineView.m
//  scanCode
//
//  Created by 李锐 on 2016/10/15.
//  Copyright © 2016年 lirui. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef sideColor = CGColorCreate(rgbSpace, (CGFloat[]){1.0, 1.0, 1.0, 1.0});
    CGColorRef middleColor = CGColorCreate(rgbSpace, (CGFloat[]){0.0, 1.0, 0.0, 1.0});
    // 创建颜色数组
    CFArrayRef colors = CFArrayCreate(kCFAllocatorDefault, (const void*[]){sideColor, middleColor, sideColor}, 3, nil);
    CGFloat locations[3] = {0, 0.5, 1.0};
    CGGradientRef gradient = CGGradientCreateWithColors(rgbSpace, colors, locations);
    CFRelease(colors);
    
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(rect.size.width, 0), kCGGradientDrawsAfterEndLocation);

    CGColorRelease(sideColor);
    CGColorRelease(middleColor);

    CGGradientRelease(gradient);
}


@end
