//
//  DGStaticSection.m
//  StaticTableView
//
//  Created by ripper on 2019/9/25.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGStaticSection.h"

@implementation DGStaticSection

+ (instancetype)section:(void (^)(DGStaticSection * _Nonnull))block {
    DGStaticSection *obj = [DGStaticSection new];
    block(obj);
    return obj;
}

- (NSMutableArray *)rows {
    if (!_rows) {
        _rows = [NSMutableArray array];
    }
    return _rows;
}

- (void)addRow:(DGStaticRow *)row; {
    [self.rows addObject:row];
}

- (void)addRowWithBlock:(void (^)(DGStaticRow * _Nonnull))block {
    DGStaticRow *row = [DGStaticRow new];
    block(row);
    [self.rows addObject:row];
}

- (void)addRows:(NSArray<DGStaticRow *> *)rows {
    [self.rows addObjectsFromArray:rows];
}

- (NSString *)headerIdentifier {
    if (!_headerIdentifier) {
        _headerIdentifier = [NSString stringWithFormat:@"header_%p", self];
    }
    return _headerIdentifier;
}

- (NSString *)footerIdentifier {
    if (!_footerIdentifier) {
        _footerIdentifier = [NSString stringWithFormat:@"footer_%p", self];
    }
    return _footerIdentifier;
}

@end
