//
//  DGUIMagic.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGUIMagic.h"
#import "DebugoEnable.h"
#import "DGCommon.h"

@implementation DGUIMagic

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
        if ([dg_invoke(window, canBecomeSEL, nil) boolValue] == NO) {
            continue;
        }
        return window;
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
    // private api
#if DebugoCanBeEnabled
    NSArray *allWindowsComponents = @[@"al", @"lWindo", @"wsIncl", @"udingInt", @"ernalWin", @"dows:o", @"nlyVisi", @"bleWin", @"dows:"];
    SEL allWindowsSelector = NSSelectorFromString([allWindowsComponents componentsJoinedByString:@""]);
    NSArray *windows = dg_invoke(UIWindow.class, allWindowsSelector, @[@(YES), @(NO)]);
    return windows;
#else
    return nil;
#endif
}

@end
