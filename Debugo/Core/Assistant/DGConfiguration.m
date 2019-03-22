//
//  DGConfiguration.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGConfiguration.h"
#import "DGCache.h"
#import "DGAssistant.h"

@implementation DGConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isFullScreen = [DGCache.shared.settingPlister boolForKey:kDGSettingIsFullScreen];
        _isOpenFPS = [DGCache.shared.settingPlister boolForKey:kDGSettingIsOpenFPS];
        _isShowTouches = [DGCache.shared.settingPlister boolForKey:kDGSettingIsShowTouches];
        _accountEnvironmentIsBeta = YES;
        _shortcutForDatabaseURLs = @[DGFilePath.documentsDirectoryURL];
        _shortcutForAnyURLs = @[DGFilePath.userDefaultsPlistFileURL];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DGConfiguration *obj = [[DGConfiguration alloc] init];
    if (obj) {
        obj.commonTestActions = [self.commonTestActions copyWithZone:zone];
        
        obj.shortcutForDatabaseURLs = [self.shortcutForDatabaseURLs copyWithZone:zone];
        obj.shortcutForAnyURLs = [self.shortcutForAnyURLs copyWithZone:zone];
        
        obj.isFullScreen = self.isFullScreen;
        obj.isOpenFPS = self.isOpenFPS;
        obj.isShowTouches = self.isShowTouches;
        
        obj.needLoginBubble = self.needLoginBubble;
        obj.haveLoggedIn = self.haveLoggedIn;
        obj.accountEnvironmentIsBeta = self.accountEnvironmentIsBeta;
        obj.commonBetaAccounts = [self.commonBetaAccounts copyWithZone:zone];
        obj.commonOfficialAccounts = [self.commonOfficialAccounts copyWithZone:zone];
    }
    return obj;
}

#pragma mark - test action
- (void)setCommonTestActions:(NSArray<DGTestAction *> *)commonTestActions {
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
- (void)setCommonBetaAccounts:(NSArray<DGAccount *> *)commonBetaAccounts {
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

- (void)setCommonOfficialAccounts:(NSArray<DGAccount *> *)commonOfficialAccounts {
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
