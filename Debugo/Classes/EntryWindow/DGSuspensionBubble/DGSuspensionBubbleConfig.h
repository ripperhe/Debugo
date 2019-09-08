//
//  DGSuspensionBubbleConfig.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface DGSuspensionBubbleConfig : NSObject

@property (nonatomic, assign) UIButtonType buttonType;
@property (nonatomic, assign) CGFloat leanStateAlpha;
@property (nonatomic, assign) BOOL showClickAnimation;
@property (nonatomic, assign) BOOL showLongPressAnimation;

+ (instancetype)defaultConfig;

@end
