//
//  DGConfiguration.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGConfiguration.h"
#import "DGAssistant.h"
#import "DGCache.h"

@interface DGConfiguration ()
@property (nonatomic, assign) BOOL isInternalConfiguration;
@end

@implementation DGConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isFullScreen = [DGCache.shared.settingPlister boolForKey:@"isFullScreen"];
        _isOpenFPS = [DGCache.shared.settingPlister boolForKey:@"isOpenFPS"];
        _isShowTouches = [DGCache.shared.settingPlister boolForKey:@"isShowTouches"];
        _accountEnvironmentIsBeta = YES;
        _shortcutForDatabaseURLs = @[DGFilePath.documentsDirectoryURL];
        _shortcutForAnyURLs = @[DGFilePath.userDefaultsPlistFileURL];
    }
    return self;
}

#pragma mark - setting
- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    
    if (!self.isInternalConfiguration) return;
    DGAssistant.shared.debugViewController.isFullScreen = isFullScreen;
    [DGCache.shared.settingPlister setBool:isFullScreen forKey:@"isFullScreen"];
}

- (void)setIsOpenFPS:(BOOL)isOpenFPS
{
    _isOpenFPS = isOpenFPS;
    
    if (!self.isInternalConfiguration) return;
    [DGAssistant.shared refreshDebugBubble];
    [DGCache.shared.settingPlister setBool:isOpenFPS forKey:@"isOpenFPS"];
}

- (void)setIsShowTouches:(BOOL)isShowTouches
{
    _isShowTouches = isShowTouches;
    
    if (!self.isInternalConfiguration) return;
    DGTouchMonitor.shared.shouldDisplayTouches = isShowTouches;
    [DGCache.shared.settingPlister setBool:isShowTouches forKey:@"isShowTouches"];
}

#pragma mark - test action
- (void)setCommonTestActions:(NSArray<DGTestAction *> *)commonTestActions {
    if (!self.isInternalConfiguration) {
        _commonTestActions = commonTestActions;
        return;
    }
    
    NSMutableArray *validArray = [NSMutableArray array];
    for (DGTestAction *action in commonTestActions) {
        if (action.isValid) {
            [validArray addObject:action];
        }else{
            NSAssert(0, @"DGTestAction : titile 和 handler 不能为空!");
        }
    }
    _commonTestActions = validArray.copy;
}

#pragma mark - login accout
- (void)setCommonBetaAccounts:(NSArray<DGAccount *> *)commonBetaAccounts
{
    if (!self.isInternalConfiguration) {
        _commonBetaAccounts = commonBetaAccounts;
        return;
    }
    
    NSMutableArray *validArray = [NSMutableArray array];
    for (DGAccount *account in commonBetaAccounts) {
        if (account.isValid) {
            [validArray addObject:account];
        }else{
            NSAssert(0, @"DGAccount : account 和 password 不能为空!");
        }
    }
    _commonBetaAccounts = validArray.copy;
}

- (void)setCommonOfficialAccounts:(NSArray<DGAccount *> *)commonOfficialAccounts
{
    if (!self.isInternalConfiguration) {
        _commonOfficialAccounts = commonOfficialAccounts;
        return;
    }
    
    NSMutableArray *validArray = [NSMutableArray array];
    for (DGAccount *account in commonOfficialAccounts) {
        if (account.isValid) {
            [validArray addObject:account];
        }else{
            NSAssert(0, @"DGAccount : account 和 password 不能为空!");
        }
    }
    _commonOfficialAccounts = validArray.copy;
}

@end
