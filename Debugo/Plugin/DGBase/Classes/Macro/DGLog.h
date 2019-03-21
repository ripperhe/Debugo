//
//  DGLog.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/20.
//  Copyright © 2019 ripper. All rights reserved.
//

#ifndef DGLog_h
#define DGLog_h

#import "NSDate+Debugo.h"

#if DEBUG
    #define DGLog(format, ...)  do { fprintf(stderr,"☄️ [%s ● %s ● %d] %s ● %s\n", [NSDate date].dg_dateString.UTF8String, ([NSString stringWithFormat:@"%s", __FILE__].lastPathComponent).UTF8String, __LINE__, NSStringFromSelector(_cmd).UTF8String, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);} while (0)
#else
    #define DGLog(...)
#endif

#define DGLogSelf DGLog(@"%@", self)
#define DGLogFunction DGLog(@"")

#endif /* DGLog_h */
