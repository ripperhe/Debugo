//
//  DGSuspensionContainer.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGSuspensionContainer.h"
#import "DGSuspensionView.h"

#define BoolString(boolValue) (boolValue?@"YES":@"NO")

@implementation DGSuspensionContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = 1000000;
        // 防止旋转时四周有黑边
        self.clipsToBounds = YES;
    }
    return self;
}

- (NSString *)description
{
    NSString *description = [super description];
    NSString *newDescription = [NSString stringWithFormat:@"%@; name = %@; level = %.0f; hidden = %@; isKey = %@>",
                                [description substringToIndex:description.length - 1],
                                self.name,
                                self.windowLevel,
                                BoolString(self.isHidden),
                                BoolString(self.isKeyWindow)];
    return newDescription;
}

#pragma mark - private api
#if DGSuspensionViewCanBeEnabled
// Prevent influence status bar
- (bool)_canAffectStatusBarAppearance
{
    return self.dg_canAffectStatusBarAppearance;
}

// Prevent becoming keywindow
- (bool)_canBecomeKeyWindow
{
    return self.dg_canBecomeKeyWindow;
}

// Prevent the system add self to [UIApplication sharedApplication].windows
//- (bool)isInternalWindow
//{
//    return YES;
//}
#endif

@end
