//
//  DGSuspensionView.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGSuspensionContainer.h"
#import "DGSuspensionViewEnable.h"
#import "DGSuspensionViewConfig.h"
#import "DGSuspensionViewController.h"
#import "DGSuspensionManager.h"

@class DGSuspensionView;
@protocol DGSuspensionViewDelegate <NSObject>
@optional
- (void)suspensionViewClick:(DGSuspensionView *)suspensionView;
- (void)suspensionViewLongPressStart:(DGSuspensionView *)suspensionView;
- (void)suspensionViewLongPressEnd:(DGSuspensionView *)suspensionView;
- (void)suspensionViewPanStart:(DGSuspensionView *)suspensionView;
- (void)suspensionViewPanEnd:(DGSuspensionView *)suspensionView;

@end

@interface DGSuspensionView : DGSuspensionContainer

@property (nonatomic, weak) id<DGSuspensionViewDelegate> dg_delegate;
@property (nonatomic, strong, readonly) DGSuspensionViewConfig *config;

/** Backgouround view. Add subview to this view */
@property (nonatomic, weak, readonly) UIView *contentView;
/** Button view */
@property (nonatomic, weak, readonly) UIButton *button;

+ (instancetype)defaultSuspensionView;
+ (instancetype)suspensionViewWithFrame:(CGRect)frame config:(DGSuspensionViewConfig *)config;

//- (void)updateConfig:(void(^)(DGSuspensionViewConfig *config))configBlock;

/**
 *  Show
 */
- (void)show;

/**
 *  Remove and dealloc
 */
- (void)removeFromScreen;

@end


