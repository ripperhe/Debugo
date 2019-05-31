//
//  DGSuspensionBubbleManager.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGSuspensionBubbleManager.h"

@interface DGSuspensionBubbleManager ()

@property (nonatomic, strong) NSMutableDictionary *windowDictionary;

@end

@implementation DGSuspensionBubbleManager

static DGSuspensionBubbleManager *_instance;

+ (instancetype)shared {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


#pragma mark - getter
- (NSMutableDictionary *)windowDictionary {
    if (!_windowDictionary) {
        _windowDictionary = [NSMutableDictionary dictionary];
    }
    return _windowDictionary;
}

#pragma mark - public methods

- (UIWindow *)windowForKey:(NSString *)key {
    if (!key.length) {
        NSAssert(0, @"DGSuspensionBubbleManager: 传入的 key 值不对");
        return nil;
    }
    
    return [self.windowDictionary objectForKey:key];
}

- (void)saveWindow:(UIWindow *)window forKey:(NSString *)key {
    if (!key.length) {
        NSAssert(0, @"DGSuspensionBubbleManager: 传入的 key 值不对");
        return;
    }
    if (!window) {
        NSAssert(0, @"DGSuspensionBubbleManager: 不能传入空 window");
        return;
    }
    
    NSAssert([self windowForKey:key] == nil, @"DGSuspensionBubbleManager: 已存在 key=\"%@\" 的 window", key);
    [self.windowDictionary setObject:window forKey:key];
}

- (void)destroyWindowForKey:(NSString *)key {
    UIWindow *window = [self windowForKey:key];
    if (!window) return;
    
    window.hidden = YES;
    if (window.rootViewController.presentedViewController) {
        [window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    window.rootViewController = nil;
    [self.windowDictionary removeObjectForKey:key];
}

- (void)destroyAllWindow {
    NSArray *allKeys = self.windowDictionary.allKeys.copy;
    for (NSString *key in allKeys) {
        [self destroyWindowForKey:key];
    }
}

@end
