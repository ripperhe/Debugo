//
//  DGStaticRow.m
//  StaticTableView
//
//  Created by ripper on 2019/9/25.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGStaticRow.h"

@implementation DGStaticRow

+ (instancetype)row:(void (^)(DGStaticRow * _Nonnull))block {
    DGStaticRow *obj = [self new];
    block(obj);
    return obj;
}

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = [NSString stringWithFormat:@"cell_%p", self];
    }
    return _identifier;
}

@end
