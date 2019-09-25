//
//  UIControl+Debugo.m
//  StaticTableView
//
//  Created by ripper on 2019/9/25.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "UIControl+Debugo.h"
#import <objc/runtime.h>

@implementation DGReceiver

- (void)receiveAction:(id)sender {
    if (self.handler) {
        self.handler(sender);
    }
}

@end

@implementation UIControl (DGStaticProvider)

static const void * kAssociatedObjectKey_receivers = &kAssociatedObjectKey_receivers;
- (NSMutableArray<DGReceiver *> *)dg_receivers {
    NSMutableArray *array = objc_getAssociatedObject(self, kAssociatedObjectKey_receivers);
    if (!array) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, kAssociatedObjectKey_receivers, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

- (DGReceiver *)dg_addReceiverForControlEvents:(UIControlEvents)controlEvents handler:(void (^)(id _Nonnull))handler {
    DGReceiver *receiver = [DGReceiver new];
    receiver.handler = handler;
    receiver.controlEvents = controlEvents;
    [self addTarget:receiver action:@selector(receiveAction:) forControlEvents:controlEvents];
    [self.dg_receivers addObject:receiver];
    return receiver;
}

- (void)dg_removeReceiver:(DGReceiver *)receiver {
    if ([self.dg_receivers containsObject:receiver]) {
        [self removeTarget:receiver action:@selector(receiveAction:) forControlEvents:receiver.controlEvents];
        [self.dg_receivers removeObject:receiver];
    }
}

- (void)dg_removeAllReceivers {
    [self.dg_receivers enumerateObjectsUsingBlock:^(DGReceiver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self dg_removeReceiver:obj];
    }];
}

@end
