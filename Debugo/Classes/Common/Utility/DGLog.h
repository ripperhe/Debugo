//
//  DGLog.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/20.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DebugoEnable.h"
#import "NSDate+Debugo.h"

#if DebugoCanBeEnabled
    #define DGLog(format, ...)  do { printf("[☄️ %s ● %s ● %d] %s ● %s\n", [NSDate date].dg_dateString.UTF8String, ([NSString stringWithFormat:@"%s", __FILE__].lastPathComponent).UTF8String, __LINE__, NSStringFromSelector(_cmd).UTF8String, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);} while (0)
    #define DGCLog(format, ...)  do { printf("[☄️ %s ● %s ● %d] %s ● %s\n", [NSDate date].dg_dateString.UTF8String, ([NSString stringWithFormat:@"%s", __FILE__].lastPathComponent).UTF8String, __LINE__, __func__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);} while (0)
#else
    #define DGLog(...)
    #define DGCLog(...)
#endif

#define DGLogSelf DGLog(@"%@", self)
#define DGLogFunction DGLog(@"")
