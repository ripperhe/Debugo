//
//  DGCache.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGPlister.h"

extern NSString * const kDGSettingIsShowBottomBarWhenPushed;
extern NSString * const kDGSettingIsOpenFPS;
extern NSString * const kDGSettingIsShowTouches;

@interface DGCache : NSObject

/** Setting plist:
 * kDGSettingIsShowBottomBarWhenPushed
 * kDGSettingIsOpenFPS
 * kDGSettingIsShowTouches
 */
@property (nonatomic, strong, readonly) DGPlister *settingPlister;

/** Account plist */
@property (nonatomic, strong, readonly) DGPlister *accountPlister;

+ (instancetype)shared;

@end
