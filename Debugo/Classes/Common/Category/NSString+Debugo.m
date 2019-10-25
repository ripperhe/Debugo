//
//  NSString+Debugo.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/25.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "NSString+Debugo.h"

@implementation NSString (Debugo)

+ (NSString *)dg_stringByCombineComponents:(NSArray<NSString *> *)components separatedString:(NSString *)separatedString {
    if (!components.count) {
        return nil;
    }
    NSMutableString *string = [NSMutableString string];
    [components enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendString:obj];
        if (separatedString.length && idx != components.count - 1) {
            [string appendString:separatedString];
        }
    }];
    return string;
}

@end
