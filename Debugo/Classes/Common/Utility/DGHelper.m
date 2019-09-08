//
//  DGCurrentUser.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGHelper.h"
#import "DGLog.h"

NSString * dg_current_user() {
    static NSString *_currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [NSString stringWithFormat:@"%s", __FILE__];
        if ([path hasPrefix:@"/Users/"]) {
            NSArray *components = [path componentsSeparatedByString:@"/"];
            if (components.count > 3) {
                _currentUser = components[2];
            }
        }
        DGCLog(@"dg_current_user: %@", _currentUser);
    });
    return _currentUser;
}

void dg_dispatch_main_safe(void(^block)(void)) {
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        block();
    }else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
