//
//  DGAccount.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGAccount.h"

@implementation DGAccount

+ (instancetype)accountWithUsername:(NSString *)username password:(NSString *)password; {
    return [[self alloc] initWithUsername:username password:password];
}

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        NSAssert(username.length > 0 && password.length > 0, @"DGAccount: username 和 password 不能为空！");
        self.username = username;
        self.password = password;
    }
    return self;
}

- (BOOL)isValid {
    if (self.username.length > 0 && self.password.length > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, username: %@, password: %@>", NSStringFromClass([self class]), self, self.username, self.password];
}

@end
