//
//  DGTouchMonitor.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#if __has_include("DGPluginEnable.h")
    #import "DGPluginEnable.h"
#endif

#ifndef DGTouchMonitorCanBeEnabled
    #define DGTouchMonitorCanBeEnabled DEBUG
#endif


#import <Foundation/Foundation.h>

@interface DGTouchMonitor : NSObject

@property (nonatomic, assign) BOOL shouldDisplayTouches;

+ (instancetype)shared;

@end
