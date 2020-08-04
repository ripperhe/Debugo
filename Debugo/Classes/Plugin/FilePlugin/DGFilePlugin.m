//
//  DGFilePlugin.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGFilePlugin.h"
#import "DGCommon.h"
#import "DGFileViewController.h"

@implementation DGFilePlugin

+ (NSString *)pluginName {
    return @"文件";
}

+ (UIImage *)pluginImage {
    return [DGBundle imageNamed:@"plugin_file"];
}

+ (UIImage *)pluginTabBarImage:(BOOL)isSelected {
    if (isSelected) {
        return [DGBundle imageNamed:@"tab_file_selected"];
    }
    return [DGBundle imageNamed:@"tab_file_normal"];
}

+ (UIViewController *)pluginViewController {
    return [DGFileViewController new];
}

#pragma mark -

static DGFilePlugin *_instance;
+ (instancetype)shared {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (DGFilePluginConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [DGFilePluginConfiguration new];
    }
    return _configuration;
}

@end
