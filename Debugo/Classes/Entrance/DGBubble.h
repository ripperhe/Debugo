//
//  DGBubble.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGWindow.h"

@interface DGBubbleConfig : NSObject

@property (nonatomic, assign) UIButtonType buttonType;
@property (nonatomic, assign) BOOL showClickAnimation;
@property (nonatomic, assign) BOOL showLongPressAnimation;

@end

@interface DGBubble : DGWindow

@property (nonatomic, strong, readonly) DGBubbleConfig *config;
/// 内容视图
@property (nonatomic, weak, readonly) UIView *contentView;
/// 默认 button
@property (nonatomic, weak, readonly) UIButton *button;

@property (nonatomic, copy) void(^clickBlock)(DGBubble *bubble);
@property (nonatomic, copy) void(^longPressStartBlock)(DGBubble *bubble);
@property (nonatomic, copy) void(^longPressEndBlock)(DGBubble *bubble);
@property (nonatomic, copy) void(^panStartBlock)(DGBubble *bubble);
@property (nonatomic, copy) void(^panEndBlock)(DGBubble *bubble);

- (instancetype)initWithFrame:(CGRect)frame config:(DGBubbleConfig *)config;

/// 显示
- (void)show;

/// 销毁
- (void)removeFromScreen;

@end


