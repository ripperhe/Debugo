//
//  DGLogTypeModel.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGLogTypeModel.h"

@implementation DGLogTypeModel

- (BOOL)isValid {
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, typeID: %d>", NSStringFromClass([self class]), self, self.typeID];
}

@end
