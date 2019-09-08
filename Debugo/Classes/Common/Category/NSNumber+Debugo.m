//
//  NSNumber+Debugo.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/3/20.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "NSNumber+Debugo.h"

@implementation NSNumber (Debugo)

- (NSString *)dg_sizeString {
    double convertedValue = [self doubleValue];
    if (convertedValue <= 0) return @"0 byte";

    static NSArray *_unitArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _unitArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB"];
    });
    
    int idx = 0;
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        idx++;
    }
    NSString *str = [NSString stringWithFormat:@"%.2f",convertedValue];
    if ([str hasSuffix:@".00"]) {
        str = [str substringToIndex:str.length - 3];
    }
    return [str stringByAppendingFormat:@" %@", _unitArray[idx]];
}

@end
