//
//  UIView+IB.h
//  Debugo_Example
//
//  Created by ripper on 2018/9/28.
//  Copyright © 2018 ripperhe. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIView (IB)

@property (nonatomic, assign) IBInspectable CGFloat dg_cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat dg_borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *dg_borderColor;

@end

