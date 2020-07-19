//
//  DGWindow.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGWindow.h"
#import "DebugoEnable.h"
#import "DGTool.h"

#define BoolString(boolValue) (boolValue?@"YES":@"NO")

@implementation DGWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (@available(iOS 13.0, *)) {
            // iOS13不设置无法显示
            self.windowScene = dg_mainWindowScene();
            
            // 关闭深色模式
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }

        // 防止旋转时四周有黑边
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)destroy {
    self.hidden = YES;
    if (self.rootViewController.presentedViewController) {
        [self.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    self.rootViewController = nil;
}

- (NSString *)description {
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
#if DebugoCanBeEnabled
// Prevent influence status bar
- (bool)_canAffectStatusBarAppearance {
    return self.dg_canAffectStatusBarAppearance;
}

// Prevent becoming keywindow
- (bool)_canBecomeKeyWindow {
    return self.dg_canBecomeKeyWindow;
}

// Prevent the system add self to [UIApplication sharedApplication].windows
- (bool)isInternalWindow {
    return self.dg_isInternalWindow;
}
#endif

@end
