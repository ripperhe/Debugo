//
//  DGAction.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGAction.h"

@implementation DGAction

+ (instancetype)actionWithTitle:(NSString *)title autoClose:(BOOL)autoClose handler:(DGActionHandlerBlock)handler {
    return [[self alloc] initWithTitle:title autoClose:autoClose handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title autoClose:(BOOL)autoClose handler:(DGActionHandlerBlock)handler {
    self = [super init];
    if (self) {
        NSAssert(title.length > 0 && handler != nil, @"DGAction: titile 和 handler 不能为空!");
        self.title = title;
        self.autoClose = autoClose;
        self.handler = handler;
    }
    return self;
}

- (BOOL)isValid {
    if (self.title.length > 0 && self.handler != nil) {
        return YES;
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, user: %@, title: %@, autioClose: %@, handler: %@>", NSStringFromClass([self class]), self, self.user, self.title, self.autoClose?@"YES":@"NO", self.handler];
}

@end
