//
//  DGDebuggingOverlay.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGDebuggingOverlay.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "DebugoEnable.h"
#import "DGCommon.h"

/**
 Reference:
 * https://gist.github.com/IMcD23/1fda47126429df43cc989d02c1c5e4a0
 * http://ryanipete.com/blog/ios/swift/objective-c/uidebugginginformationoverlay/
 * https://www.raywenderlich.com/295-swizzling-in-ios-11-with-uidebugginginformationoverlay
 */

// Used for swizzling on iOS 11+. UIDebuggingInformationOverlay is a subclass of UIWindow
@implementation UIWindow (DocsUIDebuggingInformationOverlaySwizzler)

- (instancetype)swizzle_basicInit {
    return [super init];
}

// [[UIDebuggingInformationOverlayInvokeGestureHandler mainHandler] _handleActivationGesture:(UIGestureRecognizer *)]
// requires a UIGestureRecognizer, as it checks the state of it. We just fake that here.
- (UIGestureRecognizerState)state {
    return UIGestureRecognizerStateEnded;
}

@end


@implementation DGDebuggingOverlay

+ (BOOL)isShowing {
    __block BOOL isShowing = NO;
    // private api
#if DebugoCanBeEnabled
    NSArray *debugInfoComponents = @[@"U", @"IDe", @"bug", @"gin", @"gInfor", @"ma", @"ti", @"onO", @"ver", @"lay"];
    id debugInfoClass = NSClassFromString([debugInfoComponents componentsJoinedByString:@""]);
    
    NSArray <UIWindow *>*allWindows = [DGUIMagic getAllWindows];
    [allWindows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:debugInfoClass]) {
            if (obj.isHidden == NO) {
                isShowing = YES;
            }
        }
    }];
#endif
    return isShowing;
}

+ (void)showDebuggingInformation {
    if ([self isShowing] == NO) {
        [self toggleOverlay];
    }
}

// In iOS 11, Apple added additional checks to disable this overlay unless the
// device is an internal device. To get around this, we swizzle out the
// -[UIDebuggingInformationOverlay init] method (which returns nil now if
// the device is non-internal), and we call:
// [[UIDebuggingInformationOverlayInvokeGestureHandler mainHandler] _handleActivationGesture:(UIGestureRecognizer *)]
// to show the window, since that now adds the debugging view controllers, and calls
// [overlay toggleVisibility] for us.
+ (void)toggleOverlay {
    // private api
#if DebugoCanBeEnabled
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    NSArray *debugInfoComponents = @[@"U", @"IDe", @"bug", @"gin", @"gInfor", @"ma", @"ti", @"onO", @"ver", @"lay"];
    id debugInfoClass = NSClassFromString([debugInfoComponents componentsJoinedByString:@""]);
    
    if (@available(iOS 11.0, *)) {
        NSArray *handlerComponents = @[@"UID", @"ebugg", @"ingIn", @"form", @"atio", @"nOv", @"erla", @"yI", @"nv", @"okeGe", @"stur", @"eHan", @"dler"];
        id handlerClass = NSClassFromString([handlerComponents componentsJoinedByString:@""]);
        
        UIWindow *window = [[UIWindow alloc] init];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // Swizzle init of debugInfo class
            Method originalInit = class_getInstanceMethod(debugInfoClass, @selector(init));
            IMP swizzledInit = [window methodForSelector:@selector(swizzle_basicInit)];
            method_setImplementation(originalInit, swizzledInit);
        });

        id debugOverlayInstance = [debugInfoClass performSelector:NSSelectorFromString(@"overlay")];
        [debugOverlayInstance setFrame:[[UIScreen mainScreen] bounds]];
        
        id handler = [handlerClass performSelector:NSSelectorFromString(@"mainHandler")];
        NSArray *handleGesComponents = @[@"_h", @"andl", @"eAct", @"iv", @"at", @"ionG", @"estur", @"e:"];
        [handler performSelector:NSSelectorFromString([handleGesComponents componentsJoinedByString:@""]) withObject:window];
    } else if(@available(iOS 10.0, *)) {
        id debugOverlayInstance = [debugInfoClass performSelector:NSSelectorFromString(@"overlay")];
        NSArray *toggleComponents = @[@"to", @"ggle", @"Visi", @"bili", @"ty"];
        [debugOverlayInstance performSelector:NSSelectorFromString([toggleComponents componentsJoinedByString:@""])];
    }else{
        NSLog(@"DGDebuggingOverlay: 系统版本不支持");
    }
    
#pragma clang diagnostic pop
#endif
}

@end
