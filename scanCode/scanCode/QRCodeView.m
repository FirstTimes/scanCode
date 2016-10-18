//
//  QRCodeView.m
//  scanCode
//
//  Created by 李锐 on 16/9/14.
//  Copyright © 2016年 lirui. All rights reserved.
//

#import "QRCodeView.h"

#define CORNERLENGTH 15

@interface QRCodeView()

@property (strong,nonatomic) UIImageView * lineView;

@end

@implementation QRCodeView

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat lineWidth = 8;
    CGFloat lineHeight = 20;

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(ctx, 0.7, 0.7, 0.7, 1);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetRGBStrokeColor(ctx, 0, 1, 0, 1);

    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, 0, lineHeight);

    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, lineHeight, 0);
    
    CGContextMoveToPoint(ctx, width - lineHeight, 0);
    CGContextAddLineToPoint(ctx, width, 0);
    
    CGContextMoveToPoint(ctx, width, 0);
    CGContextAddLineToPoint(ctx, width, lineHeight);
    
    CGContextMoveToPoint(ctx, width, height - lineHeight);
    CGContextAddLineToPoint(ctx, width, height);
    
    CGContextMoveToPoint(ctx, width, height);
    CGContextAddLineToPoint(ctx, width - lineHeight, height);
    
    CGContextMoveToPoint(ctx, lineHeight, height);
    CGContextAddLineToPoint(ctx, 0, height);
    
    CGContextMoveToPoint(ctx, 0, height);
    CGContextAddLineToPoint(ctx, 0, height - lineHeight);
    
    CGContextStrokePath(ctx);
    
//    UIImage * line = [UIImage imageNamed:@"line.png"];
//    
//    CGFloat margin = 10;
//    
//    [line drawInRect:CGRectMake(margin, margin, rect.size.width - margin * 2, 2)];

}


@end
