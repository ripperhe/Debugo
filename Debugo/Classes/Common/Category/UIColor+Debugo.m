//
//  UIColor+Debugo.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/26.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "UIColor+Debugo.h"

@implementation UIColor (Debugo)

+ (UIColor *)dg_randomColor {
    CGFloat r = (CGFloat)(1 + arc4random() % 100) / 100 ;
    CGFloat g = (CGFloat)(1 + arc4random() % 100) / 100 ;
    CGFloat b = (CGFloat)(1 + arc4random() % 100) / 100 ;
    return [self colorWithRed:r green:g blue:b alpha:1];
}

+ (UIColor *)dg_lightRandomColor {
    // rgb 值均为 1，则为白色，让所有值为 0.6以上，则颜色较浅
    int start = 60;
    int length = 40;
    CGFloat r = (CGFloat)(1 + start + arc4random() % length) / 100 ;
    CGFloat g = (CGFloat)(1 + start + arc4random() % length) / 100 ;
    CGFloat b = (CGFloat)(1 + start + arc4random() % length) / 100 ;
    return [self colorWithRed:r green:g blue:b alpha:1];
}

@end
