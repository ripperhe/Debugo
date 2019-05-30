//
//  DGTouchMonitor.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGTouchMonitor : NSObject

@property (nonatomic, assign) BOOL shouldDisplayTouches;

+ (instancetype)shared;

@end
