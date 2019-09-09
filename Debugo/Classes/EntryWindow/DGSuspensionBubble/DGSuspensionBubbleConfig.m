//
//  DGSuspensionBubbleConfig.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGSuspensionBubbleConfig.h"

@implementation DGSuspensionBubbleConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.buttonType = UIButtonTypeCustom;
        self.leanStateAlpha = 0.9;
        self.showClickAnimation = YES;
        self.showLongPressAnimation = YES;
    }
    return self;
}

- (void)setLeanStateAlpha:(CGFloat)leanStateAlpha {
    if(leanStateAlpha > 1.0) {
        _leanStateAlpha = 1.0;
    }else if (leanStateAlpha < 0) {
        _leanStateAlpha = 0;
    }else{
        _leanStateAlpha = leanStateAlpha;
    }
}

@end
