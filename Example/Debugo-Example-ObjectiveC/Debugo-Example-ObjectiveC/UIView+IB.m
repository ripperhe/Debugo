//
//  UIView+IB.m
//  Debugo_Example
//
//  Created by ripper on 2018/9/28.
//  Copyright © 2018 ripperhe. All rights reserved.
//

#import "UIView+IB.h"

@implementation UIView (IB)

- (void)setDg_cornerRadius:(CGFloat)dg_cornerRadius {
    self.layer.cornerRadius = dg_cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)dg_cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setDg_borderWidth:(CGFloat)dg_borderWidth {
    self.layer.borderWidth = dg_borderWidth;
}

- (CGFloat)dg_borderWidth {
    return self.layer.borderWidth;
}

- (void)setDg_borderColor:(UIColor *)dg_borderColor {
    self.layer.borderColor = dg_borderColor.CGColor;
}

- (UIColor *)dg_borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

@end
