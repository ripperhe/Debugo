//
//  DGThread.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/22.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>

void dg_dispatch_main_sync_safe(void(^block)(void));
void dg_dispatch_main_async_safe(void(^block)(void));

