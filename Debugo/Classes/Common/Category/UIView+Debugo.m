//
//  UIView+Debugo.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/8.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "UIView+Debugo.h"

@implementation UIView (Debugo)

- (CGFloat)dg_x {
    return self.frame.origin.x;
}

- (void)setDg_x:(CGFloat)dg_x {
    CGRect newframe = self.frame;
    newframe.origin.x = dg_x;
    self.frame = newframe;
}

- (CGFloat)dg_y {
    return self.frame.origin.y;
}

- (void)setDg_y:(CGFloat)dg_y {
    CGRect newframe = self.frame;
    newframe.origin.y = dg_y;
    self.frame = newframe;
}

- (CGFloat)dg_width {
    return self.frame.size.width;
}

- (void)setDg_width:(CGFloat)dg_width {
    CGRect newframe = self.frame;
    newframe.size.width = dg_width;
    self.frame = newframe;
}

- (CGFloat)dg_height {
    return self.frame.size.height;
}

- (void)setDg_height:(CGFloat)dg_height {
    CGRect newframe = self.frame;
    newframe.size.height = dg_height;
    self.frame = newframe;
}

- (CGFloat)dg_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setDg_bottom:(CGFloat)dg_bottom {
    CGRect newframe = self.frame;
    newframe.origin.y = dg_bottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)dg_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setDg_right:(CGFloat)dg_right {
    CGRect newframe = self.frame;
    newframe.origin.x = dg_right - self.frame.size.width;
    self.frame = newframe;
}

- (CGFloat)dg_centerX {
    return self.center.x;
}

- (void)setDg_centerX:(CGFloat)dg_centerX {
    CGPoint newCenter = self.center;
    newCenter.x = dg_centerX;
    self.center = newCenter;
}

- (CGFloat)dg_centerY {
    return self.center.y;
}

- (void)setDg_centerY:(CGFloat)dg_centerY {
    CGPoint newCenter = self.center;
    newCenter.y = dg_centerY;
    self.center = newCenter;
}

- (CGPoint)dg_origin {
    return self.frame.origin;
}

- (void)setDg_origin:(CGPoint)dg_origin {
    CGRect newframe = self.frame;
    newframe.origin = dg_origin;
    self.frame = newframe;
}

- (CGSize)dg_size {
    return self.frame.size;
}

- (void)setDg_size:(CGSize)dg_size {
    CGRect newframe = self.frame;
    newframe.size = dg_size;
    self.frame = newframe;
}

- (UIEdgeInsets)dg_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

@end
