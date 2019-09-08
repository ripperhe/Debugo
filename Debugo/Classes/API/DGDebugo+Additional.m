//
//  DGDebugo+Additional.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGDebugo+Additional.h"
#import "DGCommon.h"

@implementation DGDebugo (Additional)

+ (UIViewController *)topViewController {
    return [DGUIMagic topViewController];
}

+ (UIViewController *)topViewControllerForWindow:(UIWindow *)window {
    return [DGUIMagic topViewControllerForWindow:window];
}

+ (UIWindow *)topVisibleFullScreenWindow {
    return [DGUIMagic topVisibleFullScreenWindow];
}

+ (UIWindow *)keyboardWindow {
    return [DGUIMagic keyboardWindow];
}

+ (NSArray <UIWindow *>*)getAllWindows {
    return [DGUIMagic getAllWindows];
}


@end
