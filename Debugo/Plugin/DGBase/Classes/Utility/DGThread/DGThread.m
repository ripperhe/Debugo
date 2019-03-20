//
//  DGThread.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/22.
//  Copyright © 2019 ripper. All rights reserved.
//


#import "DGThread.h"

void dg_dispatch_main_sync_safe(void(^block)(void)) {
    if (NSThread.isMainThread) {
        block();
    }else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

void dg_dispatch_main_async_safe(void(^block)(void)) {
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        block();
    }else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}


