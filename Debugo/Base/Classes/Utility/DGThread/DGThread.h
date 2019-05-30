//
//  DGThread.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/22.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 当前主线程，同步执行；当前非主线程，异步执行 */
void dg_dispatch_main_safe(void(^block)(void));

