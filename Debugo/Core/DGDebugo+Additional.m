//
//  DGDebugo+Additional.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGDebugo+Additional.h"
#import "DebugoEnable.h"

@implementation DGDebugo (Additional)

+ (UIViewController *)topViewController {
    return [self topViewControllerForWindow:nil];
}

+ (UIViewController *)topViewControllerForWindow:(UIWindow *)window {
    UIWindow *targetWindow = window ?: [UIApplication sharedApplication].delegate.window;
    if (!targetWindow) return nil;
    UIViewController* viewController = targetWindow.rootViewController;
    return [self findBestViewController:viewController];
}

/**
 Reference:
 * http://stackoverflow.com/questions/24825123/get-the-current-view-controller-from-the-app-delegate%EF%BC%89
 */
+ (UIViewController*)findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
}

+ (UIWindow *)topVisibleFullScreenWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows.reverseObjectEnumerator) {
        if (window.hidden == YES || window.opaque == NO) {
            continue;
        }
        if (CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds) == NO) {
            continue;
        }
        NSArray *canBecomeSELComponents = @[@"_ca", @"nBe", @"co", @"meKeyWi", @"ndow"];
        SEL canBecomeSEL = NSSelectorFromString([canBecomeSELComponents componentsJoinedByString:@""]);
        if ([window respondsToSelector:canBecomeSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            BOOL canBecomeKey = (BOOL)[window performSelector:canBecomeSEL];
#pragma clang diagnostic pop
            if (!canBecomeKey) {
                continue;
            }
        }
        return window;
    }
    if ([UIApplication sharedApplication].keyWindow) {
        return [UIApplication sharedApplication].keyWindow;
    }
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        return [UIApplication sharedApplication].delegate.window;
    }
    return nil;
}

+ (UIWindow *)keyboardWindow {
    for (UIWindow *window in [[UIApplication sharedApplication].windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")] && window.hidden == NO && window.alpha > 0) {
            return window;
        }
    }
    return nil;
}

+ (NSArray <UIWindow *>*)getAllWindows {
     __unsafe_unretained NSArray *windows = nil;
    // private api
#if DebugoCanBeEnabled
    BOOL includeInternalWindows = YES;
    BOOL onlyVisibleWindows = NO;
    
    NSArray *allWindowsComponents = @[@"al", @"lWindo", @"wsIncl", @"udingInt", @"ernalWin", @"dows:o", @"nlyVisi", @"bleWin", @"dows:"];
    SEL allWindowsSelector = NSSelectorFromString([allWindowsComponents componentsJoinedByString:@""]);
    
    NSMethodSignature *methodSignature = [[UIWindow class] methodSignatureForSelector:allWindowsSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    invocation.target = [UIWindow class];
    invocation.selector = allWindowsSelector;
    [invocation setArgument:&includeInternalWindows atIndex:2];
    [invocation setArgument:&onlyVisibleWindows atIndex:3];
    [invocation invoke];
    
    [invocation getReturnValue:&windows];
#endif
    return windows;
}


@end
