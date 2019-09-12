//
//  UIView+Debugo.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/8.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Debugo)

@property (nonatomic, assign) CGFloat dg_x;
@property (nonatomic, assign) CGFloat dg_y;
@property (nonatomic, assign) CGFloat dg_width;
@property (nonatomic, assign) CGFloat dg_height;
@property (nonatomic, assign) CGFloat dg_bottom;
@property (nonatomic, assign) CGFloat dg_right;
@property (nonatomic, assign) CGFloat dg_centerX;
@property (nonatomic, assign) CGFloat dg_centerY;
@property (nonatomic, assign) CGPoint dg_origin;
@property (nonatomic, assign) CGSize dg_size;

- (UIEdgeInsets)dg_safeAreaInsets;

@end

NS_ASSUME_NONNULL_END
