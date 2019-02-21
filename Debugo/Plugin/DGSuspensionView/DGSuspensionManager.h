//
//  DGSuspensionManager.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DGSuspensionManager : NSObject

+ (instancetype)shared;

/**
 *  Get UIWindow based on key value
 *
 *  @param key key
 *
 *  @return window
 */
- (UIWindow *)windowForKey:(NSString *)key;

/**
 *  Save a window and set the key
 *
 *  @param window window
 *  @param key    key
 */
- (void)saveWindow:(UIWindow *)window forKey:(NSString *)key;

/**
 *  Destroy a window according to key
 *
 *  @param key       key
 */
- (void)destroyWindowForKey:(NSString *)key;

/**
 *  Destroy all window
 */
- (void)destroyAllWindow;

@end
