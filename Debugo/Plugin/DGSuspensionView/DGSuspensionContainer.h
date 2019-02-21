//
//  DGSuspensionContainer.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface DGSuspensionContainer : UIWindow

@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) UIWindow *lastKeyWindow;

@property (nonatomic, assign) BOOL dg_canAffectStatusBarAppearance;
@property (nonatomic, assign) BOOL dg_canBecomeKeyWindow;

@end
