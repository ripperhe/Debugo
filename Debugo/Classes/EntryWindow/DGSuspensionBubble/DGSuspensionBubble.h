//
//  DGSuspensionBubble.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGWindow.h"
#import "DGSuspensionBubbleConfig.h"

@interface DGSuspensionBubble : DGWindow

@property (nonatomic, strong, readonly) DGSuspensionBubbleConfig *config;

@property (nonatomic, copy) void(^clickBlock)(DGSuspensionBubble *bubble);
@property (nonatomic, copy) void(^longPressStartBlock)(DGSuspensionBubble *bubble);
@property (nonatomic, copy) void(^longPressEndBlock)(DGSuspensionBubble *bubble);
@property (nonatomic, copy) void(^panStartBlock)(DGSuspensionBubble *bubble);
@property (nonatomic, copy) void(^panEndBlock)(DGSuspensionBubble *bubble);

/** Backgouround view. Add subview to this view */
@property (nonatomic, weak, readonly) UIView *contentView;
/** Button view */
@property (nonatomic, weak, readonly) UIButton *button;

- (instancetype)initWithFrame:(CGRect)frame config:(DGSuspensionBubbleConfig *)config;

- (void)show;

- (void)removeFromScreen;

@end


