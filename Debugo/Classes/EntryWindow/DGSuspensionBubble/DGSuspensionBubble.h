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

@class DGSuspensionBubble;
@protocol DGSuspensionBubbleDelegate <NSObject>
@optional
- (void)suspensionBubbleClick:(DGSuspensionBubble *)suspensionBubble;
- (void)suspensionBubbleLongPressStart:(DGSuspensionBubble *)suspensionBubble;
- (void)suspensionBubbleLongPressEnd:(DGSuspensionBubble *)suspensionBubble;
- (void)suspensionBubblePanStart:(DGSuspensionBubble *)suspensionBubble;
- (void)suspensionBubblePanEnd:(DGSuspensionBubble *)suspensionBubble;

@end

@interface DGSuspensionBubble : DGWindow

@property (nonatomic, weak) id<DGSuspensionBubbleDelegate> dg_delegate;
@property (nonatomic, strong, readonly) DGSuspensionBubbleConfig *config;

/** Backgouround view. Add subview to this view */
@property (nonatomic, weak, readonly) UIView *contentView;
/** Button view */
@property (nonatomic, weak, readonly) UIButton *button;

- (instancetype)initWithFrame:(CGRect)frame config:(DGSuspensionBubbleConfig *)config;

- (void)show;

- (void)removeFromScreen;

@end


