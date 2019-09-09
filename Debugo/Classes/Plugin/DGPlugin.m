//
//  DGPlugin.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/9.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPlugin.h"
#import "DGCommon.h"

@implementation DGPlugin

+ (NSString *)pluginName {
    return NSStringFromClass([self class]);
}

+ (UIImage *)pluginImage {
    return [DGBundle imageNamed:@"app"];
}

+ (void)pluginSetupWithConfiguration:(id)configuration {
}

+ (Class)pluginViewControllerClass {
    return nil;
}

+ (BOOL)pluginCanFire {
    return YES;
}

+ (BOOL)pluginIsFire {
    return NO;
}

+ (void)pluginFire {
}

+ (void)pluginStop {
}

+ (void)pluginCloseWindow {
}

@end
