//
//  DGWindow.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGWindow : UIWindow

@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, weak, nullable) UIWindow *lastKeyWindow;

@property (nonatomic, assign) BOOL dg_canAffectStatusBarAppearance;
@property (nonatomic, assign) BOOL dg_canBecomeKeyWindow;
@property (nonatomic, assign) BOOL dg_isInternalWindow;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
