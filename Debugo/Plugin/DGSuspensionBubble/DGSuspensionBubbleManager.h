//
//  DGSuspensionBubbleManager.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DGSuspensionBubbleManager : NSObject

+ (instancetype)shared;

- (UIWindow *)windowForKey:(NSString *)key;

- (void)saveWindow:(UIWindow *)window forKey:(NSString *)key;

- (void)destroyWindowForKey:(NSString *)key;

- (void)destroyAllWindow;

@end
